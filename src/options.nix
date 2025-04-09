{
  config,
  modulePath,
  defaultPackage,
  packageName,
}:

{ lib, pkgs, ... }:

let
  appName = "silentium";

  cfg = lib.getAttrFromPath modulePath config;

  inherit (lib.options)
    mkEnableOption
    mkPackageOption
    mkOption
    literalExpression
    ;
  inherit (lib.types) attrsOf submodule str;
  search = {
    force = true;
    default = "DuckDuckGo";
    order = [ "DuckDuckGo" ];
    engines = import ./config/engines.nix { inherit pkgs; };
  };
  profile = submodule (
    { config, name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = str;
        };
        search = mkOption {
          type = submodule (
            args:
            import ./search.nix {
              inherit (args) config;
              inherit lib pkgs appName;
              package = cfg.finalPackage;
              modulePath = modulePath ++ [
                "profiles"
                name
                "search"
              ];
              profilePath = "firefox";
            }
          );
          default = search;
          description = "Declarative search engine configuration.";
        };
      };
    }
  );
  profiles = lib.mkOption {
    type = attrsOf profile;
    default = {
      "default" = {
        name = "default";
      };
    };
  };
in
{
  imports = [
  ];
  options = lib.setAttrByPath modulePath {
    enable = mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
    inherit profiles;

    finalPackage = mkOption {
      visible = false;
      type = with lib.types; nullOr package;
      readOnly = true;
      description = "Resulting ${appName} package.";
      default = cfg.package;
    };

    package = mkOption {
      visible = false;
      type = with lib.types; nullOr package;
      default = defaultPackage;
    };
  };
}
