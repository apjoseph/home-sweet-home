{
  inputs,
  ...
}:
{
  flake.modules.homeManager.github =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.features.github;
      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
      options.features.github.enable = lib.mkEnableOption "git";

      config = lib.mkIf cfg.enable {
        programs.gh = {
          enable = true;
          package = unstablePkgs.gh;
        };

        home.packages = [
          unstablePkgs.github-copilot-cli
        ];
      };
    };
}
