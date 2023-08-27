{ inputs, ... }:

with inputs.nixpkgs.lib;
let
  strToPath = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath ("${toString path}/${x}")
    else x;
  strToFile = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath ("${toString path}/${x}.nix")
    else x;
in
rec {
  mkUserHome = { config, system ? "x86_64-linux" }:
    { ... }: {
      imports = [
        (import ../home/common)
        (import ../home/modules)
        (import ../home/profiles)
        (import config) # eg. home/hosts/darktower.nix
      ];

      # For compatibility with nix-shell, nix-build, etc.
      home.file.".nixpkgs".source = inputs.nixpkgs;
      home.sessionVariables."NIX_PATH" =
        "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

      # set in host? fallback
      home.stateVersion = "23.05";
    };

  intoHomeManager = name: { config ? name, user ? "iff", system ? "x86_64-linux" }:
    let
      pkgs = inputs.self.pkgsBySystem."${system}";
      username = user;
      homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    in
    nameValuePair name (
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = { inherit username homeDirectory; };

            imports =
              let
                userConf = strToFile config ../home/hosts;
                home = mkUserHome { inherit system; config = userConf; };
              in
              [ home ];

            nix = {
              package = pkgs.nixVersions.stable;
              extraOptions = "experimental-features = nix-command flakes";
            };

            nixpkgs = {
              overlays = [ inputs.neovim-nightly-overlay.overlay ];
            };
          }
        ];
        extraSpecialArgs =
          let
            self = inputs.self;
          in
          { inherit inputs name self system; };
      }
    );

  intoNixOs = name: { config ? name, user ? "iff", system ? "x86_64-linux" }:
    nameValuePair name (
      let
        pkgs = inputs.self.pkgsBySystem."${system}";
        userConf = import (strToFile user ../user);
      in
      nixosSystem {
        inherit system;
        modules = [
          (
            { name, ... }: {
              networking.hostName = name;
            }
          )
          (
            { inputs, ... }: {
              nixpkgs = { inherit pkgs; };
            }
          )
          (
            { ... }: {
              system.stateVersion = "23.05";
            }
          )
          (inputs.home-manager.nixosModules.home-manager)
          (
            {
              home-manager = {
                # useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs =
                  let
                    self = inputs.self;
                    user = userConf;
                  in
                  # NOTE: Cannot pass name to home-manager as it passes `name` in to set the `hmModule`
                  { inherit inputs self system user; };
              };
            }
          )
          (import ../system/nixos/profiles)
          (import (strToPath config ../system/nixos/hosts))
        ];
        specialArgs =
          let
            self = inputs.self;
            user = userConf;
          in
          { inherit inputs name self system user; };
      }
    );
}
