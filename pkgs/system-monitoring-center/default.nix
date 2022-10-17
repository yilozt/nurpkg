### TASK MANAGER ###
{ config, pkgs, ... }:

# Convert system-monitoring-center python package to a nix package
pkgs.python3Packages.buildPythonApplication rec {
  pname = "system-monitoring-center";
  version = "1.28.0";
  doCheck = false;

  propagatedBuildInputs = with pkgs; [
    python3Packages.pygobject3
    gobject-introspection
    girara
    gnome.adwaita-icon-theme
    wrapGAppsHook
  ];

  src = (pkgs.python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "eLoXmhi39RRsGoS5NdpDZRd1Pk2AUT+nhMJB7VijpgA=";
  });

  meta = with pkgs.lib; {
    homepage = "https://github.com/hakandundar34coding/system-monitoring-center";
    description = "Provides information about CPU/RAM/Disk/Network/GPU performance, sensors, processes, users, services and system.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
