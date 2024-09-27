{
  description = "Home Manager configuration of angryluck";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      # nixpkgs-stable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      # stablePkgs = nixpkgs-stable.legacyPackages.${system};
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."angryluck" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # extraSpecialArgs = {
        #   inherit stablePkgs;
        # };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
