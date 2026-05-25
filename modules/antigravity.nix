{
  lib,
  inputs,
  ...

}:
{
  flake.modules.homeManager.antigravity =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.features.antigravity;
      inherit (pkgs.stdenv.hostPlatform) system;
      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "antigravity" ];
      };
      agySources = {
        aarch64-darwin = {
          version = "1.0.2";
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/darwin-arm/cli_mac_arm64.tar.gz";
          hash = "sha512-nhd1mSMO0iYFh5uOlvS6m42Lq5hYb+2uFNrkU2v3VSnH4Mem3uQTTJE5J8iwL7shLm/IG8+YLQbWhQZj6z+/4A==";
        };
        x86_64-darwin = {
          version = "1.0.2";
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/darwin-x64/cli_mac_x64.tar.gz";
          hash = "sha512-MMPgdx1bNcDk461ScXJgesTVqPniMstGVkBnBnmGdIem31u+LOxxQBRPasL8WMfUvKjhV0UBTd5NjsmgXNBqgw==";
        };
        aarch64-linux = {
          version = "1.0.2";
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-arm/cli_linux_arm64.tar.gz";
          hash = "sha512-HL0wB5RhfaCR6PELQM1VVyflDcrapg8nWoc7erT/WGi/6xKBLaASvoeP3nlAfImoof8+608cUOJoNNTgG8Bz1w==";
        };
        x86_64-linux = {
          version = "1.0.2";
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.2-6109799369277440/linux-x64/cli_linux_x64.tar.gz";
          hash = "sha512-Ex9fODBAgpNvgeyP2pqjkRIxCQ9ao7J+rVfD3l2VwO+VsoGmwC2By4K+uEmEVQBP27YvDwknPVyEu7XnoPMwhg==";
        };
      };
      antigravityPackage = unstablePkgs.antigravity;
      agySource = agySources.${system} or (throw "Unsupported system for agy: ${system}");
      agyPackage = pkgs.stdenvNoCC.mkDerivation {
        pname = "agy";
        inherit (agySource) version;
        src = pkgs.fetchurl {
          inherit (agySource) url hash;
        };

        dontBuild = true;
        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          install -Dm755 antigravity $out/bin/agy
          runHook postInstall
        '';

        meta = {
          description = "Google Antigravity CLI";
          homepage = "https://antigravity.google/cli/";
          license = lib.licenses.unfree;
          mainProgram = "agy";
        };
      };
    in
    {
      options.features.antigravity.enable = lib.mkEnableOption "antigravity";

      config = lib.mkIf cfg.enable {
        home.packages = [
          antigravityPackage
          agyPackage
        ];
      };
    };
}
