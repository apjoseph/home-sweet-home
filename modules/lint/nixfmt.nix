_: {
  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.all.packages = [ pkgs.nixfmt ];

      treefmt.programs.nixfmt = {
        enable = true;
      };
    };
}
