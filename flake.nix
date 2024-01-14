{
  description = "Darwin attempt 1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, ... }: {
    darwinConfigurations = {
      mac = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
        ];
      };
    };
    darwinPackages = self.darwinConfigurations.mac.pkgs;
  };
}
