nix-aci.sh will generate an APPC spec application container image which can be executed using the rocket container runtime

See below for spec and rocket details:
https://github.com/appc/spec/
https://github.com/coreos/rocket

Requires a container manifest and nix configuration file

By default the container manifest file is assumed to be "manifest" and the nix configuration is "configuration.nix" in $PWD

This script was hacked out of code from the nix provisioner for vagga:
https://github.com/tailhook/vagga
Here is and example test you can run inside the container once built.


  cmd="/bin/hello"
  app=hello
  pkg=hello


  cat << EOF > default.nix
  let
    pkgs = import <nixpkgs> { };
  in {
    sphinx = pkgs.buildEnv {
      name = "$app";
      paths = with pkgs; with pkgs.pythonPackages; [
        $pkg
      ];
    };
  }
  EOF

  cat << EOF > manifest
  {
      "acKind": "ImageManifest",
      "acVersion": "0.0.1",
      "name": "$app",
      "labels": [
          {"name": "os", "value": "linux"},
          {"name": "arch", "value": "amd64"}
      ],
      "app": {
          "exec": [
              "$cmd"
          ],
          "user": "0",
          "group": "0"
      },
      "mountPoints": [
              {
                  "name": "devnull",
                  "path": "/dev/null",
                  "readOnly": false
              }
          ]
  }
  EOF


  ~/nix-docker/nix-aci/nix-aci.sh

  sudo ~/rocket-v0.1.1/rkt -debug run $app.aci


