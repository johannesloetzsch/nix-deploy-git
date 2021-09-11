## About

This nixos module allows administrators a pure configuration of a server with a defined set of git repositories.
Less privileged users (like developers or a ci), authorized by ssh keys, can than push to this repos and trigger the git hooks defined in the nixos configuration.

## Install

### configuration.nix

When you are on a legacy nixos without flakes, you can install nix-deploy-git by adding this to your `/etc/nixos/configuration.nix`:

```nix
  imports = [
    "${builtins.fetchGit { url = "https://github.com/johannesloetzsch/nix-deploy-git.git"; }}/module.nix"
  ];
```

### flake.nix

The recommended way of installation is using this repository as input in your `/etc/nixos/flake.nix` and adding `nix-deploy-git.nixosModule` to modules:

```nix
{
  inputs = {
    nix-deploy-git.url = "github:johannesloetzsch/nix-deploy-git/main";
  };

  outputs = { nix-deploy-git }:
  {
    nixosConfigurations."${HOSTNAME}" = nixpkgs.lib.nixosSystem {
      modules = [
        nix-deploy-git.nixosModule
      ];
    };
  };
}
```

## Config

The documentation of available config options can be found in [`module.nix`](./module.nix).
[`example.nix`](./example.nix) shows an minimal config, that could be copied or included in your `configuration.nix`.

```bash
nixos-rebuild switch
```

After rebuilding your system with `services.nix-deploy-git.enable = true`, `nix-deploy-git` should have:
- enabled openssh
- created a new user `${services.nix-deploy-git.user}`
- the ssh-public-keys defined in `${services.nix-deploy-git.keys}` will have permissions limited to login as this user with git-shell 
- the git repositories defined in `${services.nix-deploy-git.repos}` will be initialized as bare repos in $HOME of `${services.nix-deploy-git.user}` (defauts to `/var/lib/deploy/`).
- for each repo, the defined `hooks` will be setup

## Usage

Everyone with one of the `${services.nix-deploy-git.keys}` can now push to every ${REPO} at the ${SERVER}:

```bash
git remote add ${REMOTE} deploy@${SERVER}:/var/lib/deploy/${REPO}.git
git push -u ${REMOTE} ${BRANCH}
```

This will trigger the hooks setup by `nix-deploy-git` to run with the permissions of `${services.nix-deploy-git.user}`.
