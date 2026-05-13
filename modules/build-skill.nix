{ pkgs, skillSrc, skillName }:

pkgs.stdenvNoCC.mkDerivation {
  name = "skill-${skillName}";
  src = skillSrc;

  phases = [ "installPhase" ];

  installPhase = ''
    for platform in claude gemini openai; do
      mkdir -p "$out/$platform/${skillName}"
      cp -r $src/. "$out/$platform/${skillName}/"
    done
  '';
}
