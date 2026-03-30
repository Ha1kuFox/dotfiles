# pawttern

NixOS config that use flakes and [blueprint](https://numtide.github.io/blueprint/main/) with custom lib that make every nix file into option in "mods" category.

## Install

```bash
git clone https://github.com/Ha1kuFox/dotfiles ~/{your_folder}
cd ~/{your_folder}

# look to justfile
just switch
```

## Structure

- **`hosts/`**: Device-specific modules
- **`lib/`**: My lib
- **`modules/`**: All custom mods

- **`devenv.nix`**: Development environment for work in vscode
- **`formatter.nix`**: formatter configuration(usage: `nix fmt`)
- **`flake.nix`**: Main flake. [Blueprint](https://numtide.github.io/blueprint/main/) style.
