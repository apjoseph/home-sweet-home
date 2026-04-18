_: {
  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.all.packages = [ pkgs.deadnix ];

      treefmt.programs.deadnix = {
        enable = true;
      };
    };
}
