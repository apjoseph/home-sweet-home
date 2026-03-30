_: {

  perSystem =
    { pkgs, ... }:
    {
      pre-commit.settings.hooks.rumdl = {
        enable = true;
      };

      treefmt.settings.formatter.rumdl = {
        command = pkgs.lib.getExe pkgs.rumdl;
        options = [ "fmt" ];
        includes = [ "*.md" ];
      };

    };
}
