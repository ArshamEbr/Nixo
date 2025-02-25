{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "vosk";
  version = "0.3.50"; # Replace with the latest version

  src = pkgs.fetchFromGitHub {
    owner = "alphacep";
    repo = "vosk-api";
    rev = "cf67ed6cd9c022a5550670c16ff8a0e345cf77db"; # Use the latest release tag
    sha256 = "sha256-PTS5ohvDb/l5PBIa7XtYpaRLQ4Ik6wc2WY8EGdTZkIw="; # Replace with actual hash
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    cffi
    numpy
    pyaudio
  ];

  doCheck = false; # Disable tests for simplicity

  meta = with pkgs.lib; {
    description = "Offline speech recognition API";
    homepage = "https://alphacephei.com/vosk/";
    license = licenses.asl20;
  };
}