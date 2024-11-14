{
  description = "Home Manager configuration of angryluck";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    shared.url = "path:/etc/nix-config";
    nixpkgs.follows = "shared/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugin-isabelle-syn.url = "github:Treeniks/isabelle-syn.nvim";
    plugin-isabelle-syn.flake = false;
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stablePkgs = nixpkgs-stable.legacyPackages.${system};
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."angryluck" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # extraSpecialArgs = {
      #   inherit stablePkgs;
      # };

      extraSpecialArgs = {
        inherit inputs;
        inherit stablePkgs;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
