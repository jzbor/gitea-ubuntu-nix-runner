FROM catthehacker/ubuntu:act-latest

# Install Nix
RUN mkdir -p /etc/nix
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Install attic for caching
RUN nix profile install "nixpkgs#attic-client"

# Pin nixpkgs version
RUN nix registry add nixpkgs github:NixOS/nixpkgs/nixpkgs-unstable
RUN nix registry pin github:NixOS/nixpkgs/nixpkgs-unstable

# Run GC once to remove installation dependencies
RUN nix store gc

# Download nixpkgs
RUN nix flake archive nixpkgs

# Optimize store
RUN nix store optimise

# Add Nix profile to path
RUN echo '. $HOME/.nix-profile/etc/profile.d/nix.sh' >> ~/.bashrc



ENV PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

SHELL [ "/bin/bash", "--login", "-e", "-o", "pipefail", "-c" ]
WORKDIR /tmp

