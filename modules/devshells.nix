{ lib, ... }:
let
  repoDevShellsModule = {
    perSystem =
      { pkgs, config, ... }:
      let
        cfg = config.repoDevShells;

        shellType = lib.types.submodule (_: {
          options = {
            packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Packages added to this shell.";
            };

            env = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              description = "Environment variables added to this shell.";
            };

            shellHook = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Shell hook content added to this shell.";
            };
          };
        });

        allShell =
          cfg.shells.all or {
            packages = [ ];
            env = { };
            shellHook = "";
          };

        namedShellsRaw = builtins.removeAttrs cfg.shells [ "all" ];
        namedShells = namedShellsRaw // {
          default = namedShellsRaw.default or { };
        };

        mkRepoShell =
          shellCfg:
          let
            shellPackages = shellCfg.packages or [ ];
            shellEnv = shellCfg.env or { };
            shellHook = shellCfg.shellHook or "";
          in
          pkgs.mkShell {
            packages = allShell.packages ++ shellPackages;
            env = allShell.env // shellEnv;
            shellHook = lib.concatStringsSep "\n" (
              lib.filter (hook: hook != "") [
                allShell.shellHook
                shellHook
              ]
            );
          };
      in
      {
        options.repoDevShells = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable dev shell generation.";
          };

          shells = lib.mkOption {
            type = lib.types.attrsOf shellType;
            default = {
              default = { };
            };
            description = ''
              Dev shell definitions keyed by shell name.
              Use `all` to contribute settings to every shell.
            '';
          };
        };

        config = lib.mkIf cfg.enable {
          devShells = lib.mapAttrs (_name: mkRepoShell) namedShells;
        };
      };
  };
in
{
  imports = [ repoDevShellsModule ];

  flake.flakeModules.repoDevShells = repoDevShellsModule;
}
