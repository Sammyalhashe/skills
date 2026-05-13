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

      buildSkill = import ./modules/build-skill.nix;
      buildAgent = import ./modules/build-agent.nix;
      buildRules = import ./modules/build-rules.nix;

      localSkillNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs (_: type: type == "directory")
          (builtins.readDir ./skills)
      );

      localAgentNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs (_: type: type == "directory")
          (builtins.readDir ./agents)
      );
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          composeSkills = import ./modules/compose-skills.nix { inherit pkgs; };

          localSkillPackages = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = buildSkill {
                inherit pkgs;
                skillName = name;
                skillSrc = ./skills/${name};
              };
            }) localSkillNames
          );

          localAgentPackages = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = buildAgent {
                inherit pkgs;
                agentName = name;
                agentSrc = ./agents/${name};
              };
            }) localAgentNames
          );

          rulesPackage = buildRules {
            inherit pkgs;
            rulesSrc = ./rules;
          };

          downloadedResult = import ./modules/downloaded-skills.nix {
            inherit pkgs marketplace plugin;
          };

          localSkillsComposed = composeSkills {
            skills = builtins.attrValues localSkillPackages;
            agents = builtins.attrValues localAgentPackages;
            rules = rulesPackage;
            binSrc = ./bin;
            hooksSrc = ./hooks;
            name = "ai-skills";
          };

          skillOutputs = nixpkgs.lib.mapAttrs'
            (name: drv: { name = "skill-${name}"; value = drv; })
            (localSkillPackages // downloadedResult.individualSkills);

          agentOutputs = nixpkgs.lib.mapAttrs'
            (name: drv: { name = "agent-${name}"; value = drv; })
            localAgentPackages;
        in
        skillOutputs // agentOutputs // {
          rules = rulesPackage;

          local-skills = localSkillsComposed;
          downloaded-skills = downloadedResult.aggregate;

          ai-skills = pkgs.symlinkJoin {
            name = "ai-skills";
            paths = [ localSkillsComposed downloadedResult.aggregate ];
          };

          default = self.packages.${system}.ai-skills;
        }
      );

      lib = {
        composeSkills = system:
          import ./modules/compose-skills.nix {
            pkgs = nixpkgs.legacyPackages.${system};
          };
      };

      homeManagerModules = {
        ai-skills = import ./modules/home-manager.nix {
          inherit marketplace plugin;
          skillsFlake = self;
        };
      };
    };
}
