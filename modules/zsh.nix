_: {
  flake.modules.homeManager.zsh =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.features.zsh;
    in
    {
      options.features.zsh.enable = lib.mkEnableOption "zsh";

      config = lib.mkIf cfg.enable {
        programs.zsh = {
          enable = true;
          dotDir = "${config.home.homeDirectory}/.config/zsh";
          oh-my-zsh = {
            enable = true;
            theme = "agnoster";
          };
        };
      };
    };
}
