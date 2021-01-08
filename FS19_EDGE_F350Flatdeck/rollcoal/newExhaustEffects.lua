-- by modelleicher
-- www.schwabenmodding.bplaced.net

-- adds additional particle system 
-- particle system emits if the engine load is above a certain threshold (psThreshold value)
-- maxMotorLoad, the max. value motorLoad can reach witch the particular vehicle (use vehicle debug rendering to figure that value out)


newExhaustEffects = {};

function newExhaustEffects.prerequisitesPresent(specializations)
    return true;
end;

function newExhaustEffects:load(savegame)
    self.nrep = {}; -- all variables will be stored in this table to prevent interference with other scripts 
    self.nrep.psThreshold = Utils.getNoNil(getXMLFloat(self.xmlFile, "vehicle.newExhaustEffects#psThreshold"), 0.85);
    
    self.nrep.ps = {};
    local ps = {};
    ParticleUtil.loadParticleSystem(self.xmlFile, ps, "vehicle.newExhaustEffects.particle", self.components, false, nil, self.baseDirectory)
    table.insert(self.nrep.ps, ps)
    ps = {};
    if hasXMLProperty(self.xmlFile, "vehicle.newExhaustEffects.particle2") then
        ParticleUtil.loadParticleSystem(self.xmlFile, ps, "vehicle.newExhaustEffects.particle2", self.components, false, nil, self.baseDirectory)
        table.insert(self.nrep.ps, ps)
    end;
end;


function newExhaustEffects:update(dt)    
    if self.isClient and self:getIsActive() and self.isMotorStarted then        
        local mLoad = self.actualLoadPercentage; --self.motor.motorLoad / self.nrep.maxMotorLoad; -- converting the individual motor load to 0-1 range value     
        if mLoad > self.nrep.psThreshold then 
            for _, ps in pairs(self.nrep.ps) do
                ParticleUtil.setEmittingState(ps, true);
            end
        else
            for _, ps in pairs(self.nrep.ps) do
                ParticleUtil.setEmittingState(ps, false);
            end
        end;
    end;
end;
function newExhaustEffects:delete()
    if self.isClient then
        ParticleUtil.deleteParticleSystems(self.nrep.ps);
    end
end;
function newExhaustEffects:onLeave()
    if self.isClient then
        for _, ps in pairs(self.nrep.ps) do
            ParticleUtil.setEmittingState(ps, false);
        end
    end;
end;
function newExhaustEffects:mouseEvent(posX, posY, isDown, isUp, button)
end;
function newExhaustEffects:keyEvent(unicode, sym, modifier, isDown)
end;
function newExhaustEffects:draw()
end;
