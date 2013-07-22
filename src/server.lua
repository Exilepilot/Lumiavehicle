--[[
    Written by Pilot
--]]

--[[
    Markers and blips
--]]
markers = {}
markers._index = markers
markers.carShopMarker = createMarker (2133.59,-1149.29, 23.3, "cylinder", 3, 255, 0, 0, 127)
markers.carShopMarker2 = createMarker (562, -1270, 16, "cylinder", 2, 255, 0, 0, 127)
markers.carShopMarker3 = createMarker (-1954,299,34,"cylinder",2,255,0,0,127)
markers.carShopMarker4 = createMarker (-1663,1208,6,"cylinder",2,255,0,0,127)
markers.carShopMarker5 = createMarker (1946,2068,10,"cylinder",2,255,0,0,127)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
function()
    createBlipAttachedTo(markers.carShopMarker,55,2,0,255,0,0,0,200)
    createBlipAttachedTo(markers.carShopMarker2,55,2,0,255,0,0,0,200)
    createBlipAttachedTo(markers.carShopMarker3,55,2,0,255,0,0,0,200)
    createBlipAttachedTo(markers.carShopMarker4,55,2,0,255,0,0,0,200)
    createBlipAttachedTo(markers.carShopMarker5,55,2,0,255,0,0,0,200)
    outputChatBox("#ff0000[Lumia] #ffffffCars are for sale!",root,0,0,0,true)
end)

-- When an element hits a marker above
function markers:enter(source, element, dimension)
    if (source == self.carShopMarker) or (source == self.carShopMarker2) or (source == self.carShopMarker3) or (source == self.carShopMarker4) or (source == markers.carShopMarker5) then
        triggerClientEvent ("shop:open", element)
    end
end
addEventHandler("onMarkerHit", getRootElement(),
function(element, dimension)
    markers:enter(source, element, dimension)
end)

function markers:leave(source, element, dimension)
     if (source == self.carShopMarker) or (source == self.carShopMarker2) or (source == self.carShopMarker3) or (source == self.carShopMarker4) or (source == markers.carShopMarker5) then
         triggerClientEvent ("shop:close", element)
     end
end
addEventHandler("onMarkerLeave", getRootElement(),
function(element, dimension)
    markers:leave(source, element, dimension)
end)
--[[
    SQL
--]]
sql =
{
        query = executeSQLQuery,
    --    exec = dbExec,
    --    poll = dbPoll,
    --    connect = dbConnect,
    --    free = dbFree,
    --    connection = nil,
}
sql._index = sql

--[[
    Connect to the database when resource has started.
--]]

-- Initialize database if none exists
function sql:createDatabase()
    local qh = self.query([[CREATE TABLE IF NOT EXISTS `vehiclesystem`
                          (`account` VARCHAR, `id` INT, `vehicle` TEXT, `state` INT, PRIMARY KEY (`vehicle`, `id`)) ]])
    if qh == nil then
        outputDebugString("Database error, qh has returned nil.")
    end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
function()
    sql.connection = database
    sql:createDatabase()
end)

-- execute query
function sql:execQuery(text, ...)
    local qh = self.query(text,...)
    if qh == nil then
        error("sql:execQuery")
    else
        return true
    end
end

function sql:deleteCar(accountName, vehicleName)
    if accountName then
        if #vehicleName > 0 then
            local qh = self.query("DELETE FROM vehiclesystem WHERE account =? AND vehicle =?", accountName, vehicleName)
            if qh == nil then
                error("nil")
            elseif qh == false then
                error("false")
            else
                outputDebugString("Removed from db")
                return true
            end
        end

    end
end

function sql:getData(playerName)
    local qh = self.query("SELECT id, vehicle, state FROM vehiclesystem WHERE account =?", playerName)
    if not (qh == nil or false) then
        return qh
    else
        return false
    end
end


function sql:passData(thePlayer, id, state, vehicle)
    if thePlayer then
       local account = getPlayerAccount(thePlayer)
       local accountName = getAccountName(account)
        if id >= 400 and id <= 611 then
            if #vehicle > 0 then
                if state > 0 then
                    local qh = self.query( [[INSERT INTO `vehiclesystem`
                                                            (`account`, `id`, `vehicle`, `state`) VALUES(?,?,?,?)]],accountName,id, vehicle,state )
                    if qh == false then
                        return false
                    else
                        return true
                    end
                end
            end
        end
    end
