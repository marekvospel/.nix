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
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86-linux";
      pkgs = nixpkgs.packages.${system};
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
          rofi-emoji = prev.rofi-emoji.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
        })
      ];

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          ./desktop.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.vospel = import ./users/vospel.nix;
          }
        ];
      };

    };
}
