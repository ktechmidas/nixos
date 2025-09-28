{ config, ... }:

{
  home-manager.users.monotoko = { config, ... }: {
    home.stateVersion = "25.05";

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = "${config.home.homeDirectory}/.ssh/github.rsa";
          extraOptions = {
            PreferredAuthentications = "publickey";
          };
        };
      };
    };
  };
}