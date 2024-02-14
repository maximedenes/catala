{ ocaml-ng, fetchurl }:

ocaml-ng.ocamlPackages_4_14.overrideScope' (self: super: {
  alcotest = (super.alcotest.override {}).overrideAttrs (_: {
    doCheck = false;
  });
  unionfind = self.callPackage ./unionfind.nix { };
  ubase = self.callPackage ./ubase.nix { };
  dates_calc = self.callPackage ./dates_calc.nix { };
  ocolor = self.callPackage ./ocolor.nix { };
})
