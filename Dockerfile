FROM catthehacker/ubuntu:act-latest

RUN sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
