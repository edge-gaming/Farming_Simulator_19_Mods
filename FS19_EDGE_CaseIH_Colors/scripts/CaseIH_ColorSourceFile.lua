--
-- CaseIH_ColorSourceFile
-- Basic for CaseIH_Color
--
-- @author EDGE Gaming
-- @date 04/04/2019
-- @version 1.0.0

CaseIH_ColorSourceFile = {}; 
CaseIH_ColorSourceFile.modDir = g_currentModDirectory;
 
if g_configurationManager.configurationNameToInt["CaseIH_Color"] == nil then
	g_configurationManager:addConfigurationType("CaseIH_Color", g_i18n:getText("configuration_CaseIH_Color"), nil, nil, nil, ConfigurationManager.SELECTOR_MULTIOPTION);
end;

function addCaseIH_ColorConfiguration(xmlFile, superFunc, baseXMLName, baseDir, customEnvironment, isMod, storeItem)
	local configurations = superFunc(xmlFile, baseXMLName, baseDir, customEnvironment, isMod, storeItem)

	local CaseIH_ColorKey = nil;
	if hasXMLProperty(xmlFile, "vehicle.CaseIH_Color") then
		CaseIH_ColorKey = "vehicle.CaseIH_Color";
	end;
	
	if CaseIH_ColorKey ~= nil then
		--load from vehicle.xml
		configurations["CaseIH_Color"] = {};
		local numConfigs = Utils.getNoNil(getXMLInt(xmlFile, CaseIH_ColorKey..".CaseIH_ColorConfigurations#numConfigs"), 0);
		for p = 0, numConfigs-1 do
			local key3 = string.format(CaseIH_ColorKey..".CaseIH_ColorConfigurations.CaseIH_ColorConfiguration(%d)", p);
			if not hasXMLProperty(xmlFile, key3) then
				break;
			end;			
			
			local name = g_i18n:getText(getXMLString(xmlFile, key3.."#name"));
			local price = Utils.getNoNil(getXMLFloat(xmlFile, key3.."#price"), 0.0);
			local dailyUpkeep = Utils.getNoNil(getXMLInt(xmlFile, key3.."#dailyUpkeep"), 0);					
			local configurationItem = StoreItemUtil.addConfigurationItem(configurations["CaseIH_Color"], name, "CaseIH_Color", price, dailyUpkeep, (p == 0));
			p = p+1;
		end;
	else
		--load from config.xml
		local CaseIH_ColorConfigFilename = Utils.getFilename("CaseIH_ColorConfigFile.xml", CaseIH_Color.modDir);
		local xmlFile = loadXMLFile("CaseIH_ColorConfigFilename", CaseIH_ColorConfigFilename);
		
		if xmlFile ~= nil and xmlFile ~= 0 then
			local i=0;
			while true do
				local baseName = string.format("xmlConfigData.vehicles.vehicle(%d)", i);
				if not hasXMLProperty(xmlFile, baseName) then
					break;
				end;
				local vehicleFilename = getXMLString(xmlFile, baseName .. "#vehicleFilename")
				if StringUtil.startsWith(vehicleFilename, "$moddir$") then
					local splitStrings = StringUtil.splitString("dir$", vehicleFilename)
					vehicleFilename = g_modsDirectory..splitStrings[2];
				end;
				if storeItem.xmlFilename == vehicleFilename then
					configurations["CaseIH_Color"] = {};
					
					local numConfigs = Utils.getNoNil(getXMLInt(xmlFile, baseName..".CaseIH_ColorConfigurations#numConfigs"), 0);
					for p = 0, numConfigs-1 do
						local key3 = string.format(baseName..".CaseIH_ColorConfigurations.CaseIH_ColorConfiguration(%d)", p);
						if not hasXMLProperty(xmlFile, key3) then
							break;
						end;			
						
						local name = g_i18n:getText(getXMLString(xmlFile, key3.."#name"));
						local price = Utils.getNoNil(getXMLFloat(xmlFile, key3.."#price"), 0.0);
						local dailyUpkeep = Utils.getNoNil(getXMLInt(xmlFile, key3.."#dailyUpkeep"), 0);					
						local configurationItem = StoreItemUtil.addConfigurationItem(configurations["CaseIH_Color"], name, "CaseIH_Color", price, dailyUpkeep, (p == 0));
						p = p+1;
					end;
					break;
				end;
				i = i + 1;
			end;
			delete(xmlFile);
		end;
	end;
	return configurations;
end;

StoreItemUtil.getConfigurationsFromXML = Utils.overwrittenFunction(StoreItemUtil.getConfigurationsFromXML, addCaseIH_ColorConfiguration);

