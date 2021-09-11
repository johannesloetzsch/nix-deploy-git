{
  description = "Nixos module, allowing app deployment via git hooks into pure servers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs }:
  rec {
    nixosModules = {
      nix-deploy-git = import ./module.nix;
      example = import ./example.nix;
    };
    nixosModule = self.nixosModules.nix-deploy-git;
  };
}
