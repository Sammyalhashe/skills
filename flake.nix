{
  description = "Sammyalhashe's AI skills and agents";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    { self, nixpkgs, home-manager }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] f;
      marketplace = "user";
      plugin = "skills";
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          ai-skills = import ./modules/install_skills.nix {
            pkgs = pkgs;
            src = self;
            inherit marketplace plugin;
          };

          default = self.packages.${system}.ai-skills;
        }
      );

      homeManagerModules = {
        ai-skills = import ./modules/home-manager.nix {
          inherit marketplace plugin;
        };
      };
    };
}
