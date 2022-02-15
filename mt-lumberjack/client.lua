local QBCore = exports['qb-core']:GetCoreObject()

-- Criar blip para do mapa
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2298.27, 5140.95, 52.49) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 113) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Lumberjack") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)

-- Evento para cortar os troncos das arvores
RegisterNetEvent('mt-lumberjack:client:CortarTroncos')
AddEventHandler("mt-lumberjack:client:CortarTroncos", function()
    QBCore.Functions.Progressbar("troncos", "CUTTING TREE TRUNKS", 500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "melee@hatchet@streamed_core",
        anim = "plyr_rear_takedown_b",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local success = exports['qb-lock']:StartLockPickCircle(1,30)
   if success then
        StopAnimTask(ped, dict, "plyr_rear_takedown_b", 1.0)
        TriggerServerEvent("mt-lumberjack:server:DarTroncos")
        ClearPedTasks(playerPed)
    else
        QBCore.Functions.Notify("Failed!", "error")
        ClearPedTasks(playerPed)
        end
    end)
end)

-- Target para cortar os troncos
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("troncos", vector3(-540.75, 5382.32, 71.43), 2, 2, {
        name = "troncos",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-lumberjack:client:CortarTroncos",
                icon = "fas fa-axe",
                label = "Cut Trunks",
            },
        },
        distance = 2.5
    })
end)

-- Target para processar tabuas
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("tabuas", vector3(-551.69, 5330.04, 74.97), 2, 2, {
        name = "tabuas",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-lumberjack:client:ProcessarTabuas",
                icon = "fas fa-axe",
                label = "Process Trunks",
            },
        },
        distance = 2.5
    })
end)

-- Evento para processar madeira
RegisterNetEvent('mt-lumberjack:client:ProcessarTabuas')
AddEventHandler("mt-lumberjack:client:ProcessarTabuas", function()
    QBCore.Functions.Progressbar("troncos", "PROCESSING BOARDS", 500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_player",
        flags = 16,
    }, {}, {}, function() 
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent("mt-lumberjack:server:DarTabuas")
        ClearPedTasks(playerPed)
    end)
end)

-- spawn ped vendas
local vendasPed = {
	{-483.82, 5277.45, 85.86,"Zé Das Coves",68.34,0x039677BD,"cs_jimmyboston"}, -- trocar aqui o ped e a sua loc
  }
  Citizen.CreateThread(function()
	  for _,v in pairs(vendasPed) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  VendaProcPed =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(VendaProcPed, v[5])
		  FreezeEntityPosition(VendaProcPed, true)
		  SetEntityInvincible(VendaProcPed, true)
		  SetBlockingOfNonTemporaryEvents(VendaProcPed, true)
		  TaskStartScenarioInPlace(VendaProcPed, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	  end
  end)

-- Target para venda das tabuas
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("VendaTabuas", vector3(-483.82, 5277.45, 86.86), 1, 1, {
        name = "VendaTabuas",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-lumberjack:client:VenderTabuas",
                icon = "fas fa-axe",
                label = "Talk with employee",
            },
        },
        distance = 2.5
    })
end)

-- Menu de vendas
RegisterNetEvent('mt-lumberjack:client:VenderTabuas')
AddEventHandler('mt-lumberjack:client:VenderTabuas', function()
    exports['qb-menu']:openMenu({
		{
            header = "Board Employee",
            isMenuHeader = true
        },
        { -- copiar daqui
            header = "Sell Boards",
            txt = "Price: 2$",
            params = {
				isServer = true,
                event = "mt-lumberjack:server:VenderTabuas",
				args = 1 -- mudar aqui os args
            }
        },		-- até aqui, colar logo aqui em baixo		
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)
