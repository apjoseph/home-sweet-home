_: {
  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.all.packages = [ pkgs.statix ];

      treefmt.programs.statix = {
        enable = true;
      };
    };
}
