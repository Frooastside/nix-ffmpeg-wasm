{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wasi-sdk,
  binaryen,
  x264-wasm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ffmpeg-wasm";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "FFmpeg";
    repo = "FFmpeg";
    rev = "n${finalAttrs.version}";
    hash = "sha256-UlUzqYfJU8Xep+/r29zU+29AjJDbzTKxWWeQKJu/bIQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wasi-sdk
    binaryen
  ];

  buildInputs = [
    x264-wasm
  ];

  patchPhase = ''
      substituteInPlace ./libavutil/file_open.c --replace-fail "tempnam" "NULL; //tempnam";
  '';


  configurePhase = ''
      ./configure \
          --target-os=none \
          --arch=x86_32 \
          --enable-cross-compile \
          --disable-x86asm \
          --disable-inline-asm \
          --disable-stripping \
          --disable-doc \
          --disable-debug \
          --disable-runtime-cpudetect \
          --disable-autodetect \
          --disable-network \
          --enable-pthreads \
          --disable-w32threads \
          --disable-os2threads \
          --pkg-config-flags="--static" \
          --enable-lto \
          --nm=${wasi-sdk}/bin/nm \
          --ar=${wasi-sdk}/bin/ar \
          --ranlib=${wasi-sdk}/bin/ranlib \
          --cc=${wasi-sdk}/bin/clang \
          --cxx=${wasi-sdk}/bin/clang++ \
          --objcc=${wasi-sdk}/bin/clang \
          --dep-cc=${wasi-sdk}/bin/clang \
          --disable-protocol="pipe" \
          --disable-protocol="fd" \
          --enable-gpl \
          --enable-libx264 \
          --extra-cflags="-pthread -target wasm32-wasi-threads -ftls-model=local-exec -D_WASI_EMULATED_PROCESS_CLOCKS -D_WASI_EMULATED_SIGNAL -msimd128" \
          --extra-ldflags="-pthread -target wasm32-wasi-threads -Wl,--max-memory=131072000 -Wl,--import-memory -Wl,--export-memory -lwasi-emulated-process-clocks -lwasi-emulated-signal -msimd128" # \
          #--enable-zlib \
 '';

  installPhase = ''
    mkdir -p $out/bin
    cp ffmpeg $out/bin/ffmpeg-unoptimized.wasm
    cp ffprobe $out/bin/ffprobe-unoptimized.wasm
  '';

  fixupPhase = ''
    ${binaryen}/bin/wasm-opt -O3 -o $out/bin/ffmpeg.wasm $out/bin/ffmpeg-unoptimized.wasm
    ${binaryen}/bin/wasm-opt -O3 -o $out/bin/ffprobe.wasm $out/bin/ffprobe-unoptimized.wasm
  '';

  meta = {
      description = "ffmpeg-wasm";
      homepage = "https://ffmpeg.org/";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.all;
      maintainers = [];
    };
})
