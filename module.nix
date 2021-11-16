{ config, pkgs, lib, ... }:

let
  cfg = config.services.nix-deploy-git;
in
with lib; {
  options.services.nix-deploy-git = with types; {
    enable = mkEnableOption ''
      Enable deployment via git hooks.
    '';

    keys = mkOption {
      type = listOf str;
    };

    repos = mkOption {
      type = listOf attrs;
    };

    user = mkOption {
      type = str;
      default = "deploy";
    };
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  
    users.users."${cfg.user}" = {
      group = "${cfg.user}";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/${cfg.user}";
      shell = "${pkgs.git}/bin/git-shell";
      openssh.authorizedKeys.keys = cfg.keys;
    };

    users.groups."${cfg.user}" = {};

    systemd = {
      services."nix-deploy-git-setup" = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          ExecStart = "${(pkgs.writeScriptBin "nix-deploy-git-setup" (''
            #!${pkgs.runtimeShell}
            cd
          '' +
          (concatMapStrings
            (repo: ''
              ${pkgs.git}/bin/git init --bare ${repo.name}.git
              rm -f ${repo.name}.git/hooks/*
              cp ${repo.hooks}/bin/* ${repo.name}.git/hooks/
            '')
            cfg.repos)))}/bin/nix-deploy-git-setup";
        };
      };
    };
  };
}
