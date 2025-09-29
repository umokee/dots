{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    package = pkgs.starship;

    settings = {
      add_newline = false;
      command_timeout = 1000;
      scan_timeout = 50;

      format = "$directory$git_branch$git_status$character";

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)"; # λ
      };

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        deleted = "x";
      };
    };
  };
}
