let
  sources = import ./nix/sources.nix;
  nixpkgs-mozilla = import sources.nixpkgs-mozilla;
  pkgs = import sources.nixpkgs { overlays = [ nixpkgs-mozilla ]; };
  myrust = ((pkgs.rustChannelOf {
      date = "2020-09-28";
      channel = "nightly"; }
    ).rust.override {
      extensions = [ "rust-src" "rust-analysis" "rustfmt-preview" ];
      targets = [ "wasm32-unknown-unknown" ];
    });
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    niv
    bashInteractive
    myrust
    cacert
    llvmPackages.clang-unwrapped
  ];

  PROTOC="${pkgs.protobuf}/bin/protoc";
  PROTOC_INCLUDE="${pkgs.protobuf}/include";
  LIBCLANG_PATH="${pkgs.llvmPackages.libclang}/lib";
}
