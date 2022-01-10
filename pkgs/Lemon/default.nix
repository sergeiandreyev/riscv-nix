{lib
, stdenv
, fetchzip
, cmake
}:
stdenv.mkDerivation rec {
  name = "LEMON";
  version = "1.3.1";

  src = fetchzip {
    url = "http://lemon.cs.elte.hu/pub/sources/lemon-${version}.tar.gz";
    sha256 = "0krxxp2p1zlkbwhn2pvfll8qhw70w2rh1yjss8a7ap1mck3c6q98";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Efficient Modeling and Optimization in Networks";
    homepage = "https://lemon.cs.elte.hu/trac/lemon";
    license = licenses.boost;
    maintainers = with maintainers; [ zeri42 ];
  };
}
