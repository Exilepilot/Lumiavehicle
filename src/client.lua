--[[
    Written by Pilot
--]]


--[[
    shop
--]]

shop = {}
shop._index = shop

carshopWindow = guiCreateWindow(500,200,290,440,"Car Shop",false)
guiSetVisible (carshopWindow, false)
guiSetAlpha(carshopWindow,1)
guiWindowSetSizable(carshopWindow,false)
selectLabel = guiCreateLabel(0.0423,0.1009,0.8889,0.078,"Select your car",true,carshopWindow)
guiSetAlpha(selectLabel,1)
guiLabelSetColor(selectLabel,255,255,255)
guiLabelSetVerticalAlign(selectLabel,"top")
guiLabelSetHorizontalAlign(selectLabel,"left",false)
guiSetFont(selectLabel,"default-bold-small")
carGridList = guiCreateGridList(0.0476,0.1789,0.9048,0.6789,true,carshopWindow)
guiGridListSetSelectionMode(carGridList,0)
carColumn = guiGridListAddColumn(carGridList,"Car",0.5)
costColumn = guiGridListAddColumn(carGridList,"$",0.3)
local cars = {{579,60000},{400,60000},{404,28000},{489,65000},{505,65000},{479,45000},{442,45000},{458,45000},{602,50000},{496,42500},{401,41000},{518,60000},{527,75000},{589,75000},{419,45000},{533,75000},{526,50000},{474,55000},{545,50000},{517,45000},{410,41000},{600,50000},{436,41000},{580,50000},{439,75000},{549,75000},{491,45000},{445,45000},{507,45000},{585,45000},{587,75000},{466,55000},{492,50000},{546,45000},{551,45000},{516,45000},{467,45000},{426,47500},{547,45000},{405,55000},{409,75000},{550,45000},{566,45000},{540,45000},{421,50000},{529,45000},{402,120000},{542,65000},{603,120000},{475,75000},{562,120000},{565,95000},{559,120000},{561,50000},{560,120000},{558,100000},{429,120000},{541,120000},{415,120000},{480,95000},{434,100000},{494,120000},{502,120000},{503,120000},{411,120000},{506,120000},{451,120000},{555,95000},{477,95000},{499,25000},{498,25000},{578,50000},{486,70000},{455,75000},{588,50000},{403,75000},{414,50000},{443,75000},{515,75000},{514,75000},{531,12000},{456,45000},{422,45000},{482,95000},{530,12000},{418,45000},{572,12000},{582,50000},{413,50000},{440,50000},{543,65000},{583,12000},{478,35000},{554,50000},{536,75000},{575,75000},{534,75000},{567,75000},{535,75000},{576,75000},{412,75000},{568,75000},{457,12000},{483,45000},{508,40000},{571,10000},{500,55000},{444,120000},{556,120000},{557,120000},{471,20000},{495,100000},{539,75000},{481,2500},{509,2500},{581,45000},{462,12000},{521,60000},{463,50000},{522,75000},{448,12000},{468,45000},{586,45000},{485,12000},{431,60000},{438,45000},{437,60000},{574,12000},{420,45000},{525,75000},{408,50000},{428,65000}}
for i,v in ipairs (cars) do
    local carName = getVehicleNameFromModel (v[1])
    local row = guiGridListAddRow (carGridList)
    guiGridListSetItemText (carGridList, row, 1, carName, false, true)
    guiGridListSetItemText (carGridList, row, 2, tostring(v[2]), false, true)
end
guiSetAlpha(carGridList,1)
buyButton = guiCreateButton(0.0476,0.8624,0.7778,0.0963,"Buy it!",true,carshopWindow)
guiSetAlpha(buyButton,1)
closeButton = guiCreateButton(0.8571,0.8624,0.0899,0.1009,"x",true,carshopWindow)

function shop:open(source)
    local visible = guiGetVisible(carshopWindow)
    if getLocalPlayer() == source then
        if not visible then
            guiSetVisible(carshopWindow, true)
            showCursor(true)
        end
    end
        return
end
addEvent("shop:open", true)
addEventHandler("shop:open", getRootElement(),
function()
    shop:open(source)
end)

