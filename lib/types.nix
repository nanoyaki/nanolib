{ lib, ... }:

let
  inherit (lib) types;
in

{
  singleAttrOf =
    elemType:
    (types.attrsOf elemType)
    // {
      check = actual: (lib.isAttrs actual) && ((lib.lists.length (lib.attrValues actual)) == 1);
    };

  system = types.enum [
    "server"
    "desktop"
    "portable"
  ];

  powerOf2 = types.ints.positive // {
    check = actual: types.ints.positive.check actual && (builtins.bitAnd actual (actual - 1)) == 0;
  };
}
