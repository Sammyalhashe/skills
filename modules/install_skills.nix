{ pkgs, src, marketplace, plugin }:

pkgs.stdenvNoCC.mkDerivation {
  name = "ai-skills";
  inherit src;

  installPhase = ''
    # Remove any stale result symlink from source
    rm -rf $out/result

    # Base plugin directory with subdirectories
    mkdir -p $out/plugins/${marketplace}/plugins/${plugin}/skills
    mkdir -p $out/plugins/${marketplace}/plugins/${plugin}/agents
    mkdir -p $out/plugins/${marketplace}/plugins/${plugin}/downloaded

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
}
