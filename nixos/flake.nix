{
description = "NixOS flake";

inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

	# howdy
	nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";

	# home-manager
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
};

outputs = { self, nixpkgs, home-manager, ... }@inputs: {
	nixosConfigurations = {
		"nixos" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
				}
			];
		};
	};
};
}
