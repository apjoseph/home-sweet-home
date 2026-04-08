_: {
  flake.modules.homeManager.direnv =
    {
      lib,
      config,
      pkgs,
      ...
    }:

    let
      cfg = config.features.direnv;
    in
    {
      options.features.direnv.enable = lib.mkEnableOption "direnv";

      config = lib.mkIf cfg.enable {
        programs.direnv = {
          enable = true;
          package =
            if pkgs.stdenv.isDarwin then
              pkgs.direnv.overrideAttrs (old: {
                # nixpkgs' Darwin build currently reaches a broken Fish integration
                # test for direnv and gets SIGKILLed during `make test`.
                checkPhase = lib.replaceStrings [ " test-fish" ] [ "" ] old.checkPhase;
              })
            else
              pkgs.direnv;
          nix-direnv.enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          silent = true;
        };
      };
    };
}
