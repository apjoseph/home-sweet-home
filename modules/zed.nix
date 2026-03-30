_: {
  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.zed.packages = [ pkgs.nixd ];
    };
}
