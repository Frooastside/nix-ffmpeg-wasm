{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wasi-sdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x264-wasm";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "FFmpeg-WASI";
    repo = "x264";
    rev = "a8b68eb";
    hash = "sha256-y5+JB1N/nHujimNaiYA7nrMf3guXsUi/Y04j3GwgUNY=";
  };

  nativeBuildInputs = [
    pkg-config
    wasi-sdk
  ];

  patchPhase = ''
    patchShebangs ./configure
  '';

  configurePhase = ''
    CC="${wasi-sdk}/bin/clang" \
        AR="${wasi-sdk}/bin/ar" \
        RANLIB="${wasi-sdk}/bin/ranlib" \
        ./configure \
        --prefix=$out \
        --host=i686-gnu \
        --enable-static \
        --disable-cli \
        --disable-asm \
        --extra-cflags="-pthread -target wasm32-wasi-threads -D_WASI_EMULATED_SIGNAL -msimd128" \
        --extra-ldflags="-lc -lwasi-emulated-signal"

    substituteInPlace config.h --replace "#define HAVE_MALLOC_H 1" "#define HAVE_MALLOC_H 0"
  '';

  makeFlags = [
    "install-lib-static"
  ];

  meta = {
      description = "x264-wasm";
      homepage = "https://code.videolan.org/videolan/x264";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.all;
      maintainers = [];
    };
})
