{
  description = "A simple NixOS flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    ... 
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      tvestelind-x280 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [ ./nixos/configuration.nix ];
      };
    };
  };
}
