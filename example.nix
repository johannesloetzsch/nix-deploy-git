{ pkgs, ... }:

{ services.nix-deploy-git = {
    enable = true;
    keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAXviJLBa52ULRxday1Vy+HREw6S/6YGsXoTYdw8miInopOX1MqUaPH9odUoksJWV7CRMU1HLc0q9Tyv35jwbnuBXBVn5Mvt3Q2g5lJcqcUiLDmwmIcaSGE0jeY8ZggYYgcTxeI8Aq6nq726DQQcyMRFSrwbiLG98zFs9j/8YJZHKTMIxjDJ2oa96F/XGtSnRhHOuM+IS/x8JACw68M1hvPLups++G6KGScBUjxKd6mInfGbLO5+majFZpa8MSAy/5VNdQDA0sRTx6hzCCfDJh77ppyWrgn3OsedfVV1WhQK/kS5Ld/hoe1vmJgIWzXPmx9G46JuRNRCAUOkC9Z7GbHjE3H1S7ltLwBTXmW78aiu+dzUd2pR64Uyx0aSCNtnwcD97WL5dZptMUTVRwWN+fvvDcU5eBGX64cA2Ebj+5HbbNDd9OXm7CDhvZHoihshq1m1HK8tw5eBuCEnYb/Juj1NIuoCYd+QKzK8bKtw3WdNp7E2PQ5QOT1XPXMs8Vn7s= j03@nixos" ];
    repos = [
      { name = "example";
        hooks = (pkgs.writeScriptBin "post-receive" ''
          #!${pkgs.runtimeShell}
          echo 'hello world' > /tmp/test
        '');
      }
    ];
  };
}
