self:
let
  inherit (self.inputs.nixpkgs.lib.lists) unique;

  systems = self.lib.boxen |> builtins.catAttrs "system" |> unique;
in
systems
