{ inputs, ... }:
{

  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = _: {

    pre-commit.settings.hooks.treefmt = {
      enable = true;
    };

    repoDevShells.shells.all.env.TREEFMT_CLEAR_CACHE = "1";

    treefmt = {
      projectRootFile = "flake.nix";
    };
  };
}
