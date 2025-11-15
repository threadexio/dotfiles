#!/usr/bin/env python3
from __future__ import annotations
from dataclasses import dataclass, asdict
from cloudflare import Cloudflare
from functools import reduce
from typing import *
from copy import *
import subprocess
import argparse
import json
import sys
import os
import re

###############################################################################

def read(path: AnyStr) -> bytes:
    f = open(path, "rb")
    content = f.read()
    f.close()
    return content

def env(var: str) -> AnyStr:
    try:
        return os.environ[var]
    except KeyError:
        pass

    try:
        x = read(os.environ[f"{var}_FILE"]).decode("utf-8")
        x = x.removesuffix("\r").removesuffix("\n")
        return x
    except KeyError:
        pass

    raise KeyError(f"missing environment variable '{var}'")

T = TypeVar('T')
def parse(typ: T, s: str) -> Callable[[str], T]:
    if s is None:
        return None

    if typ is str:
        return s

    if typ is int:
        return int(s)

    if typ is bool:
        return s.lower() == "true"

    raise NotImplementedError()

###############################################################################

def info(msg):
    print(f"\x1b[30;102m I \x1b[0m {msg}", file=sys.stderr)

def error(msg):
    print(f"\x1b[30;101m E \x1b[0m {msg}", file=sys.stderr)

def fatal(*args, **kwargs):
    error(*args, **kwargs)
    sys.exit(1)

###############################################################################

@dataclass
class MatchBlock:
    id: Optional[str] = None
    name: Optional[str] = None
    type: Optional[str] = None
    content: Optional[str] = None
    proxied: Optional[bool] = None
    ttl: Optional[int] = None
    comment: Optional[str] = None

    @classmethod
    def fromdict(cls, d):
        return cls(
            id=parse(str, d.get("id")),
            name=parse(str, d.get("name")),
            type=parse(str, d.get("type")),
            content=parse(str, d.get("content")),
            proxied=parse(bool, d.get("proxied")),
            ttl=parse(int, d.get("ttl")),
            comment=parse(str, d.get("comment")),
        )

    def matches(self, record: Record) -> bool :
        def matches(x: str) -> bool:
            p1 = getattr(self, x)
            p2 = getattr(record, x)

            if p1 is None:
                return True

            if type(p1) == str:
                return re.search(p1, p2) is not None
            else:
                return p1 == p2

        return reduce(lambda acc, x: acc and matches(x), [
            "id", "name", "type", "content", "proxied", "ttl", "comment"
        ])

@dataclass
class UpdateBlock:
    comment: Optional[str] = None
    proxied: Optional[bool] = None
    ttl: Optional[int] = None
    content: Optional[str] = None 

    @classmethod
    def fromdict(cls, d):
        return cls(
            comment=parse(str, d.get("comment")),
            proxied=parse(bool, d.get("proxied")),
            ttl=parse(int, d.get("ttl")),
            content=parse(str, d.get("content"))
        )

    def update(self, record: Record) -> Record:
        def action(x: str) -> str:
            if x.startswith("$env:"):
                var = x.strip().removeprefix("$env:")
                return env(var)

            if x.startswith("$file:"):
                path = x.strip().removeprefix("$file:")
                return read(path).decode("utf-8").strip()

            if x.startswith("$run:"):
                cmd = x.strip().removeprefix("$run:")
                p = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
                return p.stdout.strip()

            return x

        record = copy(record)

        if self.comment is not None:
            record.comment = action(self.comment)

        if self.proxied is not None:
            record.proxied = self.proxied

        if self.ttl is not None:
            record.ttl = self.ttl

        if self.content is not None:
            record.content = action(self.content)

        return record

@dataclass
class Rule:
    match_block: MatchBlock
    update_block: UpdateBlock

    @classmethod
    def fromdict(cls, d):
        return cls(
            match_block=MatchBlock.fromdict(d["match"]),
            update_block=UpdateBlock.fromdict(d["update"])
        )

    def apply(self, record: Record) -> Optional[Record]:
        if not self.match_block.matches(record):
            return None
        return self.update_block.update(record)

@dataclass
class Config:
    rules: List[Rule]

    @classmethod
    def fromdict(cls, d):
        return cls(
            rules=list(map(Rule.fromdict, d["rules"]))
        )

@dataclass
class Record:
    id: str
    name: str
    type: str
    content: str
    proxied: bool
    ttl: int
    comment: Optional[str] = None

    @classmethod
    def from_cloudflare_record(cls, record):
        return cls(
            id=record.id,
            name=record.name,
            type=record.type,
            content=record.content,
            proxied=record.proxied,
            ttl=record.ttl,
            comment=record.comment,
        )

    def apply(self, rules: Iterable[Rule]) -> Self:
        iter = map(lambda rule: rule.apply(self), rules)
        iter = filter(lambda record: record is not None, iter)

        try:
            return next(iter)
        except StopIteration:
            return self

    @staticmethod
    def fetch(client: Cloudflare, zone_id: str) -> List[Record]:
        r = client.dns.records.list(zone_id=zone_id)
        return list(map(Record.from_cloudflare_record, r.result))

    def update(self, client: Cloudflare, zone_id: str):
        client.dns.records.update(
            zone_id=zone_id,
            dns_record_id=self.id,
            name=self.name,
            type=self.type,
            comment=self.comment,
            content=self.content,
            proxied=self.proxied,
            ttl=self.ttl,
        )

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--zone-id", type=str, required=True)
    parser.add_argument("--config", type=str, required=True)
    args = parser.parse_args()

    with open(args.config, "r") as f:
        config = Config.fromdict(json.load(f))

    client = Cloudflare(api_token=env("CLOUDFLARE_API_TOKEN"))

    original_records = Record.fetch(client, args.zone_id)
    updated_records = [record.apply(config.rules) for record in original_records]

    for original, updated in zip(original_records, updated_records):
        if original == updated:
            continue

        info(f"{asdict(updated)}")
        updated.update(client, args.zone_id)

    return 0

if __name__ == "__main__":
    sys.exit(main())
