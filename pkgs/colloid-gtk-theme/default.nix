{ lib
, stdenv
, fetchFromGitHub
, sassc
, inkscape
, optipng
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "colloid-gtk-theme";
  version = "2022-07-18";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-gtk-theme";
    rev = "b32696e42a5174c4ab9a1fcd3a6a79be6e844d40";
    sha256 = "sha256-dWYRTwfQRMBdg+htxpWatF325rToaovF/43LxX6I1GI=";
  };

  nativeBuildInputs = [
    sassc
    inkscape
    optipng
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs *.sh
  '';

  installPhase = ''
    runHook preInstall
    export HOME=$(pwd)
    mkdir -p $out/share/themes
    unset name && ./install.sh -t all -s standard compact --tweaks nord black rimless normal -d $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "Colloid gtk theme for linux";
    homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
  };
}
