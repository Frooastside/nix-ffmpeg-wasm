{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  cmake,
  perl,
  wasi-sdk
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aom-wasm";
  version = "3.1.2";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/CpcxdyC4qf9wdzzySMYw17FbjYpasT+QVykXSlx28U=";
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

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=${wasi-sdk}/bin/wasm32-wasip2-clang"
    "-DCMAKE_CXX_COMPILER=${wasi-sdk}/bin/wasm32-wasip2-clang++"
    "-DCMAKE_AR=${wasi-sdk}/bin/ar"
    #"-DAOM_EXTRA_C_FLAGS=-pthreads"
    #"-DAOM_EXTRA_CXX_FLAGS=-pthreads"
    /*"-DAOM_TARGET_CPU=generic"
    "-DCONFIG_RUNTIME_CPU_DETECT=0"
    "-DENABLE_DOCS=0"
       "-DENABLE_TESTS=0"
       "-DENABLE_TOOLS=0"
       "-DENABLE_EXAMPLES=0"
       "-DCONFIG_MULTITHREAD=0"
       "-DCONFIG_WEBM_IO=1"
       "-DCONFIG_ANALYZER=0"
       "-DCONFIG_INSPECTION=0"
       #"-DAOM_EXTRA_C_FLAGS=-wasm-enable-sjlj"
       #"-DAOM_EXTRA_CXX_FLAGS=-wasm-enable-sjlj"
    #"-DAOM_EXTRA_C_FLAGS="*/
    # pthread_setschedparam
    # pthread_setschedparam
    ];

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
