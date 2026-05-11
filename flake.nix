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
          ai-skills = pkgs.stdenvNoCC.mkDerivation {
            name = "ai-skills";
            src = self;

            installPhase = ''
              # Remove any stale result symlink from source
              rm -rf $out/result

              # Base plugin directory with subdirectories
              mkdir -p $out/plugins/${marketplace}/plugins/${plugin}/{skills,agents,downloaded}

              # Install skills
              if [ -d skills ]; then
                for skillDir in skills/*/; do
                  if [ -d "$skillDir" ] && [ "$(basename "$skillDir")" != "." ]; then
                    cp -r "$skillDir" $out/plugins/${marketplace}/plugins/${plugin}/skills/
                  fi
                done
              fi

              # Install agents
              if [ -d agents ]; then
                for agentDir in agents/*/; do
                  if [ -d "$agentDir" ] && [ "$(basename "$agentDir")" != "." ]; then
                    cp -r "$agentDir" $out/plugins/${marketplace}/plugins/${plugin}/agents/
                  fi
                done
              fi

              # Install downloaded skills/agents
              if [ -d downloaded ]; then
                for item in downloaded/*/; do
                  if [ -d "$item" ] && [ "$(basename "$item")" != "." ]; then
                    cp -r "$item" $out/plugins/${marketplace}/plugins/${plugin}/downloaded/
                  fi
                done
              fi
            '';
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
