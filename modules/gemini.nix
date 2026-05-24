{
  lib,
  inputs,
  ...

}:
{
  flake.modules.homeManager.gemini =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.features.gemini;
      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "antigravity" ];
      };
    in
    {
      options.features.gemini.enable = lib.mkEnableOption "gemini";

      config = lib.mkIf cfg.enable {
        home.packages = [ unstablePkgs.antigravity ];
      };
    };
}
