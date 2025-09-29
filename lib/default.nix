{
  self,
  inputs,
  lib,
  withSystem,
  ...
}@flakePartsArgs:

{
  flake.lib = import ./top-level.nix flakePartsArgs;
}
