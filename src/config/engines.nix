{ pkgs }:
{
  "google".metaData.hidden = true;
  "bing".metaData.hidden = true;
  "ebay".metaData.hidden = true;
  "wikipedia".metaData.alias = "@w";
  "Ecosia".metaData.hidden = true;
  "Wiktionary" = {
    urls = [
      {
        template = "https://en.wiktionary.org/w/index.php";
        params = [
          {
            name = "go";
            value = "Go";
          }
          {
            name = "search";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/a/ab/English_Wiktionary_favicon.png";
      sha256 = "sha256-VB7jk9ZzkGN+PacHaST/ghnKIqrCu4njsPfV2s8Tbbw=";
    }}";
    definedAliases = [ "@wt" ];
  };
  "GitHub" = {
    urls = [
      {
        template = "https://github.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.fetchurl {
      url = "https://github.githubassets.com/favicons/favicon.svg";
      sha256 = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
    }}";
    definedAliases = [ "@gh" ];
  };
  "Nix Packages" = {
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "channel";
            value = "unstable";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@np" ];
  };
  "Noogle" = {
    urls = [
      {
        template = "https://noogle.dev/q";
        params = [
          {
            name = "term";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@no" ];
  };
  "NixOS Wiki" = {
    urls = [
      {
        template = "https://wiki.nixos.org/w/index.php";
        params = [
          {
            name = "search";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nw" ];
  };
  "MyNixOS" = {
    urls = [
      {
        template = "https://mynixos.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@mn" ];
  };
  "Hacker News" = {
    urls = [
      {
        template = "https://hn.algolia.com";
        params = [
          {
            name = "dateRange";
            value = "all";
          }
          {
            name = "page";
            value = "0";
          }
          {
            name = "prefix";
            value = "false";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
          {
            name = "sort";
            value = "byPopularity";
          }
          {
            name = "type";
            value = "story";
          }
        ];
      }
    ];
    icon = "${pkgs.fetchurl {
      url = "https://news.ycombinator.com/y18.svg";
      sha256 = "sha256-4bZiK26hXx9I39pucgJlzUJpgdKnrh+dfd64QJiXxv8=";
    }}";
    definedAliases = [ "@hn" ];
  };
}
