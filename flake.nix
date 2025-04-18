{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme/beta";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      nixpak,
      firefox-gnome-theme,
    }:
    let
      pkgsFor = system: nixpkgs.legacyPackages.${system};
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems =
        let
          lib = nixpkgs.lib;
        in
        f:
        systems
        |> lib.map (system: f system (pkgsFor system))
        |> lib.foldl (a: b: lib.recursiveUpdate a b) { };
      forAllSystemAttrs = f: forAllSystems (system: pkgs: { ${system} = f system pkgs; });
      treefmtEval = forAllSystemAttrs (system: pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    forAllSystems (
      system: pkgs: {
        formatter = forAllSystemAttrs (system: pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
        checks = forAllSystemAttrs (
          system: pkgs: {
            formatting = treefmtEval.${pkgs.system}.config.build.check self;
          }
        );
        homeManagerModules.default = import ./src/modules/home-manager.nix {
          inherit nixpak firefox-gnome-theme;
        };
        packages.${system}.default = self.lib.mkPackage { };
        devShells.${system}.default = pkgs.mkShell {
        };
      }
    );
}
