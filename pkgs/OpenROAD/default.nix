{lib
, stdenv
, fetchFromGitHub
# Native
, bison
, cmake
, tcl
# Runtime
, boost168
, eigen
, flex
, LEMON
, python38
, python38Packages
, spdlog
, swig3
, zlib
}:
stdenv.mkDerivation rec {
  name = "OpenROAD";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "1p677xh16wskfj06jnplhpc3glibhdaqxmk0j09832chqlryzwyx";
  };

  prePatch = ''
    for file in etc/*.{sh,py}; do
      patchShebangs $file
    done
  '';

  nativeBuildInputs = [
    cmake
    bison
    tcl
  ];

  buildInputs = [
    swig3
    boost168
    spdlog
    flex
    eigen
    LEMON
    zlib
    (python38.withPackages (pkgs: with pkgs; [pandas pyyaml]))
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=11"
  ];

  meta = with lib; {
    description = "OpenROAD's unified application implementing an RTL-to-GDS Flow";
    homepage = "https://github.com/The-OpenROAD-Project";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zeri42 ];
  };
}
