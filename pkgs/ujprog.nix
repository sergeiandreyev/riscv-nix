{
  stdenv,
  lib,
  fetchFromGitHub,
  libftdi,
  libftdi1,
  libusb,
}:

stdenv.mkDerivation {
  name = "ujprog";
  version = "unstable-2021-08-16";

  src = fetchFromGitHub {
    owner = "f32c";
    repo = "tools";
    rev = "0698352b0e912caa9b8371b8f692e19aac547a69";
    sha256 = "05gqvhg2yydvkfhzfr1kxr89amfzyvrnvx2pgnzi7qb2wljsj21a";
  };

  buildInputs = [ libftdi libftdi1 libusb ];

  buildCommand = ''
    cd "$src/ujprog"
    mkdir -p "$out/bin"
    $CC -x c "ujprog.c" -lftdi -lusb -o "$out/bin/ujprog"
  '';
}
