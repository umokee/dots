{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    package = pkgs.mako;

    settings = {
      anchor = "bottom-center";
      margin = "0,0,20,0";
      
      width = 400;
      height = 100;
      padding = "15,20";
      
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #89b4fa";
      
      border-radius = 8;
      border-size = 2;
      
      default-timeout = 5000;
      max-visible = 3;
      sort = "-time";
      
      layer = "overlay";
      font = "Inter 12";
      markup = 1;
      actions = 1;
    };
  };
}
