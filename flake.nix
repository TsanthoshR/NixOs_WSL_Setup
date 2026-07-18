{
  description = "My WSL NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Not in nixpkgs; the upstream flake carries its own pinned rust toolchain
    # and vendored libghostty-vt (zig), so build via their package rather
    # than re-deriving it here. Pinned to a release tag, not a branch.
    herdr.url = "github:ogulcancelik/herdr/v0.7.4";
  };

  outputs = { self, nixpkgs, home-manager, herdr, ... }@inputs: {
    nixosConfigurations."wsl" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = {
            user = "nixos";
            herdrPkg = herdr.packages.x86_64-linux.default;
          };
          home-manager.users."nixos" = import ./home.nix;
        }
      ];
    };
  };
}