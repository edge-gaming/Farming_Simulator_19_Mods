--
-- Vehicle-groups Switcher (VeGS)
--
-- @author  Decker_MMIV - fs-uk.com, forum.farming-simulator.com, modhoster.com
-- @date    2016-11-xx
--

RegistrationHelper_VeGS = {};
RegistrationHelper_VeGS.isLoaded = false;

if SpecializationUtil.specializations['VehicleGroupsSwitcher_LoadSave'] == nil then
    SpecializationUtil.registerSpecialization('VehicleGroupsSwitcher_LoadSave', 'VehicleGroupsSwitcher_LoadSave', g_currentModDirectory .. 'VehicleGroupsSwitcher_LoadSave.lua')
    RegistrationHelper_VeGS.isLoaded = false;
end

function RegistrationHelper_VeGS:loadMap(name)
    if not g_currentMission.RegistrationHelper_VeGS_isLoaded then
        if not RegistrationHelper_VeGS.isLoaded then
            self:register();
        end
        g_currentMission.RegistrationHelper_VeGS_isLoaded = true
    else
        print("Error: VehicleGroupsSwitcher_LoadSave has been loaded already!");
    end
end

function RegistrationHelper_VeGS:deleteMap()
    g_currentMission.RegistrationHelper_VeGS_isLoaded = nil
end

function RegistrationHelper_VeGS:keyEvent(unicode, sym, modifier, isDown)
end

function RegistrationHelper_VeGS:mouseEvent(posX, posY, isDown, isUp, button)
end

function RegistrationHelper_VeGS:update(dt)
end

function RegistrationHelper_VeGS:draw()
end

function RegistrationHelper_VeGS:register()
    for _, vehicle in pairs(VehicleTypeUtil.vehicleTypes) do
        if vehicle ~= nil and SpecializationUtil.hasSpecialization(Drivable, vehicle.specializations) then
            table.insert(vehicle.specializations, SpecializationUtil.getSpecialization("VehicleGroupsSwitcher_LoadSave"))
        end
    end
    RegistrationHelper_VeGS.isLoaded = true
end

--
RailroadVehicle.getSaveAttributesAndNodes = Utils.overwrittenFunction(RailroadVehicle.getSaveAttributesAndNodes,
    function(self, superFunc, nodeIdent)
        local attributes,nodes = superFunc(self,nodeIdent);

        if self.modVeGS ~= nil and self.modVeGS.group ~= nil and self.modVeGS.group > 0 then
            if nil == nodes then
                nodes = ""
            else
                nodes = nodes .. '\n'
            end
            nodes = nodes .. nodeIdent .. string.format('    <vehicleGroupsSwitcher grp="%d" pos="%d" grpName="%s" />'
                ,self.modVeGS.group
                ,self.modVeGS.pos
                ,VehicleGroupsSwitcher.getGroupName(self.modVeGS.group)
            )
        end;

        return attributes, nodes;
    end
);

RailroadVehicle.load = Utils.overwrittenFunction(RailroadVehicle.load,
    function(self, superFunc, savegame, p2, p3)
        local res = { superFunc(self, savegame, p2, p3) }

        if savegame ~= nil
        --and not savegame.resetVehicles
        and g_server ~= nil
        then
            local key = savegame.key .. '.vehicleGroupsSwitcher'
            local grp = getXMLInt(savegame.xmlFile, key..'#grp')
            if grp ~= nil and grp >= 1 and grp <= 10 then
                self.modVeGS = self.modVeGS or {}
                self.modVeGS.group = grp
                self.modVeGS.pos = 0

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
        
        return unpack(res)
    end
)

--
addModEventListener(RegistrationHelper_VeGS)