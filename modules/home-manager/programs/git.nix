{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      gh
    ];

    programs.git = {
      enable = true;
      diff-so-fancy.enable = true;
      userName = "umokee";
      userEmail = "hituaev@gmail.com";

      ignores = [
        ".vscode/"
        ".idea/"
        "__pycache__/"
      ];
    };
  };
}
