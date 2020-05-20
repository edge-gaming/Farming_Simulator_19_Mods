--
-- CaseIH_Color
-- Specialization for installation of the CaseIH_Color
--
-- @author EDGE Gaming
-- @date 05/02/2019
--
CaseIH_Color = {};
CaseIH_Color.modDir = g_currentModDirectory;

function CaseIH_Color.prerequisitesPresent(specializations)	
	return SpecializationUtil.hasSpecialization(Drivable, specializations) and SpecializationUtil.hasSpecialization(Lights, specializations) and SpecializationUtil.hasSpecialization(AttacherJoints, specializations);
end;

function CaseIH_Color.registerEventListeners(vehicleType)
	SpecializationUtil.registerEventListener(vehicleType, "onLoad", CaseIH_Color);
end;

function CaseIH_Color.registerFunctions(vehicleType)
	SpecializationUtil.registerFunction(vehicleType, "onLoadCaseIH_ColorFromXMLFile", CaseIH_Color.onLoadCaseIH_ColorFromXMLFile);
end;

function CaseIH_Color:onLoad(savegame)	
	self.spec_CaseIH_Color = {};
	local spec = self.spec_CaseIH_Color;
	
	local CaseIH_ColorId = self.configurations["CaseIH_Color"];		
	spec.CaseIH_Color = {}
	
	local CaseIH_ColorKey = nil;
	if hasXMLProperty(self.xmlFile, "vehicle.CaseIH_Color") then
		CaseIH_ColorKey = "vehicle.CaseIH_Color";
	end;
	
	if CaseIH_ColorKey ~= nil then
		--load from vehicle.xml
		spec.CaseIH_Color = self:onLoadCaseIH_ColorFromXMLFile(self.xmlFile, CaseIH_ColorKey, CaseIH_ColorId, self);
		ObjectChangeUtil.updateObjectChanges(self.xmlFile, CaseIH_ColorKey..".CaseIH_ColorConfigurations.CaseIH_ColorConfiguration", CaseIH_ColorId, self.components, self);
	else
		--load from config.xml

		local CaseIH_ColorConfigFilename = Utils.getFilename("CaseIH_ColorConfigFile.xml", CaseIH_Color.modDir);
		local xmlFile = loadXMLFile("CaseIH_ColorConfigFilename", CaseIH_ColorConfigFilename);	
		if xmlFile ~= nil and xmlFile ~= 0 then
			local i=0;
			while true do
				local baseKey = string.format("xmlConfigData.vehicles.vehicle(%d)", i);
				if not hasXMLProperty(xmlFile, baseKey) then
					break;
				end;
				if spec.CaseIH_Color.rootNode ~= nil and spec.CaseIH_Color.rootNode ~= 0 then
					g_logManager:xmlWarning(self.configFileName, "Only one CaseIH_Color per vehicle '%s'", baseKey);
					break;
				end;
				local vehicleFilename = getXMLString(xmlFile, baseKey .. "#vehicleFilename")
				if StringUtil.startsWith(vehicleFilename, "$moddir$") then
					local splitStrings = StringUtil.splitString("dir$", vehicleFilename)
					vehicleFilename = g_modsDirectory..splitStrings[2];
				end;
				if vehicleFilename == self.configFileName then
					spec.CaseIH_Color = self:onLoadCaseIH_ColorFromXMLFile(xmlFile, baseKey, CaseIH_ColorId, self);
					ObjectChangeUtil.updateObjectChanges(xmlFile, baseKey..".CaseIH_ColorConfigurations.CaseIH_ColorConfiguration", CaseIH_ColorId, self.components, self);
					break;
				end;
				i = i + 1;
			end;
			delete(xmlFile)
		end;
	end;
end;

-- object = self
-- baseKey = baseKey

