{ nixpak, firefox-gnome-theme, ... }:
{
  config,
  lib,
  pkgs,
  ...
}@args:

let
  inherit (lib) mkIf;
  cfg = lib.getAttrFromPath modulePath config;

  modulePath = [
    "programs"
    "silentium"
  ];
  profilesPath = "${config.xdg.dataHome}/silentium";
  configPath = "${config.xdg.configHome}/silentium";
  # Firefox will try to communicate with itself when launching an instance with the same directory name as an open profile, and will block launch.
  profilePath = profile: "${profilesPath}/silentium-${profile}";
  packageName = "silentium";
  defaultPackage = pkgs.callPackage ../package.nix { inherit pkgs lib nixpak; };
  defaultProfile = {
    search = { };
  };
  profiles = cfg.profiles;
  generators = import ../generators.nix { inherit lib; };
  userJs = generators.mkUserJs (import ../config/preferences.nix { inherit lib; });
  profilesIni = generators.mkProfilesIni (lib.attrNames profiles);
  searchJsonMozlz4 = cfg.search.file;
in

{
  imports = [
    (import ../options.nix {
      inherit
        config
        modulePath
        defaultPackage
        packageName
        ;
    })
  ];
  config = mkIf cfg.enable (
    lib.attrsets.recursiveUpdate
      {
        home.file."${profilesPath}/.keep".text = "";
        home.file."${configPath}/native-messaging-hosts/.keep".text = "";
        home.file."${profilesPath}/profiles.ini".text = profilesIni;
        home.packages = [
          cfg.finalPackage
        ];
      }
      {
        home.file = (
          profiles
          |> lib.mapAttrsToList (
            name: value: {
              "${profilePath name}/.keep".text = "";
              "${profilePath name}/user.js".text = userJs;
              "${profilePath name}/search.json.mozlz4" = {
                source = profiles.${name}.search.file;
                force = true;
              };
              "${profilePath name}/chrome/firefox-gnome-theme".source = firefox-gnome-theme;
              "${profilePath name}/chrome/userChrome.css".source = ../assets/userChrome.css;
              "${profilePath name}/chrome/userContent.css".source = ../assets/userContent.css;
            }
          )
          |> lib.mergeAttrsList
        );
      }
  );
}
