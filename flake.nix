{
  nixConfig.bash-prompt = "[nix(circt):\\w]$ ";
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        overlays = [ (import ./nix/overlay.nix) ];
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
        packages = with pkgs; [
          zlib
          iverilog
          clang-yosys
          llvmPackages_19.clang-tools
          llvmPackages_19.clang
          llvmPackages.bintools
          llvm
          cmake
          gnumake
          ninja
          python3
        ];
        shellHook = ''
          export PATH=$PWD/circt/build/bin:$PATH;
        '';
      };
    };
}
