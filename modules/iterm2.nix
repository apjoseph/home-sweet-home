_: {
  flake.modules.homeManager.iterm2 =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      cfg = config.features.iterm2;
    in
    {
      options.features.iterm2.enable = lib.mkEnableOption "iterm2";

      config = lib.mkIf cfg.enable {
        home.packages = lib.optionals pkgs.stdenv.isDarwin [
          pkgs.iterm2
        ];
      };
    };
}
