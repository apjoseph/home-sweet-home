_: {
  flake.modules.homeManager.ssh =
    {
      pkgs,
      config,
      lib,
      ...
    }:

    let
      cfg = config.features.ssh;
    in
    {
      options.features.ssh.enable = lib.mkEnableOption "ssh";

      config = lib.mkIf cfg.enable {
        programs.ssh = {
          enable = true;
          package = pkgs.openssh;
          enableDefaultConfig = false;

          # Keep an explicit baseline config so we're not relying on
          # Home Manager's soon-to-be-removed implicit defaults.
          matchBlocks."*" = {
            addKeysToAgent = "yes";
            compression = false;
            forwardAgent = false;
            hashKnownHosts = true;
            serverAliveInterval = 30;
            serverAliveCountMax = 3;
            controlMaster = "auto";
            controlPersist = "10m";
          };
        };
      };
    };
}
