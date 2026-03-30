{
  lib,
  inputs,
  ...

}:
{
  flake.modules.homeManager.codex =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.features.codex;
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      options.features.codex.enable = lib.mkEnableOption "codex";

      config = lib.mkIf cfg.enable {
        home.packages = [ unstablePkgs.codex ];
      };
    };
}
