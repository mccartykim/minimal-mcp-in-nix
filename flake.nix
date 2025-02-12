{
  description = "Honk MCP Server to give LLMs a voice on MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:adisbladis/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    pyproject-nix,
    uv2nix,
    pyproject-build-systems,
    ...
  }: let
    # Only support Darwin systems
    darwinSystems = nixpkgs.lib.filter (system: nixpkgs.lib.hasSuffix "-darwin" system) (import systems);
    forEachSystem = nixpkgs.lib.genAttrs darwinSystems;
    pkgsFor = forEachSystem (system: import nixpkgs {inherit system;});

    inherit (nixpkgs) lib;

    workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};

    overlay = workspace.mkPyprojectOverlay {
      sourcePreference = "wheel"; # or sourcePreference = "sdist";
    };

    pyprojectOverrides = _final: _prev: {
    };

    python = forEachSystem (system: pkgsFor.${system}.python312);

    pythonSets = forEachSystem (
      system:
        (pkgsFor.${system}.callPackage pyproject-nix.build.packages {
          python = python.${system};
        })
        .overrideScope
        (lib.composeManyExtensions
          [
            pyproject-build-systems.overlays.default
            overlay
            pyprojectOverrides
          ])
    );
  in {
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);

    packages = forEachSystem (system: {
      default = pythonSets.${system}.mkVirtualEnv "server" workspace.deps.default;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/server";
      };
    });
  };
}