flake_path := "."
host := "fox"

default:
    @just --list

switch:
    nix fmt
    nh os switch {{ flake_path }} --diff always --hostname {{ host }}

check:
    nix flake check {{ flake_path }}

clean:
    nh clean all --keep 3
