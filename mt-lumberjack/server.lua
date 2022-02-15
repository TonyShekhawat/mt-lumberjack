local QBCore = exports['qb-core']:GetCoreObject()

-- Evento para dar os troncos
RegisterServerEvent("mt-lumberjack:server:DarTroncos")
AddEventHandler("mt-lumberjack:server:DarTroncos", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem("tronco", 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["tronco"], "add")
        TriggerClientEvent('QBCore:Notify', src, 'Cortas-te os Troncos.')
end)
    
-- Evento para processar tronco
RegisterServerEvent("mt-lumberjack:server:DarTabuas")
AddEventHandler("mt-lumberjack:server:DarTabuas", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tronco = Player.Functions.GetItemByName("tronco")
    if tronco ~= nil then

        if tronco.amount >= 1 then
            Player.Functions.RemoveItem("tronco", 1)
            Player.Functions.AddItem("tabuas", 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["tabuas"], "add")
            TriggerClientEvent('QBCore:Notify', src, 'tronco processadas.')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Não tens os items corretos...', 'error')
        end
    else
        TriggerClientEvent("QBCore:Notify", src, "Falta-te algo...", "error")
    end
end)

-- Evento para Venda items
RegisterNetEvent('mt-lumberjack:server:VenderTabuas', function(args) 
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local args = tonumber(args)
	if args == 1 then 
		local tabuas = Player.Functions.GetItemByName("tabuas")
		if tabuas ~= nil then
			local payment = 2 -- trocar aqui o preço que deseja para o próximo item
			Player.Functions.RemoveItem("tabuas", 1, k)
			Player.Functions.AddMoney('bank', payment , "tabuas-sell")
			TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["tabuas"], "remove", 1)
			TriggerClientEvent('QBCore:Notify', src, "1 "..source.." vendido por $"..payment, "success")
			TriggerClientEvent("mt-drugdealer:client:venda", source)
		else
		    TriggerClientEvent('QBCore:Notify', src, "Não tens nada para vender", "error")
        end 
    end
end)