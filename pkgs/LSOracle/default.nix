{lib
, stdenv
, fetchgit
, cmake
, boost
, python
, readline
}:
stdenv.mkDerivation rec {
  name = "LSOracle";
  version = "v0.3.0-rc1";

  src = fetchgit {
    url = "https://github.com/The-OpenROAD-Project/LSOracle.git";
    fetchSubmodules = true;
    rev = "refs/tags/${version}";
    sha256 = "08z051h1w4paf5cacfilxqjfh4bn39sji5qp2pap078yxh5glip3";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    python
    readline
  ];

  meta = with lib; {
    description = "The Logic Synthesis oracle";
    homepage = "https://github.com/The-OpenROAD-Project";
    license = licenses.mit;
    maintainers = with maintainers; [ zeri42 ];
  };
}
