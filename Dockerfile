# FROM catthehacker/ubuntu:act-latest
ARG BASE_IMG=catthehacker/ubuntu:act-latest
FROM ${BASE_IMG}

RUN apt-get update -y
RUN apt-get install -y curl xz-utils

# Install Nix
RUN mkdir -p /etc/nix
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon --yes
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

ENV PATH="/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"


# Pin nixpkgs version
RUN nix registry add nixpkgs github:NixOS/nixpkgs/nixpkgs-unstable
RUN nix registry pin github:NixOS/nixpkgs/nixpkgs-unstable

# Install attic for caching and NodeJS for actions
RUN nix profile install "nixpkgs#attic-client" "nixpkgs#nodejs_20"

# Run GC once to remove installation dependencies
RUN nix store gc

# Download nixpkgs
RUN nix flake archive nixpkgs

# Optimize store
# Add again once issues are fixed
# https://github.com/NixOS/nix/issues/7273
#RUN nix store optimise --option keep-failed false --option keep-going true

# Add Nix profile to path
RUN echo '. $HOME/.nix-profile/etc/profile.d/nix.sh' >> ~/.bashrc



WORKDIR /tmp


# files:
# /nix
# /root/.nix-channels
# /root/.nix-defexpr
# /root/.nix-defexpr
# /root/.nix-profile
