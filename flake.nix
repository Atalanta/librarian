{
  description = "Clojure development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, emacs-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            temurin-bin-21
            clojure
            clojure-lsp
	    git
            
            ((emacsPackagesFor emacs29).emacsWithPackages (epkgs: [
              epkgs.cider
              epkgs.clojure-mode
              epkgs.paredit
              epkgs.rainbow-delimiters
	      epkgs.magit
            ]))
          ];
        };
      });
}
