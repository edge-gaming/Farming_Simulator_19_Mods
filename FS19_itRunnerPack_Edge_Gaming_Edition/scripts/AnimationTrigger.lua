--
-- AnimationTrigger
--
-- written by fruktor, visit: www.eifok-team.de
-- 18-1-2017 Rename and edit by JD7530-Chris

WarningSigns = {};

WarningSigns.modDir = g_currentModDirectory;

function WarningSigns.prerequisitesPresent(specializations)
    return true; 
end;

function WarningSigns:load(savegame)
    
    self.playerCallback = SpecializationUtil.callSpecializationsFunction("playerCallback"); 
    self.setSign = SpecializationUtil.callSpecializationsFunction("setSign"); 
    
    self.ws = {};
    
    local i=0;
    while true do
        local str = getXMLString(self.xmlFile, string.format("vehicle.warningSigns.sign(%d)#index", i));
        if str == nil then
            break;
        end;
        local node = Utils.indexToObject(self.components, str);
        if node == nil then
            print("[Error::WarningSigns] node for "..tostring(str).." does not exist");
            break;
        end;
        local trigger = Utils.indexToObject( self.components, getXMLString(self.xmlFile, string.format("vehicle.warningSigns.sign(%d)#trigger", i)) );
        if trigger == nil then
            print("[Error::WarningSigns] node is OK, but trigger could not be located. Check line "..tostring(i+1).." in your vehicle.xml");
        end;
        local isVis = getXMLBool(self.xmlFile, string.format("vehicle.warningSigns.sign(%d)#isVisible", i))
        self.ws[i+1] = {};
        self.ws[i+1].node = node;
        self.ws[i+1].trigger = trigger;
        self.ws[i+1].isVis = isVis;
        self.ws[i+1].plIR = false;
        
        addTrigger( trigger, "playerCallback", self );                
        i = i + 1;
    end;
    
end;

function WarningSigns:delete()
    for i,j in pairs(self.ws) do
        if j.trigger ~= nil then
            removeTrigger(j.trigger);
        end;
    end;
end;

function WarningSigns:readStream(streamId, connection)
    for i,j in pairs(self.ws) do
        local state = streamReadBool(streamId);
        self:setSign(i, state, true);
    end;
end;

function WarningSigns:writeStream(streamId, connection)
    for i,j in pairs(self.ws) do
        streamWriteBool(streamId, j.isVis);
    end;
end;


function WarningSigns:getSaveAttributesAndNodes(nodeIdent)    
    local attributes = '';
    for i,j in pairs(self.ws) do
        attributes = attributes .. string.format('warningSign%d="%s" ', i, tostring(j.isVis));
    end;
    return attributes, nil;
end;

function WarningSigns:mouseEvent(posX, posY, isDown, isUp, button)
end;

function WarningSigns:keyEvent(unicode, sym, modifier, isDown)
end;

function WarningSigns:update(dt)
    local plIR = false;
    local id = 0;
    for i,j in pairs(self.ws) do
        if j.plIR then
            id = i;
            plIR = true;
            break;
        end;
    end;
    
    if plIR then
        g_currentMission:addHelpButtonText( g_i18n:getText("function_light"), InputBinding.function_light );    
        --renderText( g_currentMission.hudAttachmentOverlay.x-0.01, g_currentMission.hudAttachmentOverlay.y, 0.02, g_i18n:getText("SHOW_WARNING_SIGN") );
        setTextColor(1.0, 1.0, 1.0, 1.0);
        setTextAlignment(RenderText.ALIGN_LEFT);         
        renderText(0.5, 0.09, 0.02, g_i18n:getText("function_light") );
        if InputBinding.hasEvent(InputBinding.function_light)then
            self:setSign(id, not self.ws[id].isVis);
        end
    end;
end;

function WarningSigns:onLeave()
end;

function WarningSigns:draw()
end;

function WarningSigns:playerCallback(triggerId, otherId, onEnter, onLeave, onStay)
--print("function WarningSigns:playerCallback("..tostring(triggerId)..", "..tostring(otherId)..", "..tostring(onEnter)..", "..tostring(onLeave)..", "..tostring(onStay));
    
    local id = 0;
    for i,j in pairs(self.ws) do
        if j.trigger == triggerId then
            id = i;
            break;
        end;
    end;
    
    if id ~= 0 then
        if onEnter and g_currentMission.controlPlayer and g_currentMission.player ~= nil and otherId == g_currentMission.player.rootNode then
            self.ws[id].plIR = true;
        elseif onLeave then
            self.ws[id].plIR = false;
        end;
    end
    
end;


function WarningSigns:setSign(id, state, noEventSend)
--print("function WarningSigns:setSign("..tostring(id)..", "..tostring(state)..", "..tostring(noEventSend));
    SetSignEvent.sendEvent(self, id, state, noEventSend);
    self.ws[id].isVis = state;
    setVisibility(self.ws[id].node, state);
end;




--
--
--
--
--
SetSignEvent = {};
SetSignEvent_mt = Class(SetSignEvent, Event);

InitEventClass(SetSignEvent, "SetSignEvent");

function SetSignEvent:emptyNew()
    local self = Event:new(SetSignEvent_mt);
    self.className="SetSignEvent";
    return self;
end;

function SetSignEvent:new(object, id, state)
    local self = SetSignEvent:emptyNew()
    self.object = object;
    self.id = id;
    self.state = state;
    return self;
end;

function SetSignEvent:readStream(streamId, connection)
    local id = streamReadInt32(streamId);
    self.object = networkGetObject(id);
    self.id = streamReadInt32(streamId);
    self.state = streamReadBool(streamId);
    self:run(connection);
end;

function SetSignEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, networkGetObjectId(self.object));
    streamWriteInt32(streamId, self.id);
    streamWriteBool(streamId, self.state);
end;

function SetSignEvent:run(connection)
    self.object:setSign(self.id, self.state, true);
    if not connection:getIsServer() then
        g_server:broadcastEvent(SetSignEvent:new(self.object, self.id, self.state), nil, connection, self.object);
    end;
end;

function SetSignEvent.sendEvent(vehicle, id, state, noEventSend)
    if noEventSend == nil or noEventSend == false then
        if g_server ~= nil then
            g_server:broadcastEvent(SetSignEvent:new(vehicle, id, state), nil, nil, vehicle);
        else
            g_client:getServerConnection():sendEvent(SetSignEvent:new(vehicle, id, state));
        end;
    end;
end;

