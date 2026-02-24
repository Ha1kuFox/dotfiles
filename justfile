flake_path := "."
host := "fox"

default:
    @just --list

switch:
    nh os switch {{ flake_path }} --hostname {{ host }}

vm:
    rm -f nixos.qcow2
    nixos-rebuild build-vm --flake {{ flake_path }}#{{ host }}
    ./result/bin/run-{{ host }}-vm

check:
    nix flake check {{ flake_path }}

update:
    nix flake update --flake {{ flake_path }}

clean:
    nh clean all --keep 3

fmt:
    nix fmt

push:
    git add .
    git commit -m "update: configuration sync"
    git push origin main
