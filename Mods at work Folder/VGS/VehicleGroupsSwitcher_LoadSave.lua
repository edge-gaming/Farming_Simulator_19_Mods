
VehicleGroupsSwitcher_LoadSave = {};

function VehicleGroupsSwitcher_LoadSave.prerequisitesPresent(specializations)
    return true;
end

function VehicleGroupsSwitcher_LoadSave:load(savegame) end
function VehicleGroupsSwitcher_LoadSave:delete() end
function VehicleGroupsSwitcher_LoadSave:mouseEvent(posX, posY, isDown, isUp, button) end
function VehicleGroupsSwitcher_LoadSave:keyEvent(unicode, sym, modifier, isDown) end
function VehicleGroupsSwitcher_LoadSave:update(dt) end
function VehicleGroupsSwitcher_LoadSave:updateTick(dt) end
function VehicleGroupsSwitcher_LoadSave:draw() end


function VehicleGroupsSwitcher_LoadSave:postLoad(savegame)
    self.modVeGS = self.modVeGS or {}
    self.modVeGS.group = 0
    self.modVeGS.pos = 0

    if savegame ~= nil
    --and not savegame.resetVehicles
    and g_server ~= nil
    then
        local key = savegame.key .. '.vehicleGroupsSwitcher'
        local grp = getXMLInt(savegame.xmlFile, key..'#grp')
        if grp ~= nil and grp >= 1 and grp <= 10 then
            self.modVeGS.group = grp

            local pos = getXMLInt(savegame.xmlFile, key..'#pos')
            if pos ~= nil and pos >= 0 then
                self.modVeGS.pos = pos
            end

            local grpName = getXMLString(savegame.xmlFile, key..'#grpName')
            if grpName ~= nil then
                VehicleGroupsSwitcher.setGroupName(grp, grpName)
            end
        end
    end;

    --    
    local storeItem = StoreItemsUtil.storeItemsByXMLFilename[self.configFileName:lower()];
    if storeItem ~= nil and storeItem.name ~= nil then
        local brand = ""
        if storeItem.brand ~= nil and storeItem.brand ~= "" then
            brand = tostring(storeItem.brand) .. " " 
        end
        self.modVeGS = Utils.getNoNil(self.modVeGS, {group=0,pos=0})
        self.modVeGS.vehicleName = brand .. tostring(storeItem.name);
    end

    if self.isServer then
        -- Due to FS17's vehicle customizations, the server must resend VeGS data...
        VehicleGroupsSwitcher.dirtyTimeout = g_currentMission.time + 2000; -- broadcast update, after 2 seconds have passed from now
    end
end;

function VehicleGroupsSwitcher_LoadSave:getSaveAttributesAndNodes(nodeIdent)
    local attributes,nodes;

    if self.modVeGS ~= nil and self.modVeGS.group ~= nil and self.modVeGS.group > 0 then
        nodes = nodeIdent .. string.format('<vehicleGroupsSwitcher grp="%d" pos="%d" grpName="%s" />'
            ,self.modVeGS.group
            ,self.modVeGS.pos
            ,VehicleGroupsSwitcher.getGroupName(self.modVeGS.group)
        )
    end;

    return attributes, nodes;
end;
