{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "vm" (vars.services.enable or [ ]);

  default = {
    users = [ vars.username ];
    sharedDirectories = {
      "shared" = "/home/shared";
      "vm-exchange" = "/home/vm-exchange";
    };
  };

  cfg = default // (vars.services.config.vm or { });
in
{
  config = lib.mkIf enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    users.users = lib.genAttrs cfg.users (user: {
      extraGroups = [ "libvirtd" ];
    });

    systemd.tmpfiles.rules =
      lib.mapAttrsToList (
        name: path: "d ${path} 0755 ${builtins.head cfg.users} users -"
      ) cfg.sharedDirectories
      ++ lib.optionals (cfg.users != [ ]) [
        "a+ /home/${builtins.head cfg.users} - - - - group:libvirtd:r-x"
        "a+ /home/${builtins.head cfg.users}/Downloads - - - - group:libvirtd:r-x"
      ];

    environment.sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    environment.systemPackages = with pkgs; [
      libvirt
      qemu
      OVMF
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
    ];
  };
}
