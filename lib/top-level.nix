# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  self,
}:

let
  lib' = {
    global.toUppercase =
      str:
      (lib.strings.toUpper (builtins.substring 0 1 str))
      + builtins.substring 1 (builtins.stringLength str) str;

    options = import ./options.nix { inherit lib lib'; };
    types = import ./types.nix { inherit lib; };
    systems = import ./systems.nix { inherit lib self; };
  };
in

lib'
