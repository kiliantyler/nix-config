{
  description = "kiliantyler's nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixoos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-utils";
    };

  };

  outputs = { self, nix-darwin, nixpkgs, ... }: {
    darwinConfigurations = {
      "Kilians-Virtual-Machine" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
        ];
      };
    };
    darwinPackages = self.darwinConfigurations.mac.pkgs;
  };
}
