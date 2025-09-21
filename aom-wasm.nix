{
  lib,
  stdenv,
  fetchgit,
  cmake,
  perl,
  wasi-sdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aom-wasm";
  version = "unstable";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev = "v3.13.1";
    hash = "sha256-C6V2LxJo7VNA9Tb61zJKswnpczpoDj6O3a4J0Z5TZ0A=";
  };

  nativeBuildInputs = [
    cmake
    perl
    wasi-sdk
  ];

  /*patchPhase = ''
    patchShebangs ./configure
  '';

  <

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
        --extra-cflags="-pthread -target wasm32-wasip1-threads -D_WASI_EMULATED_SIGNAL -msimd128" \
        --extra-ldflags="-lc -lwasi-emulated-signal"

    substituteInPlace config.h --replace "#define HAVE_MALLOC_H 1" "#define HAVE_MALLOC_H 0"
  '';

  makeFlags = [
    "install-lib-static"
  ];*/

  cmakeFlags = [
    "-DAOM_TARGET_CPU=generic"
    "-DCONFIG_RUNTIME_CPU_DETECT=0"
    #"-DAOM_EXTRA_C_FLAGS="
  ];

  installPhase = ''
    mkdir -p $out/bin;
    touch $out/bin/test;
  '';

  meta = {
      description = "aom-wasm";
      homepage = "https://aomedia.googlesource.com/aom";
      license = lib.licenses.bsd2;
      platforms = lib.platforms.all;
      maintainers = [];
    };
})
