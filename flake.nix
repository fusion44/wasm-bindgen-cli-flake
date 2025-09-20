{
  description = "A wasm-bindgen CLI flake file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    name = "wasm-bindgen-cli";

    overlays.overlays = {
      default = final: prev: {
        ${name} = self.packages.${prev.stdenv.hostPlatform.system}.${name};
      };
    };

    systems = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      mainPkg = self.packages.${system}.${name};
    in {
      packages = {
        ${name} = pkgs.callPackage ./package/default.nix {};
        default = self.packages.${system}.${name};
      };

      apps = {
        default = self.apps.${system}.${name};
        ${name} = {
          type = "app";
          program = "${mainPkg}/bin/wasm-bindgen";
        };
      };
    });
  in
    overlays // systems;
}
