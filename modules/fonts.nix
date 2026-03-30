_: {
  flake.modules.homeManager.fonts =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      cfg = config.features.fonts;
    in
    {
      options.features.fonts.enable = lib.mkEnableOption "fonts";

      config = lib.mkIf cfg.enable {
        fonts = {
          fontconfig = {
            enable = true;
          };
        };

        home.packages = [
          pkgs.font-awesome
          pkgs.powerline
          pkgs.powerline-fonts
          pkgs.powerline-symbols
          pkgs.nerd-fonts.fira-code
        ];
      };
    };
}
