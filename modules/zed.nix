_: {
  flake.modules.homeManager.zed =
    { lib, config, ... }:
    let
      cfg = config.features.zed;
      globalExtensions = [
        "git-firefly"
        "toml"
      ];
      autoUpdateGlobalExtensions = lib.genAttrs globalExtensions (_extension: true);
    in
    {
      options.features.zed.enable = lib.mkEnableOption "Zed";

      config = lib.mkIf cfg.enable {
        programs.zed-editor = {
          enable = true;
          extensions = globalExtensions;
          userSettings = {
            agent_servers = {
              codex-acp.type = "registry";
              github-copilot-cli = {
                type = "registry";
                default_model = "auto";
                favorite_config_option_values = {
                  model = [ "auto" ];
                  effortLevel = [ "high" ];
                };
              };
            };

            project_panel.dock = "left";
            outline_panel.dock = "left";
            collaboration_panel.dock = "left";
            git_panel.dock = "left";
            session.trust_all_worktrees = true;
            base_keymap = "JetBrains";

            edit_predictions.provider = "copilot";

            auto_update_extensions = autoUpdateGlobalExtensions;

            agent = {
              dock = "right";
              expand_edit_card = true;
              expand_terminal_card = true;
            };

            autosave.after_delay.milliseconds = 1000;
            terminal.font_family = "FiraCode Nerd Font";
          };
        };
      };
    };
}
