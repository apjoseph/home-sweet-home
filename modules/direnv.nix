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
              # nixpkgs currently evaluates direnv on Darwin with CGO_ENABLED=0,
              # while direnv's GNUmakefile forces '-linkmode=external' on Darwin.
              # That combination fails to build; re-check this override on each
              # flake.lock update and remove it once upstream/nixpkgs no longer needs it.
              pkgs.direnv.overrideAttrs (old: {
                env = (old.env or { }) // {
                  CGO_ENABLED = "1";
                };
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
