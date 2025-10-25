# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  lib',
  self,
}:

rec {
  _mkSystem =
    type:

    {
      inputs,
      hostname,
      users,
      platform ? "x86_64-linux",
      config,
    }:

    let
      ensureInput = input: lib.throwIf (!(inputs ? ${input})) "Input ${input} is missing" inputs.${input};

      nixpkgs = ensureInput "nixpkgs";
      nanomodules = ensureInput "nanomodules";

      inputs' = lib.mapAttrs (
        _: input:
        lib.mapAttrs (
          _: flakeOutput: if flakeOutput ? ${platform} then flakeOutput.${platform} else flakeOutput
        ) input
      ) inputs;

      extendedLib = nixpkgs.lib.extend (
        _: lib: { nanolib = import ./top-level.nix { inherit lib self; }; }
      );

      prev = extendedLib.nixosSystem {
        specialArgs = {
          inherit (inputs) self;
          inherit inputs inputs' lib';

          self' = inputs'.self;
        };

        modules = [
          { nixpkgs.overlays = [ self.overlays.nanolib ]; }
          nanomodules.nixosModules.all
          (
            # i hate this lmao but i ain't looking up
            # how to do this correctly lololol
            (
              with builtins;
              elemAt (elemAt (elemAt nanomodules.nixosModules.nanoSystem.imports 0).imports 0).imports 0
            )
              {
                inherit
                  hostname
                  users
                  platform
                  type
                  ;
              }
          )
        ];
      };
    in

    prev.extendModules {
      modules = [ config ];
      specialArgs = { inherit prev; };
    };

  # No UI and deployment options
  mkServer = _mkSystem "server";
  # Full suite of UI applications
  mkDesktop = _mkSystem "desktop";
  # Prefer power efficiency
  mkPortable = _mkSystem "portable";
}