function CaseIH_Color:onLoadCaseIH_ColorFromXMLFile(xmlFile, baseKey, CaseIH_ColorId, object)
	local CaseIH_Color = {};
	local node = I3DUtil.indexToObject(object.components, getXMLString(xmlFile, baseKey..".params#node"), object.i3dMappings)
	if node ~= nil then
		local CaseIH_ColorXmlFilename = getXMLString(xmlFile, baseKey..".params#filename");
		if CaseIH_ColorXmlFilename ~= nil then
			CaseIH_ColorXmlFilename = Utils.getFilename(CaseIH_ColorXmlFilename, CaseIH_Color.modDir)
			local CaseIH_ColorXmlFile = loadXMLFile("CaseIH_ColorXmlFilename", CaseIH_ColorXmlFilename)
			
			if CaseIH_ColorXmlFile ~= nil and CaseIH_ColorXmlFile ~= 0 then
				local i3dFilename = getXMLString(CaseIH_ColorXmlFile, "CaseIH_Color.filename")
				if i3dFilename ~= nil then
					local i3dNode = g_i3DManager:loadSharedI3DFile(i3dFilename, CaseIH_Color.modDir, false, false, false)
					if i3dNode ~= nil and i3dNode ~= 0 then
						local rootNode = I3DUtil.indexToObject(i3dNode, getXMLString(CaseIH_ColorXmlFile, "CaseIH_Color.rootNode#node"))
						if rootNode ~= nil then
							link(node, rootNode);
							
							--i3dMapping
							if object.i3dMappings ~= nil then
								local index = getChildIndex(rootNode);
								local parentIndex = object.i3dMappings[getXMLString(xmlFile, baseKey..".params#node")];
								
								local j = 0;
								while true do
									local key = string.format("CaseIH_Color.i3dMappings.i3dMapping(%d)", j)
									if not hasXMLProperty(CaseIH_ColorXmlFile, key) then
										break;
									end;
									local id = getXMLString(CaseIH_ColorXmlFile, key.."#id");
									local nodeIndex = getXMLString(CaseIH_ColorXmlFile, key.."#node");
									if object.i3dMappings[id] == nil and nodeIndex ~= nil and id ~= nil then
										local idIndex = parentIndex.."|"..nodeIndex;
										idIndex = string.format(idIndex, index);
										object.i3dMappings[id] = idIndex;
									else
										g_logManager:xmlError(CaseIH_ColorXmlFilename, "i3d-Mapping[%s] already exists!", id);
									end;												
									j = j + 1;
								end;
							else
								g_logManager:xmlError(object.configFileName, "i3dMapping doesn't exists");
							end;
							
							--position and rotation
							local x, y, z = StringUtil.getVectorFromString(getXMLString(xmlFile,  baseKey..".params#translation"))
							setTranslation(rootNode, x, y, z);
							local rot = StringUtil.getRadiansFromString(Utils.getNoNil(getXMLString(xmlFile, baseKey..".params#rotation"), "0 0 0"), 3)
							setRotation(rootNode, unpack(rot));
							CaseIH_Color.filename = i3dFilename;
							CaseIH_Color.rootNode = rootNode;
							
							--shader application
							local shaderParameterName = getXMLString(xmlFile, baseKey..".params#shaderParameterName");
							CaseIH_Color.shaderParameterName = shaderParameterName;
							
							local shaderParameter = ConfigurationUtil.getColorFromString(getXMLString(xmlFile, baseKey..".params#shaderParameter"));
							local useBaseMaterial = Utils.getNoNil(getXMLString(xmlFile, baseKey..".params#useBaseMaterial"), false);
							local useDesignMaterial = Utils.getNoNil(getXMLString(xmlFile, baseKey..".params#useDesignMaterial"), false);
							if shaderParameter == nil then
								if useBaseMaterial then
									if object.configurations["baseMaterial"] ~= nil then
										local baseMaterialId = object.configurations["baseMaterial"];
										shaderParameter = ConfigurationUtil.getColorByConfigId(object, "baseMaterial", baseMaterialId);
									else
										g_logManager:xmlError(object.configFileName, "Can't load CaseIH_Color material data, configuration 'baseMaterial' is not valid.");												
									end;
								elseif useDesignMaterial then
								
									if object.configurations["designMaterial"] ~= nil then									
										local designMaterialId = object.configurations["designMaterial"];
										shaderParameter = ConfigurationUtil.getColorByConfigId(object, "designMaterial", designMaterialId);
									else
										g_logManager:xmlError(object.configFileName, "Can't load CaseIH_Color material data, configuration 'designMaterialId' is not valid.");												
									end;
								else
									g_logManager:xmlError(object.configFileName, "Can't load CaseIH_Color material data, selected material is not valid.");
								end;
							end;
							if shaderParameterName ~= nil and shaderParameter ~= nil then
								local x,y,z,w = unpack(shaderParameter);
								w = Utils.getNoNil(w, 1.0);
								CaseIH_Color.shaderParameter = {x, y, z, w};
								setShaderParameter(rootNode, shaderParameterName, x, y, z, w, false);
							end;										
							
							--sharedLights
							local spec_lights = object.spec_lights;		
							if spec_lights ~= nil and spec_lights.sharedLights ~= nil then
								local j = 0;
								while true do
									local key = string.format("CaseIH_Color.lights.sharedLight(%d)", j)
									if not hasXMLProperty(CaseIH_ColorXmlFile, key) then
										break;
									end;
									local sharedLight = {};
									if object:loadSharedLight(CaseIH_ColorXmlFile, key, sharedLight) then
										table.insert(spec_lights.sharedLights, sharedLight)
									end
									j = j + 1;
								end;
							else
								g_logManager:xmlError(object.configFileName, "Can't load CaseIH_Color shared lights, no lights avaiable in mod.");
							end;
							
							--startRotation
							if CaseIH_ColorId ~= 1 then
								local spec_attacherJoints = object.spec_attacherJoints;
								local startRot = StringUtil.getRadiansFromString(getXMLString(xmlFile, baseKey..".attacherJoint#startRotation"), 3);
								local index =  Utils.getNoNil(getXMLInt(xmlFile, baseKey..".attacherJoint#index"), 1);
								local attacherJoint = spec_attacherJoints.attacherJoints[index];
								if attacherJoint ~= nil and attacherJoint.bottomArm ~= nil and startRot ~= nil then											
									attacherJoint.bottomArm.rotX, attacherJoint.bottomArm.rotY, attacherJoint.bottomArm.rotZ = startRot[1],startRot[2],startRot[3];
									setRotation(attacherJoint.bottomArm.rotationNode, attacherJoint.bottomArm.rotX, attacherJoint.bottomArm.rotY, attacherJoint.bottomArm.rotZ)
									if object.setMovingToolDirty ~= nil then
										object:setMovingToolDirty(attacherJoint.bottomArm.rotationNode)
									end
								end;
							end;
						end;
						delete(i3dNode);
					end;
				end;
				delete(CaseIH_ColorXmlFile);
			end;
		end;
	end;
	return CaseIH_Color;
end;