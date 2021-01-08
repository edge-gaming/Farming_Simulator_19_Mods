--
-- Author: Martin Fabik (aka LoogleCZ)
--
-- version ID   - 1.0
-- version date - 13.3.2016 (12:45)
-- 
-- Free for non-comerecial usage
--
--[[
]]--

noSmokeNoFun = {};


function noSmokeNoFun.prerequisitesPresent(specializations)
    return true;
end;

function noSmokeNoFun:load(savegame)
  self.LSF = {};
  self.LSF.emittTime = 0;
  self.LSF.threshingStartPS = {};
  noSmokeNoFun.LSF = self.LSF;
  noSmokeNoFun.LSF.emittTime = self.LSF.emittTime;
  noSmokeNoFun.LSF.threshingStartPS = self.LSF.threshingStartPS;
  
  
    Utils.loadParticleSystem(self.xmlFile, self.LSF.threshingStartPS, "vehicle.threshingStartParticleSystem", self.components, false, nil, self.baseDirectory);
    self.LSF.allowedEmittTime = Utils.getNoNil(getXMLFloat(self.xmlFile, "vehicle.threshingStartParticleSystem#startOffset"),0.1)*1000;

end;

function noSmokeNoFun:delete()
    Utils.deleteParticleSystem(self.LSF.threshingStartPS);
end;

function noSmokeNoFun:writeStream(streamId, connection)
end;

function noSmokeNoFun:readStream(streamId, connection)
end;

function noSmokeNoFun:mouseEvent(posX, posY, isDown, isUp, button)
end;

function noSmokeNoFun:keyEvent(unicode, sym, modifier, isDown)
end;

function noSmokeNoFun:update(dt)
end;

function noSmokeNoFun:updateTick(dt)
    if self:getIsActive() then
        if self.isClient then
            if self.LSF.emitting then
                if self.LSF.emittTime >= self.LSF.allowedEmittTime then
                    Utils.setEmittingState(self.LSF.threshingStartPS, false);
                    self.LSF.emittTime = 0;
                else
                    self.LSF.emittTime = self.LSF.emittTime + dt;
                end;
            end;
        end;
    end;
end;

function noSmokeNoFun:startMotor()
    if self:getIsActive() then
        if self.isClient then
            Utils.setEmittingState(self.LSF.threshingStartPS, true);
            self.LSF.emitting = true;
        end;
    end;
end;

function noSmokeNoFun:onTurnedOn()
    if self:getIsActive() then
        if self.isClient then
            Utils.setEmittingState(noSmokeNoFun.LSF.threshingStartPS, true);
            noSmokeNoFun.LSF.emitting = true;
        end;
    end;
end;

function noSmokeNoFun:draw()
end;

function noSmokeNoFun:onAttachImplement(implement)
    if SpecializationUtil.hasSpecialization(Mower, implement.object.specializations) then
        Mower.onTurnedOn = Utils.overwrittenFunction(Mower.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(Baler, implement.object.specializations) then
        Baler.onTurnedOn = Utils.overwrittenFunction(Baler.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(Cultivator, implement.object.specializations) then
        Cultivator.onAiTurnOn = Utils.overwrittenFunction(Cultivator.onAiTurnOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(MixerWagon, implement.object.specializations) then
        MixerWagon.onTurnedOn = Utils.overwrittenFunction(MixerWagon.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end; 
  
    if SpecializationUtil.hasSpecialization(RotorSpreader, implement.object.specializations) then
        RotorSpreader.onTurnedOn = Utils.overwrittenFunction(RotorSpreader.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(SowingMachine, implement.object.specializations) then
        SowingMachine.onTurnedOn = Utils.overwrittenFunction(SowingMachine.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(Sprayer, implement.object.specializations) then
        Sprayer.onTurnedOn = Utils.overwrittenFunction(Sprayer.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(StumpCutter, implement.object.specializations) then
        StumpCutter.onTurnedOn = Utils.overwrittenFunction(StumpCutter.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
  
    if SpecializationUtil.hasSpecialization(Cultivator, implement.object.specializations) then
      Cultivator.onTurnedOn = Utils.overwrittenFunction(Cultivator.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end; 

    if SpecializationUtil.hasSpecialization(Windrower, implement.object.specializations) then
        Windrower.onTurnedOn = Utils.overwrittenFunction(Windrower.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end; 
    
    if SpecializationUtil.hasSpecialization(Tedder, implement.object.specializations) then
        Tedder.onTurnedOn = Utils.overwrittenFunction(Tedder.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end; 

    if SpecializationUtil.hasSpecialization(ForageWagon, implement.object.specializations) then
        ForageWagon.onTurnedOn = Utils.overwrittenFunction(ForageWagon.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;

    if SpecializationUtil.hasSpecialization(ManureBarrel, implement.object.specializations) then
        ManureBarrel.onTurnedOn = Utils.overwrittenFunction(ManureBarrel.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
    
    if SpecializationUtil.hasSpecialization(ManureSpreader, implement.object.specializations) then
        ManureSpreader.onTurnedOn = Utils.overwrittenFunction(ManureSpreader.onTurnedOn, noSmokeNoFun.onTurnedOn);
    end;
    
end;