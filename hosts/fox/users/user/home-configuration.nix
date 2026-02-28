{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];
  home.username = "user";
  home.stateVersion = "25.05";
}
