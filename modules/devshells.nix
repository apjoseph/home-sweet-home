_:
let
  repoDevShellsModule = {
    perSystem =
      { pkgs, config, ... }:
      {
        devShells.default = pkgs.mkShell {
          inherit (config.repoLanguages) packages;
        };
      };
  };
in
{
  imports = [ repoDevShellsModule ];

  flake.flakeModules.repoDevShells = repoDevShellsModule;
}
