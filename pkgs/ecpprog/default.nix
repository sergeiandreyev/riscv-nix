{lib
, stdenv
, fetchFromGitHub
, pkgconfig
, libftdi
}:
stdenv.mkDerivation rec {
  name = "eccprog";
  version = "unstable-2022-01-13";

  src = fetchFromGitHub {
    owner = "gregdavill";
    repo = "ecpprog";
    rev = "7212b56a9d2fc6de534e06636a1c6d8b0c6f80ab";
    sha256 = "0a0wj9ng3x53w731a0nbq0339gdn3kig5xxbad52f6bn1jp7pn3x";
  };
  
  preBuild = "cd ecpprog";

  nativeBuildInputs = [
    pkgconfig
  ];
  
  buildInputs = [
    libftdi
  ];
  
  NIX_CFLAGS_COMPILE = [
    "-std=gnu99"
  ];
  
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
  
  meta = with lib; {
    description = "Programmer for the Lattice ECP5 series, making use of FTDI based adaptors";
    homepage = "https://github.com/gregdavill/ecpprog";
    license = licenses.isc;
    maintainers = with maintainers; [ zeri42 ];
  };
}
