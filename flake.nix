{
  description = "My system configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixpkgs.overlays = [
        (final: prev: {
          rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
          rofi-emoji = prev.rofi-emoji.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
        })
      ];

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./desktop.nix
          inputs.home-manager.nixosModules.default
        ];
      };

    };
}
