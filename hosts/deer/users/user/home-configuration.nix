{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.stylix.homeModules.stylix
    inputs.caelestia-shell.homeManagerModules.default
    # inputs.plasma-manager.homeModules.plasma-manager
  ];
  home = {
    username = "user";
    stateVersion = "25.05";
  };
}
