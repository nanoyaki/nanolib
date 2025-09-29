{
  self,
  inputs,
  lib,
  withSystem,
  ...
}:

let
  inherit (inputs) nixpkgs;
  inherit (builtins) map;

  lib' = {
    global.toUppercase =
      str:
      (lib.strings.toUpper (builtins.substring 0 1 str))
      + builtins.substring 1 (builtins.stringLength str) str;

    options = import ./options.nix { inherit lib lib'; };
    types = import ./types.nix { inherit lib lib'; };
    systems = import ./systems.nix { inherit self inputs withSystem; };
  };
in

lib'
