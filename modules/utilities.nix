_: {
  flake.modules.homeManager.utilities =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      cfg = config.features.utilities;
    in
    {
      options.features.utilities.enable = lib.mkEnableOption "utilities";

      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.tree
          pkgs.unzip
          pkgs.zstd
          pkgs.zlib
          pkgs.rclone
        ];
        programs.ripgrep = {
          enable = true;
          package = pkgs.ripgrep;
        };
      };
    };
}
