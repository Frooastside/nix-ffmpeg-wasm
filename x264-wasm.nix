{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  pkg-config,
  wasi-sdk
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "x264-wasm";
  version = "stable";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "x264";
    rev = "b35605ace3ddf7c1a5d67a2eb553f034aef41d55";
    hash = "sha256-hGfMPLiEP9X6O5GvlDDY8tALQuG7wuveN1SN5M5IKMs=";
  };

  nativeBuildInputs = [
    pkg-config
    wasi-sdk
  ];

  patchPhase = ''
    patchShebangs ./configure
  '';

  configurePhase = ''
    CC="${wasi-sdk}/bin/wasm32-wasip1-threads-clang" \
        AR="${wasi-sdk}/bin/ar" \
        RANLIB="${wasi-sdk}/bin/ranlib" \
        ./configure \
        --prefix=$out \
        --host=i686-gnu \
        --enable-static \
        --disable-cli \
        --disable-asm \
        --extra-cflags="-pthread -target wasm32-wasip1-threads -D_WASI_EMULATED_SIGNAL -msimd128" \
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
