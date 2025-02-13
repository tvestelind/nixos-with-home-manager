{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    auto-cpufreq,
    stylix,
    ... 
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      tp-x280 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [ 
          ./nixos/configuration.nix
	  auto-cpufreq.nixosModules.default
          stylix.nixosModules.stylix
          {
            nixpkgs.config.allowUnfree = true;
            home-manager = {
	      useGlobalPkgs = true;
              useUserPackages = true;
	      users.tvestelind = import ./home-manager/home.nix;
	    };
          }
        ];
      };
    };
  };
}
