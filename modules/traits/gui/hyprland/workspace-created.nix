{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        # https://wiki.hypr.land/0.57.0/configuring/code-snippets/#launching-programs-on-workspace-creation
        # REVIEW:
        # - logic on ws.is_empty check is reversed in upstream snippet
        # - pairs() missing from upstream snippet, resulting in error
        wayland.windowManager.hyprland.extraConfig = ''
          workspace_programs = {}

          hl.on("workspace.created", function(ws)
              if not ws.is_empty then return end

              local program = workspace_programs[ws.name]
              if program == nil then return end

              local cmd, rules = table.unpack(program)
              -- shallow-copy the rules table so we can add the workspace to it
              local rules2 = {}
              for k, v in pairs(rules) do rules2[k] = v end
              rules2.workspace = ws.name .. " silent"
              -- run it!
              hl.exec_cmd(cmd, rules2)
          end)
        '';
      };
    };
}
