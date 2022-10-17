{
  description = "Personal nixpkg repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; }; in
        {
          v2raya-bin = pkgs.callPackage ./pkgs/v2raya-bin { };
          colloid-gtk-theme = pkgs.callPackage ./pkgs/colloid-gtk-theme { };
          system-monitoring-center = pkgs.callPackage ./pkgs/system-monitoring-center { };
        });

      nixosModules = {
        v2raya = import ./modules/services/v2raya.nix self;
      };
    };
}
