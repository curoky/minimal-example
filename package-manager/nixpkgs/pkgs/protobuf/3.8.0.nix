{ callPackage, ... } @ args:

callPackage ./generic-v3.nix ({
  version = "3.8.0";
  sha256 = "sha256-qK4Tb6o0SAN5oKLHocEIIKoGCdVFQMeBONOQaZQAlG4=";
} // args)
