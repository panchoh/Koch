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
              -- ws might not be empty if created by a window_rule that moves a window there
              if not ws.is_empty then return end

              local ws_target = ws.id or ws.name
              if not ws_target then return end

              local program = workspace_programs[tostring(ws_target)]
              if program == nil then return end

              local cmd, rules = table.unpack(program)
              -- shallow-copy the rules table so we can add the workspace to it
              local rules2 = {}
              for k, v in pairs(rules) do rules2[k] = v end

              -- ws might not be the active one, if created via a rule
              rules2.workspace = ws_target .. " silent"

              -- run it!
              hl.exec_cmd(cmd, rules2)
          end)
        '';
      };
    };
}