function shop:close(source)
    local visible = guiGetVisible(carshopWindow)
    if getLocalPlayer() == source then
        if visible then
            guiSetVisible(carshopWindow, false)
            showCursor(false)
        end
    end
        return
end

addEvent("shop:close", true)
addEventHandler("shop:close", getRootElement(),
function()
    shop:close(source)
end)

addEventHandler("onClientGUIClick", closeButton,
function()
    triggerEvent("shop:close", getLocalPlayer())
end, false )



function shop:buy()
    if guiGridListGetSelectedItem(carGridList) then
        local carName = guiGridListGetItemText (carGridList, guiGridListGetSelectedItem (carGridList), 1)
        local carID = getVehicleModelFromName (carName)
        local carCost = guiGridListGetItemText (carGridList, guiGridListGetSelectedItem (carGridList), 2)
        triggerServerEvent("shop:buy", getLocalPlayer(), tonumber(carID), carName, tonumber(carCost))
    end
        return
end
addEventHandler("onClientGUIClick", buyButton,
function()
    shop:buy()
end,false)



--[[
 Main panel
--]]

menu = {}
menu._index = menu

local screenX, screenY = guiGetScreenSize()
local width, height = 200, 200
local x = (screenX/2) - (width/2)
local y = (screenY/2) - (height/2)
local lp = getLocalPlayer()

theWindow = guiCreateWindow(x,y,width,height,"Car Features",false)
guiWindowSetSizable(theWindow,false)
guiSetVisible (theWindow, false)
spawnBut = guiCreateButton(0.0604,0.120,0.4,0.2,"Car list",true,theWindow)
engenieBut = guiCreateButton(0.0604,0.420,0.4,0.2,"Engine toggle",true,theWindow)
lockBut = guiCreateButton(0.490,0.420,0.4,0.2,"Lock toggle",true,theWindow)
lightsBut = guiCreateButton(0.0604,0.720,0.4,0.2,"Lights",true,theWindow)
destroyBut = guiCreateButton(0.490,0.120,0.4,0.2,"Unspawn",true,theWindow)

-- toggle the menu because quickness is the key
function menu:toggle()
    local visible = guiGetVisible(theWindow)
    if not visible then
            guiSetVisible(theWindow, true)
            showCursor(true)
    else
        if not guiGetVisible(spawner.window[1]) then
            guiSetVisible(theWindow, false)
            showCursor(false)
        else
            guiSetVisible(theWindow, false)
        end
    end
        return
end
-- Register it to an event
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function()
    bindKey("F3", "Down",
    function()
        menu:toggle()
    end)
end)

function menu:unSpawn()
    triggerServerEvent("car:unspawn", getLocalPlayer())
end
addEventHandler("onClientGUIClick", destroyBut,
function()
    menu:unSpawn()
end)

--[[
    spawner
--]]

spawner = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

spawner._index = spawner
spawner.setVisible = guiSetVisible
spawner.row = 0

spawner.window[1] = guiCreateWindow(0.33, 0.13, 0.34, 0.72, "Car list", true)
guiWindowSetMovable(spawner.window[1], false)
guiWindowSetSizable(spawner.window[1], false)
spawner.gridlist[1] = guiCreateGridList(0.05, 0.07, 0.90, 0.77, true, spawner.window[1])
guiGridListAddColumn(spawner.gridlist[1], "Vehicle", 0.4)
guiGridListAddColumn(spawner.gridlist[1], "ID", 0.4)
-- for i = 1, 2 do
--     guiGridListAddRow(spawner.gridlist[1])
-- end
--------------------------------------------R--C
------------------------------------------ROW  COLLUMN

-- guiGridListSetItemText(spawner.gridlist[1], 0, 1, "400 611", false, false)
-- guiGridListSetItemText(spawner.gridlist[1], 0, 2, "-", false, false)

