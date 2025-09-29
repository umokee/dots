{ config, lib, ... }:

{
  imports = [
    ./gtk.nix
    ./qt.nix
    ./cursor.nix
    ./icons.nix
    ./matugen
  ];
}
