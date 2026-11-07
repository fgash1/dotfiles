{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
}:
let
  modDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
in
stdenv.mkDerivation {
  pname = "rtl8821ce";
  version = "0-unstable-2025-10-13-${kernel.version}";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "4e6b887f0d8c4091a4df9da9fcead9a8294b41ad";
    hash = "sha256-fY0j6VzwAIsD62+snAWfIgGXcwne0mOwIE/Yh25lwTY=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${modDir}/build"
  ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    make $makeFlags -C ${modDir}/build M=$PWD \
      INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=kernel/drivers/net/wireless \
      INSTALL_MOD_STRIP=1 DEPMOD=true modules_install
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
