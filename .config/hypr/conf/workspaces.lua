-- ~/.config/hypr/conf/workspaces.lua

-- Your original file had several separate `workspace = N, ...` lines for
-- the same workspace ID (monitor assignment on one line, persistent:true
-- on another). In hyprlang those merge into one rule per ID; here they're
-- combined into a single hl.workspace_rule() call per workspace instead
-- of issuing multiple calls for the same ID, since it's the more direct
-- Lua equivalent of that merge behavior.

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1", persistent = true })
