# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "An extension for nixpkgs with nightly package updates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, withSystem, ... }:

      {
        imports = [
          ./lib
        ];

        flake.overlays = {
          default = self.flake.overlays.nanolib;
          nanolib = (
            final: prev: {
              lib = prev.lib.extend (
                _: _lib: {
                  nanolib = import ./lib/top-level.nix {
                    lib = _lib;
                    inherit inputs withSystem self;
                  };
                }
              );
            }
          );
        };

        perSystem =
          { config, pkgs, ... }:

          {
            formatter = pkgs.nixfmt-tree;
          };

        systems = import systems;
      }
    );
}
