FROM docker.io/kalilinux/kali-rolling:latest

ENV DOCKER_HOST unix:///run/hackvm/oci.sock

RUN apt-get update -y
RUN apt-get install -y \
      bash-completion docker.io curl wget \
      tmux vim nano file sudo htop less moreutils ripgrep \
      hexedit git binwalk \
      iputils-ping nmap ncat \
      gcc gcc-multilib clang make cmake build-essential \
      nasm \
      python3 python3-pip python3-pwntools python3-virtualenv \
      strace ltrace gdb lldb

# GEF
RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

RUN touch ~/.hushlogin

RUN mkdir -p /shared
WORKDIR /shared
ENTRYPOINT ["/usr/bin/tmux"]
