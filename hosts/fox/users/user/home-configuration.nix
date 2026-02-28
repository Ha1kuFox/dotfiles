{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.stylix.homeModules.stylix
  ];
  home = {
    #backupFileExtension = "old";
    username = "user";
    stateVersion = "25.05";
  };
}
