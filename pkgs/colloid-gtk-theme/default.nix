{ lib
, stdenv
, fetchFromGitHub
, sassc
, inkscape
, optipng
, gtk-engine-murrine
, tweaks ? [ "nord" "dracula" "black" "rimless" ]
,
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "colloid-gtk-theme";
  version = "2022-07-18";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-gtk-theme";
    rev = "b8f6952ef11c2a8375cb48ec8089462885dbaa6b";
    sha256 = "sha256-qajnICD24NtXZ2GCBI9/Uj0l6X1c8R6GEFhfcYOHT4o=";
  };

  patches = [
    ./circular_radius_quick_settings.diff
  ];

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

    # Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=colloid-gtk-theme-git

    ./install.sh -t all -d $out/share/themes
    ./install.sh -t all -s compact -d $out/share/themes

    ${
      concatStringsSep "\n" (
        map (tweak: ''
          ./install.sh -t all --tweaks ${tweak} -d $out/share/themes
          ./install.sh -t all --tweaks ${tweak} -s compact -d $out/share/themes
        '') tweaks
      )
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Colloid gtk theme for linux";
    homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
  };
}
