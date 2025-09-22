{
  description = "Flake for ffmpeg-wasm";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.wasi-sdk.url = "github:Frooastside/nix-wasi-sdk";

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        inherit wasi-sdk;
      };
      wasi-sdk = inputs.wasi-sdk.packages.${system}.wasi-sdk;
      x264-wasm = pkgs.callPackage ./x264-wasm.nix { inherit wasi-sdk; };
      #aom-wasm = pkgs.callPackage ./aom-wasm.nix { inherit wasi-sdk; };
      svt-av1-wasm = pkgs.callPackage ./svt-av1-wasm.nix { inherit wasi-sdk; };
      ffmpeg-wasm = pkgs.callPackage ./ffmpeg-wasm.nix { inherit wasi-sdk; inherit x264-wasm; inherit svt-av1-wasm; };
    in
    {
      packages.x86_64-linux.x264-wasm = x264-wasm;
      #packages.x86_64-linux.aom-wasm = aom-wasm;
      packages.x86_64-linux.svt-av1-wasm = svt-av1-wasm;
      packages.x86_64-linux.ffmpeg-wasm = ffmpeg-wasm;
      packages.x86_64-linux.default = ffmpeg-wasm;
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
            wasmtime
            wasi-sdk
            ffmpeg-wasm
            ffmpeg
          ];
      };
    };
}
