{ config, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/monotoko/.config/sops/age/keys.txt";

    secrets = {
      github_ssh_key = {
        owner = "monotoko";
        mode = "0600";
        path = "/home/monotoko/.ssh/github.rsa";
      };
    };
  };
}