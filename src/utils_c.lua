--[[
    AUTHOR: Pilot
    This will contain helper functions and gui interfaces that will be
    in the script.
--]]


--[[
    Warning panel - Warning players to make their final decision. 
    We want out players to understand what they're about to do, so 
    implementing this will be useful. 
--]]

warning_panel = {}
warning_panel._index = warning_panel




warning_panel = {
    button = {},
    window = {},
    label = {},
    memo = {}
}
warning_panel.window[1] = guiCreateWindow(0.25, 0.21, 0.49, 0.58, "WARNING", true)
guiWindowSetMovable(warning_panel.window[1], false)
guiWindowSetSizable(warning_panel.window[1], false)

warning_panel.memo[1] = guiCreateMemo(0.05, 0.11, 0.90, 0.69, "", true, warning_panel.window[1])
guiMemoSetReadOnly(warning_panel.memo[1], true)
warning_panel.label[1] = guiCreateLabel(0.05, 0.06, 0.90, 0.03, "What you're doing could be potientially undoable. Take caution!", true, warning_panel.window[1])
guiSetFont(warning_panel.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(warning_panel.label[1], "center", false)
warning_panel.button[1] = guiCreateButton(0.05, 0.82, 0.45, 0.08, "ACCEPT", true, warning_panel.window[1])
guiSetProperty(warning_panel.button[1], "NormalTextColour", "FFAAAAAA")
warning_panel.button[2] = guiCreateButton(0.50, 0.82, 0.45, 0.08, "DECLINE", true, warning_panel.window[1])
guiSetProperty(warning_panel.button[2], "NormalTextColour", "FFAAAAAA")
warning_panel.label[2] = guiCreateLabel(0.37, 0.95, 0.26, 0.03, "Don't show again", true, warning_panel.window[1])
guiSetFont(warning_panel.label[2], "default-bold-small")
guiLabelSetColor(warning_panel.label[2], 253, 1, 2)
guiLabelSetHorizontalAlign(warning_panel.label[2], "center", false)
guiSetVisible(warning_panel.window[1], false)


function warning_panel:show(msg)
    local visible = guiGetVisible(self.window[1])
    if msg == nil then 
        msg = self.message or "No message found"
    end 

    if not (visible) then
        guiSetVisible(self.window[1], true)
        guiBringToFront(self.window[1])
        guiSetText(self.memo[1], msg)
        guiSetProperty(self.button[1], 'Disabled', 'True')
        guiSetProperty(self.button[2], 'Disabled', 'True')
        setTimer(
        function()
            guiSetProperty(self.button[1], 'Disabled', 'False')
            guiSetProperty(self.button[2], 'Disabled', 'False')
        end, 2000, 1)
    end 
end 

-- Call function on button press
function warning_panel:onAccept(func)
    if type(func) == 'function' then 
        addEventHandler("onClientGUIClick", self.button[1], func, false)
    end 
end

function warning_panel:onDecline(func)
    if type(func) == 'function' then 
        addEventHandler("onClientGUIClick", self.button[2], func, false)
    end 
end

-- Close the panel 
function warning_panel:close()
    local visible = getGuiVisible(self.window[1])
    if visible then 
        guiSetVisible(self.window[1], false)
    end 
end 