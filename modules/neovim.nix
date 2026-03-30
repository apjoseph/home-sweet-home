_: {
  flake.modules.homeManager.neovim =
    { lib, config, ... }:

    let
      cfg = config.features.neovim;
    in
    {
      options.features.neovim.enable = lib.mkEnableOption "neovim";

      config = lib.mkIf cfg.enable {
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          extraLuaConfig = ''
            vim.opt.clipboard = "unnamedplus"
          '';
        };
      };
    };
}
