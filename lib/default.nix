# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  lib,
  self,
  ...
}:

{
  flake.lib = import ./top-level.nix { inherit lib self; };
}
