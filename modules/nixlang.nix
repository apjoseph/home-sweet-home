{ lib, ... }:
{
  imports = [ ./languages.nix ];

  perSystem =
    { pkgs, ... }:
    {
      repoLanguages.languages.nix = {
        enable = lib.mkDefault true;

        lsps = [ pkgs.nixd ];
        tooling = [
          pkgs.deadnix
          pkgs.nixfmt
          pkgs.statix
        ];

        treefmt.programs = {
          deadnix.enable = true;
          nixfmt.enable = true;
          statix.enable = true;
        };

        zed = {
          extensions = [ "nix" ];
          settings.languages.Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
            format_on_save = "off";
            formatter.external = {
              command = "nix";
              arguments = [
                "fmt"
                "--"
              ];
            };
          };
        };
      };
    };

  flake.flakeModules.nixlang = ./nixlang.nix;

  flake.modules.homeManager.nixlang =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.features.languages.nix;
      lspPackages = [ pkgs.nixd ];
      toolingPackages = [
        pkgs.deadnix
        pkgs.nixfmt
        pkgs.statix
      ];
    in
    {
      options.features.languages.nix = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Nix language support.";
        };

        zed.enable = lib.mkOption {
          type = lib.types.bool;
          default = cfg.enable;
          description = "Enable Nix support in Zed.";
        };

        neovim.enable = lib.mkOption {
          type = lib.types.bool;
          default = cfg.enable;
          description = "Enable Nix support in Neovim.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.zed-editor = lib.mkIf cfg.zed.enable {
          extensions = [ "nix" ];
          userSettings.auto_update_extensions.nix = true;
        };

        programs.neovim = lib.mkIf cfg.neovim.enable {
          extraPackages = lspPackages ++ toolingPackages;
        };
      };
    };
}
