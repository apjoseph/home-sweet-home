_: {

  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.all.packages = [ pkgs.typos ];

      pre-commit.settings.hooks.typos = {
        enable = true;
      };
    };
}
