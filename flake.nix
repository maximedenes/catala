{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:maximedenes/nixpkgs/init-ocamlPackages-ninja_utils";
  };

  outputs = {nixpkgs, flake-utils, ...}:
    let
      systems = [ "x86_64-linux" ];
    in flake-utils.lib.eachSystem systems (system:
        rec {

          packages.catala =

            let
              pkgs = import nixpkgs { inherit system; };
              ocamlPackages = pkgs.callPackage ./.nix/packages.nix {};
            in

            ocamlPackages.buildDunePackage {
              pname = "catala";
              version = "0.8.0"; # TODO parse `catala.opam` with opam2json

              minimumOCamlVersion = "4.11";

              src = ./.;

              duneVersion = "3";

              nativeBuildInputs = [
                pkgs.ocaml-crunch
              ] ++ (with ocamlPackages; [
                cppo
                menhir
                js_of_ocaml-compiler
              ]);

              propagatedBuildInputs = [
                pkgs.z3
              ] ++ (with ocamlPackages; [
                alcotest
                ansiterminal
                benchmark
                bindlib
                cmdliner
                dates_calc
                js_of_ocaml
                js_of_ocaml-ppx
                menhirLib
                ocamlgraph
                ppx_deriving
                ppx_yojson_conv
                re
                sedlex
                ubase
                unionfind
                visitors
                z3
                zarith
                zarith_stubs_js
                cohttp-lwt-unix
                ocolor
                dune-build-info
                ninja_utils
              ]);

              # Currently there is no unit tests in catala and Cram tests are handled by clerk
              doCheck = false;

              meta = with pkgs.lib; {
                homepage = "https://catala-lang.org";
                description =
                  "Catala is a domain-specific programming language designed for deriving correct-by-construction implementations from legislative texts.";
                license = licenses.asl20;
                maintainers = with maintainers; [ ];
              };
            };

          defaultPackage = packages.catala;
          devShell =
            with import nixpkgs { inherit system; };
            let op = ocamlPackages_4_14; in
            mkShell {
              inputsFrom = [ packages.catala ];
              buildInputs = [
                inotify-tools
                op.merlin
                ocamlformat_0_26_0
                op.ocp-indent
                op.utop
                op.odoc
                op.ocaml-lsp
                groff
                obelisk
                ninja
                colordiff
                pandoc
                python3.pkgs.pygments
                nodejs
                nodePackages.npm
              ];
          };
        }
    );
}
