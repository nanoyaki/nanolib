# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
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
      ensureInput = input: lib.throwIf (!(inputs ? input)) "Input ${input} is missing" inputs.${input};

      nixpkgs = ensureInput "nixpkgs";
      nanomodules = ensureInput "nanomodules";

      inputs' = lib.mapAttrs (
        _: input:
        lib.mapAttrs (
          _: flakeOutput: if flakeOutput ? ${platform} then flakeOutput.${platform} else flakeOutput
        ) input
      ) inputs;
    in

    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit (inputs) self;
        inherit inputs inputs';

        self' = inputs'.self;
      };

      modules = [
        { nixpkgs.overlays = [ self.overlays.nanolib ]; }
        nanomodules.nixosModules.all
        (nanomodules.nixosModules.nanoSystem {
          inherit
            hostname
            users
            platform
            type
            ;
        })
        config
      ];
    };

  # No UI and deployment options
  mkServer = _mkSystem "server";
  # Full suite of UI applications
  mkDesktop = _mkSystem "desktop";
  # Prefer power efficiency
  mkPortable = _mkSystem "portable";
}
