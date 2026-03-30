_: {
  flake.modules.homeManager.yubi =
    {
      pkgs,
      config,
      lib,
      ...
    }:

    let
      cfg = config.features.yubi;
    in
    {
      options.features.yubi.enable = lib.mkEnableOption "yubi";

      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.yubikey-manager
        ];
      };
    };
}
