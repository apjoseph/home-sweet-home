_:
let
  markdownlintConfig = builtins.fromJSON (builtins.readFile ../../.markdownlint.json);
in
{
  perSystem =
    { pkgs, ... }:
    {
      repoDevShells.shells.all.packages = [ pkgs.markdownlint-cli ];

      pre-commit.settings.hooks.markdownlint = {
        enable = true;
        settings.configuration = markdownlintConfig;
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
    };
}
