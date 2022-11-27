{ pkgs, ... }:
let
  nodejs = pkgs.nodejs-18_x;
  yarn = pkgs.yarn.override { nodejs = nodejs; };
in
{
  packages = [
    pkgs.git
    nodejs
    yarn
  ];

  enterShell = ''
    export POSTGRES_DATA_DIR=$(cd .devenv/state/postgres/; pwd)
    export DATABASE_URL="postgresql://$USER:@localhost/$(basename "$PWD")-development?host=$POSTGRES_DATA_DIR/"
    export TEST_DATABASE_URL="postgresql://$USER:@localhost/$(basename "$PWD")-test?host=$POSTGRES_DATA_DIR/"
  '';

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  processes.app.exec = "yarn dev --hostname 127.0.0.1 --port 3000";
  postgres.enable = true;
}
