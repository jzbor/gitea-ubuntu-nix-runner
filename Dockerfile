FROM catthehacker/ubuntu:act-latest

RUN mkdir -p /etc/nix
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

RUN nix registry add nixpkgs github:NixOS/nixpkgs/nixpkgs-unstable
RUN nix registry pin github:NixOS/nixpkgs/nixpkgs-unstable
RUN nix flake archive nixpkgs

RUN echo $SHELL
