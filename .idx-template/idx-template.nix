{
  pkgs,
  astroTemplate ? "basics",
  astroVersion ? "latest",
  typescript ? "strict",
  ...
}:
{
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.nixfmt
  ];

  bootstrap = ''
    mkdir "$out"
    npm create astro@${astroVersion} \"$out\" -- --template ${astroTemplate} --typescript ${typescript} --git --no-install

    mkdir -p "$out"/.idx
    cp ${./dev.nix} "$out/.idx/dev.nix"
    cp ${./icon.png} "$out/.idx/icon.png"

    ( cd \$out && npm i --package-lock-only --ignore-scripts )
  '';
}