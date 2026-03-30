_: {
  flake.modules.homeManager.git =
    { lib, config, ... }:

    let
      cfg = config.features.git;
    in
    {
      options.features.git = {
        enable = lib.mkEnableOption "git";

        userName = lib.mkOption {
          type = lib.types.str;
          description = "Git user name";
        };

        userEmail = lib.mkOption {
          type = lib.types.str;
          description = "Git user email";
        };

        signingKeyPath = lib.mkOption {
          type = lib.types.str;
          description = "Path to the SSH public key to use for signing commits.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.activation.generateAllowedSigners = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          echo "${cfg.userEmail} namespaces=\"git\" $(cat ${cfg.signingKeyPath})" > ~/.ssh/allowed_signers
        '';

        programs.git = {
          enable = true;

          settings = {
            user = {
              name = cfg.userName;
              email = cfg.userEmail;
            };
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };

          signing = {
            format = "ssh";
            key = "${cfg.signingKeyPath}";
            signByDefault = true;
          };
        };
      };
    };
}
