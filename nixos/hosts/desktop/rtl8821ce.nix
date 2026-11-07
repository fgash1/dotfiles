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
    install -Dm444 8821ce.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
