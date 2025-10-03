{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "kanata" (vars.services.enable or [ ]);
in
{
  config = lib.mkIf enable {
    services.kanata = {
      enable = true;
      package = pkgs.kanata;

      keyboards = {
        default = {
          extraDefCfg = ''
            concurrent-tap-hold yes
            sequence-timeout 200
          '';

          config = ''
            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet menu rctl
            )

            (deflayermap (default)
              caps (tap-hold 100 200 esc lctl)
              spc (tap-hold-release 0 200 spc (layer-while-held num_row))
            )

            (deflayermap (num_row)
              a 1
              s 2
              d 3
              f 4
              g 5
              h 6
              j 7
              k 8
              l 9
              ; 0
              alt alt
            )

            (deflayer symbols
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  
              grv  -    -    -    -    -    -    -    -    -    -    -    =    bspc
              tab  {    }    e    r    t    7    8    9    o    p    [    ]    \
              caps a    a    d    f    g    4    5    6    l    ;    '    ret
              lsft [    ]    c    v    b    1    2    3    0    /    rsft
              lctl lmet lalt           spc            ralt rmet menu rctl
            )

            (deflayer colemak-dh
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    f    p    b    j    l    u    y    ;    [    ]    \
              caps a    r    s    t    g    m    k    k    i    o    '    ret
              lsft x    c    d    v    z    k    h    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet menu rctl
            )
          '';
        };
      };
    };
  };
}
