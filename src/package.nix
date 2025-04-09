{
  pkgs,
  lib,
  nixpak,
}:
let
  mkNixpakPackage =
    args:
    let
      mkNixPak = nixpak.lib.nixpak {
        inherit (pkgs) lib;
        inherit pkgs;
      };
      pkg = mkNixPak args;
    in
    pkg.config.env;
in
mkNixpakPackage {
  config =
    { sloth, ... }:
    let
      pkg = pkgs.firefox-bin;
      appId = "org.mozilla.Firefox";
    in
    {
      flatpak = {
        inherit appId;
      };
      app.package = pkg;
      app.binPath = "bin/firefox";

      dbus.policies = {
        "${appId}" = "own";
        "${appId}.*" = "own";
        "org.a11y.Bus" = "talk";
        "org.gnome.SessionManager" = "talk";
        "org.freedesktop.ScreenSaver" = "talk";
        "org.gtk.vfs.*" = "talk";
        "org.gtk.vfs" = "talk";
        "org.freedesktop.Notifications" = "talk";

        "org.freedesktop.portal.FileChooser" = "talk";
        "org.freedesktop.portal.Settings" = "talk";

        "org.mpris.MediaPlayer2.firefox.*" = "own";
        "org.mozilla.firefox.*" = "own";
        "org.mozilla.firefox_beta.*" = "own";

        "org.freedesktop.DBus" = "talk";
        "org.freedesktop.DBus.*" = "talk";
        "ca.desrt.dconf" = "talk";

        "org.freedesktop.portal.*" = "talk";

        "org.freedesktop.NetworkManager" = "talk";

        "org.freedesktop.FileManager1" = "talk";
      };

      gpu.enable = true;
      gpu.provider = "bundle";
      fonts.enable = true;
      locale.enable = true;

      etc.sslCertificates.enable = true;

      bubblewrap =
        let
          envSuffix = envKey: sloth.concat' (sloth.env envKey);
        in
        {
          network = true;

          bind.rw = [
            (sloth.concat' sloth.xdgCacheHome "/fontconfig")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
            (sloth.concat [
              (sloth.env "XDG_RUNTIME_DIR")
              "/"
              (sloth.envOr "WAYLAND_DISPLAY" "silentium-no-wayland-display")
            ])
            "/tmp/.X11-unix"
            (sloth.envOr "XAUTHORITY" "/no-xauth")

            (envSuffix "XDG_RUNTIME_DIR" "/at-spi/bus")
            (envSuffix "XDG_RUNTIME_DIR" "/gvfsd")
            (envSuffix "XDG_RUNTIME_DIR" "/pulse")
            (envSuffix "XDG_RUNTIME_DIR" "/doc")
            (envSuffix "XDG_RUNTIME_DIR" "/dconf")

            [
              (sloth.concat' sloth.xdgDataHome "/silentium")
              (sloth.concat' sloth.homeDir "/.mozilla/firefox")
            ]
            [
              (sloth.concat' sloth.xdgConfigHome "/silentium/extensions")
              (sloth.concat' sloth.homeDir "/.mozilla/extensions")
            ]
            [
              (sloth.concat' sloth.xdgConfigHome "/silentium/native-messaging-hosts")
              (sloth.concat' sloth.homeDir "/.mozilla/native-messaging-hosts")
            ]
          ];

          bind.ro = builtins.concatLists [
            [
              "/etc/resolv.conf"

              (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
              (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
              (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
              (sloth.concat' sloth.xdgConfigHome "/dconf")
              "/etc/localtime"

              "/sys/bus/pci"

              [
                "${pkg}/lib/firefox"
                "/app/etc/firefox"
              ]
            ]
          ];

          env = {
            XDG_DATA_DIRS = lib.makeSearchPath "share" [
              pkgs.shared-mime-info
            ];
          };
        };
    };
}
