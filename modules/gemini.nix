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
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      options.features.gemini.enable = lib.mkEnableOption "gemini";

      config = lib.mkIf cfg.enable {
        home.packages = [ unstablePkgs.gemini-cli ];
      };
    };
}
