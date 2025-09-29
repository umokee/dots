{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    #bashrcExtra = ''
    #  if [[ -z "$TMUX" ]] && [[ "$TERM" != "screen"* ]]; then
    #      exec tmux attach -t default || tmux new -s default
    #  fi
    #'';
    shellAliases = {
      list-nixos-generations = "nixos-rebuild list-generations";
      ns-desktop = "sudo nixos-rebuild switch --flake ~/nixos#desktop";
      ns-laptop = "sudo nixos-rebuild switch --flake ~/nixos#laptop";
      hs-desktop = "home-manager switch --flake ~/nixos#desktop -b backup";
      hs-laptop = "home-manager switch --flake ~/nixos#laptop -b backup";
    };
  };
}
