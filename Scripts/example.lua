-- EmilyUi Lua API example
-- Version is used by Config.lua to download this file only when it changes.
local API = ...
API:SetVersion("1.0.0")

-- Layout: Section, Label, Paragraph and Divider are informational elements.
API:Section("Example")
API:Paragraph("Lua API", "Controls created here are shown in Ui -> Lua -> Script items and are saved by Ui -> Config.")
local status = API:Label("Status: ready")

-- Stateful controls return objects with :Get(), :Set(value, silent) and :SetVisible(bool).
API:Toggle("Enabled", false, function(value) status:Set("Enabled: " .. tostring(value)) end)
API:Checkbox("Checkbox", true, function(value) status:Set("Checkbox: " .. tostring(value)) end)
API:Slider("Power", 0, 100, 25, function(value) status:Set("Power: " .. tostring(value)) end, {Step = 1})
API:NumberBox("Count", 3, 1, 100, function(value) status:Set("Count: " .. tostring(value)) end, {Integer = true})
API:Dropdown("Mode", {"One", "Two", "Three"}, "One", function(value) status:Set("Mode: " .. value) end)
API:MultiDropdown("Targets", {"Players", "NPC", "Friends"}, {"Players"}, function(values)
    status:Set("Targets: " .. table.concat(values, ", "))
end)
API:ColorInput("Color", Color3.fromRGB(80, 200, 255), function(value)
    status:Set(string.format("RGB: %d, %d, %d", value.R * 255, value.G * 255, value.B * 255))
end)

-- Keybind supports Keyboard and MouseButton inputs plus Toggle/Hold modes.
-- Every API:Keybind is automatically displayed in Ui -> Keybinds.
API:Keybind("Example bind", Enum.KeyCode.K, function(active, key, mode)
    status:Set(string.format("%s / %s / %s", key.Name, mode, tostring(active)))
end, {Mode = "Toggle"})

API:TextBox("Text...", function(text, box, enterPressed)
    if enterPressed then status:Set(text); box.Text = "" end
end)
API:SearchBox("Search...", "Find", function(text) status:Set("Search: " .. text) end)
API:PlayerList("Player", game:GetService("Players").LocalPlayer.Name, function(player, name)
    status:Set(player and ("Player: " .. name) or "Player left")
end)

local progress = API:ProgressBar("Progress", 20)
API:Button("Add progress", function() progress:Set(math.min(100, progress:Get() + 10)) end)
API:Image("rbxthumb://type=AvatarHeadShot&id=" .. game:GetService("Players").LocalPlayer.UserId .. "&w=150&h=150", {Height = 80})

-- Script-local tabs have a horizontal scroll bar and arrows when many tabs are added.
local main = API:Tab("Main")
local advanced = API:Tab("Advanced")
main:Label("Main tab")
advanced:Label("Advanced tab")

-- Module example: uncomment this block in a separate Lua file.
--[[
local Module = API:CreateModule({Name = "My Module", Version = "1.0.0"})
local General = Module:Tab("General")
General:Toggle("Feature", false, function(enabled) end)
General:Keybind("Feature key", Enum.KeyCode.G, function(active, key, mode) end, {Mode = "Toggle"})
Module:MenuToggle("My Module", false, function(enabled) end)
Module:RegisterConfig(function()
    return {Enabled = false}
end, function(saved)
    -- Apply saved module state here.
end)
Module:OnUnload(function()
    -- Stop loops and restore changed game state here.
end)
return Module
]]

API:OnUnload(function()
    -- Connections created with API:Connect and objects registered with API:TrackInstance
    -- are cleaned automatically. Restore any other state here.
end)

return function()
    -- Optional final cleanup callback.
end
