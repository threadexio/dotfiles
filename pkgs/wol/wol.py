#!/usr/bin/env python3
from socket import *
import argparse
import sys

class MacAddress:
  def __init__(self, s):
    self._bytes = [int(x, 16) for x in s.split(':')]
    if len(self._bytes) != 6:
      raise ValueError("mac addresses must have 6 octects")

  def __str__(self):
    return ':'.join([f"{x:02x}" for x in self._bytes])

  def __repr__(self):
    return self.__str__()

  def octets(self):
    return self._bytes

def make_magic_packet(mac):
  pkt = bytearray()

  pkt.extend(b"\xff\xff\xff\xff\xff\xff")

  for _ in range(16):
    pkt.extend(mac.octets())

  return pkt

def _main(args):
  mac = MacAddress(args.mac)
  addr = args.addr

  pkt = make_magic_packet(mac)

  sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
  sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
  sock.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)

  sock.sendto(pkt, (addr, 7))
  print("ok")

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("mac", help="Target MAC address")
  parser.add_argument("--addr", default="255.255.255.0", help="Broadcast address")
  args = parser.parse_args()
  _main(args)

if __name__ == "__main__":
  main()