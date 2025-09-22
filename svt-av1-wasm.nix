{
  lib,
  stdenvNoCC,
  fetchgit,
  cmake,
  perl,
  wasi-sdk
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aom-wasm";
  version = "unstable";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v3.1.2";
    #hash = "sha256-hGfMPLiEP9X6O5GvlDDY8tALQuG7wuveN1SN5M5IKMs=";
  };

  nativeBuildInputs = [
    wasi-sdk
    cmake
    #perl
  ];

  #patchPhase = ''
  #  substituteInPlace CMakeLists.txt --replace-fail 'include("''${AOM_ROOT}/test/test.cmake")' "#keine_tests";
  #'';
/*
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

  /*cmakeFlags = [
    "-DCMAKE_C_COMPILER=${wasi-sdk}/bin/wasm32-wasip1-threads-clang"
    "-DCMAKE_CXX_COMPILER=${wasi-sdk}/bin/wasm32-wasip1-threads-clang++"
    "-DCMAKE_AR=${wasi-sdk}/bin/ar"
    "-DAOM_TARGET_CPU=generic"
    "-DCONFIG_RUNTIME_CPU_DETECT=0"
    "-DENABLE_DOCS=0"
       "-DENABLE_TESTS=0"
       "-DENABLE_TOOLS=0"
       "-DENABLE_EXAMPLES=0"
       "-DCONFIG_MULTITHREAD=0"
       "-DCONFIG_WEBM_IO=1"
       "-DCONFIG_ANALYZER=0"
       "-DCONFIG_INSPECTION=0"
       "-DAOM_EXTRA_C_FLAGS=-fwasm-exceptions"
       "-DAOM_EXTRA_CXX_FLAGS=-fwasm-exceptions"
       #"-DAOM_EXTRA_C_FLAGS=-wasm-enable-sjlj"
       #"-DAOM_EXTRA_CXX_FLAGS=-wasm-enable-sjlj"
    #"-DAOM_EXTRA_C_FLAGS="
    ];*/

  installPhase = ''

    mkdir -p $out/bin;
    touch $out/bin/test;

    cp -rd ./* $out


  '';


  /*mkdir -p $out/lib
  cp libaom.a $out/lib;
  cp libaom_av1_rc.a $out/lib;
  cp libaom_pc.a $out/lib;
  cp libaom_version.a $out/lib;*/


  meta = {
      description = "aom-wasm";
      homepage = "https://aomedia.googlesource.com/aom";
      license = lib.licenses.bsd2;
      platforms = lib.platforms.all;
      maintainers = [];
    };
})
