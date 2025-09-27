# default.nix
{pkgs ? import <nixpkgs> {}}: let
  version = "0.2.104";
  # This hash verifies the source code from GitHub
  srcSha256 = "sha256-FpUqvucsHbWoG6FKsNg708SvauKKoodumFoxLxLSGhE=";
  src = pkgs.fetchFromGitHub {
    owner = "wasm-bindgen";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = srcSha256;
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "raytracer-0.1.0" = "sha256-k6emdBDunYK4pUxrwJCbm57LzICj+q4bRAJ/XJ0zsg0=";
      "weedle-0.13.0" = "sha256-VxSva974ViTR2wJvL2Mf4/DTDc3kmEHqI5M0HpjyIz4=";
    };
  };
in
  pkgs.rustPlatform.buildRustPackage {
    pname = "wasm-bindgen";
    inherit version src cargoLock;

    postPatch = ''
      cp ${cargoLock.lockFile} Cargo.lock
    '';

    buildPhase = ''
      runHook preBuild
      cargo build --release -p wasm-bindgen-cli
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 target/release/wasm-bindgen $out/bin/wasm-bindgen
      runHook postInstall
    '';

    meta = {
      description = "Facilitating high-level interactions between Wasm modules and JavaScript";
      homepage = "https://github.com/wasm-bindgen/wasm-bindgen";
      license = with pkgs.lib.licenses; [mit asl20];
      mainProgram = "wasm-bindgen";
    };
  }
