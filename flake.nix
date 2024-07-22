{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:rochecompaan/nixvim?rev=b16f03513e9a2ab1688819e96ff22e1eec021c18";
  };

  outputs = { self, hyprland, nixpkgs, nixos-hardware, home-manager, nixvim, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
    nixosConfigurations.djangf8sum = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.asus-zephyrus-ga402x.nvidia
        home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.roche = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
        hyprland.nixosModules.default
        {
          programs.hyprland.enable = true;
          programs.waybar.package = inputs.hyprland.packages.${nixpkgs.system}.waybar-hyprland;
          nixpkgs.config.permittedInsecurePackages = [
            "python-2.7.18.8"
          ];
        }
      ];
    };
  };
}