spawner.button[1] = guiCreateButton(0.35, 0.85, 0.30, 0.05, "Spawn", true, spawner.window[1])
guiSetProperty(spawner.button[1], "NormalTextColour", "FFAAAAAA")
spawner.button[2] = guiCreateButton(0.67, 0.85, 0.30, 0.05, "Sell", true, spawner.window[1])
guiSetProperty(spawner.button[2], "NormalTextColour", "FFAAAAAA")
spawner.button[3] = guiCreateButton(0.03, 0.85, 0.30, 0.05, "destroy", true, spawner.window[1])
guiSetProperty(spawner.button[3], "NormalTextColour", "FFAAAAAA")
spawner.button[4] = guiCreateButton(0.35, 0.91, 0.30, 0.05, "Close", true, spawner.window[1])
guiSetProperty(spawner.button[4], "NormalTextColour", "FFAAAAAA")
spawner.label[1] = guiCreateLabel(0.08, 0.03, 0.84, 0.03, "Please report and bugs. Don't exploit them, unless on dimension /b/.", true, spawner.window[1])
guiSetFont(spawner.label[1], "default-bold-small")
guiSetVisible(spawner.window[1], false)


function spawner:open()
    local visible = guiGetVisible(self.window[1])
    local menu = guiGetVisible(theWindow)
    if not visible then
        if menu  then
            guiSetVisible(theWindow, false)
        end
        triggerServerEvent("gridlist:update",getLocalPlayer())
        guiSetVisible(self.window[1],true)
        if isCursorShowing() == false then
            showCursor(true)
        end
    end
end

addEventHandler("onClientGUIClick", spawnBut,
function()
    spawner:open()
end,
false)

addCommandHandler("mycars",
function()
    spawner:open()
end)

function spawner:close()
    local visible = guiGetVisible(self.window[1])
    if visible then
        guiSetVisible(self.window[1], false)
        if isCursorShowing() then
            showCursor(false)
        end
    end
end

addEventHandler("onClientGUIClick", spawner.button[4],
function()
    spawner:close()
end, false)

function spawner:updateList( vehicleName, id )
    if #vehicleName > 0 then
        guiGridListAddRow(self.gridlist[1])
        guiGridListSetItemText(spawner.gridlist[1], self.row, 1, vehicleName, false, false)
        guiGridListSetItemText(spawner.gridlist[1], self.row, 2, tostring(id), false, false)
        self.row = self.row + 1
    else
        error("Vehicle name isn't long enough. Expected > 0 got less")
    end
end
addEvent("spawner:updateList", true)
addEventHandler("spawner:updateList", getRootElement(),
function(vehicleName, id)
    spawner:updateList(vehicleName, id)
end)

function spawner:resetRow()
    self.row = 0
end
addEvent("spawner:resetRow", true)
addEventHandler("spawner:resetRow", getRootElement(),
function()
    spawner:resetRow()
end)

function spawner:deleteList()
    guiGridListRemoveRow(self.gridlist[1], self.row)
end
addEvent("spawner:deleteList",true)
addEventHandler("spawner:deleteList", getRootElement(),
function()
    spawner:deleteList()
end)


-- We give the player an option to remove their car from the list. 
-- TODO: Give the player a warning box to stop them accidently removing 
-- their precious cars. 

function spawner:remove( row )
    if not (row == -1) then
        local remove = guiGridListRemoveRow(self.gridlist[1], row)
        if remove then
            outputChatBox("Car removed from your inventory.", 10, 255, 0, false)
            outputDebugString("Removed row")
        end
    else
        outputChatBox("Please select a car to remove on the gridlist. ", 255,0,0, false)
    end
    return
end

addEventHandler("onClientGUIClick", spawner.button[3],
function()
    local row, collumn = guiGridListGetSelectedItem(spawner.gridlist[1])
    local vehicleName = guiGridListGetItemText ( spawner.gridlist[1], row, collumn )
    -- Remove it from DB
    triggerServerEvent("car:destroy", getLocalPlayer(), getVehicleModelFromName(vehicleName),vehicleName)
    spawner:remove( row )
end,
false)

function spawner:spawn(vehicleID)
    if vehicleID >= 400 and vehicleID <= 611 then
        setElementData(getLocalPlayer(),'currentCar', tostring(vehicleID))
        triggerServerEvent("car:spawn", getLocalPlayer())
    end
end
addEventHandler("onClientGUIClick", spawner.button[1],
function()
    local row, collumn = guiGridListGetSelectedItem(spawner.gridlist[1])
    local vehicleName = guiGridListGetItemText ( spawner.gridlist[1], row, collumn )
    local id = getVehicleModelFromName(vehicleName)
    spawner:spawn(id)
end,
false)