end

function sql:update(accountName, vehicleName, state, id)
    if #accountName >0 and #vehicleName > 0 then
        local qh = self.query("UPDATE vehiclesystem SET state =? WHERE vehicle =? AND id =? AND account =?", state, vehicleName, id ,accountName)
        if (qh == nil or false )then
            return false
        else
            outputDebugString("Updated database")
            return true
        end
    end
end


--[[
Gridlist methods
--]]

gridlist = {}
gridlist._index = gridlist

-- Takes table from MySQL database
function gridlist:update(source)
    if isElement(source) then
        local account = getPlayerAccount(source)
        if not account == false or nil then
            local accountName = getAccountName(account)
            if not accountName == false or nil then
            --    outputChatBox(tostring(accountName))
                accountName = tostring(accountName)
                if #accountName > 0 then
                    local data = sql:getData(accountName)
                    if data == nil then
                        error("data == nil")
                    else
                        if #data > 0 then
                            for i = 1, #data do
                                triggerClientEvent("spawner:updateList", source, data[i]['vehicle'], data[i]['id'])
                            end
                            triggerClientEvent("spawner:resetRow", source)  -- Reset row number, so reupdating is possible.
                        else
                            for i = 1, 100 do
                                triggerClientEvent("spawner:deleteList", source)
                            end
                            triggerClientEvent("spawner:resetRow", source)
                        end
                    end
                end
            end
        else
            outputDebugString(tostring(account))
        end
    end
end
-- Add as an event
addEvent("gridlist:update",true)
addEventHandler("gridlist:update", getRootElement(),
function()
    gridlist:update(source)
end)

--[[
--  SHOP
--]]

shop = {}
shop._index = shop

-- Buy from shop
function shop:buy(source, id, name, cost)
    local money = getPlayerMoney(source)
    if money >= tonumber(cost) then
        local account = getPlayerAccount(source)
        local accountName = getAccountName(account)
        local veh = sql:getData(accountName)
        local vehid = 0
        if not (veh == nil)  then
            for i = 1, #veh do
                vehid = veh[i]['id']
                if vehid == id then
                    outputChatBox("You've already got that vehicle!",source,255,0,0)
                    vehid = false
                    break
                end
            end
            if not(vehid == false) then
                takePlayerMoney (source, tonumber (cost))
                outputChatBox ("Bought a " .. name, source, 255, 0, 0, false)
                outputChatBox ("ID: " .. id, source, 255, 0, 0, false)
                outputChatBox ("Cost: " .. cost, source, 255, 0, 0, false)
                local pass = sql:passData(source, id, 1000, name)
                if pass then
                    return true
                end
                return false
            end
        end
    else
        outputChatBox("#ff0000[Lumia] #ffffffYou don't have enough money!", source,0,0,0,true)
    end
end

addEvent("shop:buy", true)
addEventHandler("shop:buy", getRootElement(),
function(id, name, cost)
    shop:buy(source, id, name, cost)
end)

--DELETE FROM `db51`.`text` WHERE `text`.`vehicle` = \'Infernus\' AND
-- `text`.`id` = 511 AND `text`.`account` = \'Pilot\' LIMIT 1
function shop:sell(source, state, id, name, cost)
    local account = getPlayerAccount(source)
    local accountName = getAccountName(account)
    if state >= 500 then
        local transaction = givePlayerMoney(source, cost)
        outputChatBox ("Sold a " .. name, source, 255, 0, 0, false)
        outputChatBox ("ID: " .. id, source, 255, 0, 0, false)
        outputChatBox ("Sold for: " .. cost, source, 255, 0, 0, false)
        sql:query("DELETE FROM `vehiclesystem` WHERE `account` = ? AND `id` = ? AND `vehicle` = ? AND `state` = ?", accountName, id, name, state )
    end
end

addEvent("shop:sell", true)
addEventHandler("shop:sell", getRootElement(),
function(state, id, name, cost)
    shop:sell(source, state,id,name,cost)
end)

car = {}
car._index = car

