{
  config,
  pkgs,
  vars,
  ...
}:
{
  home = {
    username = vars.username;
    homeDirectory = vars.dirs.home;
    stateVersion = "25.05";
  };

  home.sessionVariables = {
    TERMINAL = vars.default.terminal;
    EDITOR = vars.default.editor;
    VISUAL = vars.default.visual;
    BROWSER = vars.default.browser;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
