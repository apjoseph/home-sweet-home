{ lib, ... }:
let
  markdownlintConfig = builtins.fromJSON (builtins.readFile ../.markdownlint.json);
in
{
  imports = [ ./languages.nix ];

  perSystem =
    { pkgs, ... }:
    {
      repoLanguages.languages.markdown = {
        enable = lib.mkDefault true;

        lsps = [
          pkgs.marksman
          pkgs.typos-lsp
        ];
        tooling = [
          pkgs.markdownlint-cli
          pkgs.typos
        ];

        gitHooks = {
          markdownlint = {
            enable = true;
            settings.configuration = markdownlintConfig;
          };

          typos.enable = true;
        };

        treefmt.settings.formatter.markdownlint = {
          command = pkgs.lib.getExe pkgs.markdownlint-cli;
          options = [
            "--fix"
            "--config"
            ".markdownlint.json"
          ];
          includes = [ "*.md" ];
        };

        zed = {
          extensions = [
            "markdownlint"
            "typos"
          ];
          settings.languages.Markdown = {
            language_servers = [ "markdownlint" ];
            format_on_save = "off";
          };
        };
      };
    };

  flake.flakeModules.markdown = ./markdown.nix;

  flake.modules.homeManager.markdown =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.features.languages.markdown;
      lspPackages = [
        pkgs.marksman
        pkgs.typos-lsp
      ];
      toolingPackages = [
        pkgs.markdownlint-cli
        pkgs.typos
      ];
    in
    {
      options.features.languages.markdown = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Markdown language support.";
        };

        zed.enable = lib.mkOption {
          type = lib.types.bool;
          default = cfg.enable;
          description = "Enable Markdown support in Zed.";
        };

        neovim.enable = lib.mkOption {
          type = lib.types.bool;
          default = cfg.enable;
          description = "Enable Markdown support in Neovim.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.zed-editor = lib.mkIf cfg.zed.enable {
          extensions = [
            "markdownlint"
            "typos"
          ];
          userSettings.auto_update_extensions = {
            markdownlint = true;
            typos = true;
          };
        };

        programs.neovim = lib.mkIf cfg.neovim.enable {
          extraPackages = lspPackages ++ toolingPackages;
        };
      };
    };
}
