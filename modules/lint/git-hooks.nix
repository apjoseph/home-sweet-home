{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
    let
      preCommitShellHook =
        if builtins.hasAttr "pre-commit" config && builtins.hasAttr "shellHook" config.pre-commit then
          config.pre-commit.shellHook
        else
          "";
    in
    {
      pre-commit = {
        check.enable = true;
        settings = {
          package = pkgs.prek;
        };
      };

      repoDevShells.shells.all.shellHook = preCommitShellHook;
    };

}
