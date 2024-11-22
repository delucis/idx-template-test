{
  pkgs,
  astroTemplate ? "basics",
  astroVersion ? "latest",
  packageManager ? "npm",
  typescript ? "strict",
  git ? true,
  ...
}:
{
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.j2cli
    pkgs.nixfmt
  ];

  bootstrap = ''
    mkdir "$out"
    ${
      if packageManager == "npm" then
        "npm create astro@${astroVersion} \"$out\" -- --template ${astroTemplate} --typescript ${typescript} ${
          if git then "--git" else "--no-git"
        } --no-install"
      else
        ""
    }

    mkdir -p "$out"/.idx
    packageManager=${packageManager} j2 ${./devNix.j2} -o "$out"/.idx/dev.nix
    nixfmt "$out"/.idx/dev.nix
    cp ./icon.png "$out"/.idx/icon.png

    ${
      if packageManager == "npm" then "( cd \$out && npm i --package-lock-only --ignore-scripts )" else ""
    }
  '';
}