--[[
       0: Front-left panel
    1: Front-right panel
    2: Rear-left panel
    3: Rear-right panel
    4: Windscreen
    5: Front bumper
    6: Rear bumper
-- ]]
-- Spawn the car
function car:spawn(source)
    local car = getElementData(source, "currentCar")     -- Contains vehicle ID, from gridlist
    local carName = getVehicleNameFromModel(car)
    local carId = getVehicleModelFromName(carName)
    local carID = 0
    if not (isGuestAccount (getPlayerAccount (source))) and not (isPedInVehicle(source)) then
        if not isElement(getElementByID(getPlayerName(source))) then
            local x,y,z = getElementPosition(source)
            local carElement = createVehicle(tonumber(car), x+5,y,z)
            setElementID(carElement, getPlayerName(source)) -- Give the car an ID, to make it unique
            setVehicleDamageProof(carElement,true)
            setVehicleLocked(carElement,true)
            local account = getPlayerAccount(source)
            local accountName = getAccountName(account)
            local data = sql:getData(accountName)
            if #data > 0 then
                for i = 1, #data do
                    carID = data[i]['id']
                   --  outputChatBox(carID)
                    if carID == tonumber(car) then
                        local damage = data[i]['state']
                        outputChatBox(damage)

                        if damage <= 500 then
                            setVehiclePanelState ( carElement, 0, 3)
                            setVehiclePanelState ( carElement, 1, 3)
                            setVehiclePanelState ( carElement, 2, 3)
                            setVehiclePanelState ( carElement, 3, 3)
                            setVehiclePanelState ( carElement, 4, 3)
                            setVehiclePanelState ( carElement, 5, 3)
                            setElementHealth(carElement, damage)
                        elseif damage > 700 then
                            setVehiclePanelState ( carElement, 4, 1)
                            setElementHealth(carElement, damage)
                        end
                    end
                end
            else
                outputDebugString(error())
            end
        else
            outputChatBox("#ff0000[Lumia] #ffffffPlease unspawn the current car first.", source, 0,0,0,true)
        end
    end
        return
end

addEvent("car:spawn", true)
addEventHandler("car:spawn", getRootElement(),
function()
    car:spawn(source)
end)

function car:destroy(thePlayer, id, vehicleName)
    if thePlayer then
        local account = getPlayerAccount(thePlayer)
        local accountName = getAccountName(account)
        if accountName then
            if #vehicleName > 0 then
                sql:deleteCar(accountName, vehicleName)
            end
        end
    end
end
addEvent("car:destroy",true)
addEventHandler("car:destroy", getRootElement(),
function(id, vehicleName)
    car:destroy(source, id, vehicleName)
end)

function car:unspawn(source)
    local car = getElementByID(getPlayerName(source))
    local data = getElementData(source, 'currentCar')
    local account = getPlayerAccount(source)
    local accountName = getAccountName(account)
    local carName = getVehicleNameFromModel(data)
    local carId = getVehicleModelFromName(carName)
    if isElement(car) or data == carId then
        local health = getElementHealth(car)
        local name = getVehicleName(car)
        local id = getVehicleModelFromName(name)
        destroyElement(car)
        removeElementData(source, 'currentCar')
        sql:update(accountName, name, tonumber(health), id )
    else
        outputChatBox("No cars are spawned", source, 255,0,0)
    end
end
addEvent("car:unspawn", true)
addEventHandler("car:unspawn", getRootElement(),
function()
    car:unspawn(source)
end)


function car:explode(source)
    local car = source
    local player = getPlayerFromName(getElementID(car))
    if isElement(player) then
        local account = getPlayerAccount(player)
        local accountName = getAccountName(account)
        sql:deleteCar(accountName, getVehicleName(car))
        removeElementData(player, 'currentCar')
    end
        return
end

addEventHandler("onVehicleExplode", getRootElement(),
function()
    car:explode(source)
end
)


function car:enter(enteringPlayer, seat, jacked, door, source)
    local owner = getPlayerFromName(getElementID(source))
    local dataid = getElementData(enteringPlayer, 'currentCar')
    local carid = getElementModel(source)
    if door == 0 or 1 then
        if owner == enteringPlayer then
            if isVehicleLocked(source) then
                setVehicleLocked(source,false)
                if isVehicleDamageProof(source) then
                    setVehicleDamageProof(source, false)
                end
            end
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(),
function(enteringPlayer, seat, jacked, door)
    car:enter(enteringPlayer,seat,jacked,door,source)
end)