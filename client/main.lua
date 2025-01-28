ESX = nil
TOKEN = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

CreateThread(function ()
    Wait(1000)
    TriggerServerEvent(GetCurrentResourceName()..":getToken")
end)

RegisterNetEvent(GetCurrentResourceName()..":getToken", function (tkn)
    TOKEN = tkn
end)

RegisterNetEvent(GetCurrentResourceName()..":spawn", function (model, plate)
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle)
		if DoesEntityExist(vehicle) then
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = plate
			TriggerServerEvent(GetCurrentResourceName()..":set", vehicleProps, TOKEN)
			ESX.Game.DeleteVehicle(vehicle)
			ESX.ShowNotification('info', 'U hebt een voertuig ontvangen met het model ' .. model, 5000)
		end		
	end)
end)