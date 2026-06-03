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

          settings."*" = {
            AddKeysToAgent = "yes";
            Compression = false;
            ForwardAgent = false;
            HashKnownHosts = true;
            ServerAliveInterval = 30;
            ServerAliveCountMax = 3;
            ControlMaster = "auto";
            ControlPersist = "10m";
          };
        };
      };
    };
}
