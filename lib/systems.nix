{
  self,
  inputs,
  withSystem,
}:

let
  inherit (inputs) nanomodules nixpkgs;
in

rec {
  _mkSystem =
    type:

    {
      hostname,
      users,
      platform ? "x86_64-linux",
      config,
    }:

    (withSystem platform (
      { inputs', self', ... }:

      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs'
            inputs
            self'
            self
            ;
        };

        modules = [
          { nixpkgs.overlays = [ self.overlays.nanolib ]; }
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
      }
    ));

  # No UI and deployment options
  mkServer = _mkSystem "server";
  # Full suite of UI applications
  mkDesktop = _mkSystem "desktop";
  # Prefer power efficiency
  mkPortable = _mkSystem "portable";
}
