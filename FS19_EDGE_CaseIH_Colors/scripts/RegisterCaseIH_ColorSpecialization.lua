--
-- RegisterCaseIH_ColorSpecialization
-- register the CaseIH_Color specialization
--
-- @author EDGE Gaming
-- @date 23/01/2019
--

RegisterCaseIH_ColorSpecialization = {};
RegisterCaseIH_ColorSpecialization.modDir = g_currentModDirectory;
RegisterCaseIH_ColorSpecialization.register = false;
RegisterCaseIH_ColorSpecialization.requiredSpecializations = {Drivable, Lights, AttacherJoints};



function RegisterCaseIH_ColorSpecialization:addSpecializationToVehicleTypes(name, requiredSpecializations)
	for vehicleType, vehicle in pairs(g_vehicleTypeManager.vehicleTypes) do
		if vehicle ~= nil then
			local allowInsertion = true;			
			for _, rqspec in pairs(requiredSpecializations) do
				allowInsertion = SpecializationUtil.hasSpecialization(rqspec, vehicle.specializations);
				if not allowInsertion then
					break;
				end;
			end;
			
			if allowInsertion then
				local spec = g_specializationManager:getSpecializationObjectByName(name);				
				vehicle.specializationsByName[name] = spec;
				table.insert(vehicle.specializationNames, name);
				table.insert(vehicle.specializations, spec);
			end;
		end;
	end;
end;

if RegisterCaseIH_ColorSpecialization.register == false then
	if g_specializationManager:getSpecializationByName("CaseIH_Color") == nil then
		local filename = Utils.getFilename("scripts/CaseIH_Color.lua", RegisterCaseIH_ColorSpecialization.modDir);
		RegisterCaseIH_ColorSpecialization.register = g_specializationManager:addSpecialization("CaseIH_Color", "CaseIH_Color", filename, true, nil);
		
		RegisterCaseIH_ColorSpecialization:addSpecializationToVehicleTypes("CaseIH_Color", RegisterCaseIH_ColorSpecialization.requiredSpecializations);
	end;
end;

