{
  description = "kiliantyler's nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nas.paulg.fr:QwhwNrClkzxCvdA0z3idUyl76Lmho6JTJLWplKtC2ig="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  inputs = {

    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nixpkgs = {
      type = "indirect"; # take it from the registry
      id = "nixpkgs";
    };

    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-stable-lib.url = "github:NixOS/nixpkgs/nixos-23.11?dir=lib"; # "github:nix-community/nixpkgs.lib" doesn't work
    nixos-stable-small.url = "github:NixOS/nixpkgs/nixos-23.11-small";
    darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    darwin-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # darwin-unstable for now (https://github.com/NixOS/nixpkgs/issues/107466)
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixos-stable-lib"; # not needed by NixOS' module thanks to `home-manager.useGlobalPkgs = true` but needed by the unpriviledged module
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-stable-lib"; # not needed by NixOS' module thanks to `home-manager.useGlobalPkgs = true` but needed by the unpriviledged module
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

  };

  outputs = inputs: {
    inherit inputs;

    # darwinConfigurations = import ./darwin-configuration.nix inputs;
  };
}
