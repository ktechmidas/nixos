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
      evo-app-deploy = {
        owner = "monotoko";
        mode = "0600";
        path = "/home/monotoko/.ssh/evo-app-deploy.rsa";
      };
      dash-rsa = {
        owner = "monotoko";
        mode = "0600";
        path = "/home/monotoko/.ssh/dash.rsa";
      };
      dashdev = {
        owner = "monotoko";
        mode = "0600";
        path = "/home/monotoko/.ssh/dashdev.rsa";
      };
      dashevo = {
        owner = "monotoko";
        mode = "0600";
        path = "/home/monotoko/.ssh/dashevo.rsa";
      };
    };
  };
}