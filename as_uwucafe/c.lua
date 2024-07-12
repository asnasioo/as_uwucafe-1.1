ESX = exports['es_extended']:getSharedObject()




local function createBlip(coords, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

createBlip(Config.KordyZbierania, "Zbieranie Skladnikow")
createBlip(Config.KordyPrzetwarzania, "Przetwarzanie Skladnikow")
createBlip(Config.KordySprzedazy, "Sprzedaz Produktow")

Citizen.CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = vector3(Config.KordyZbierania.x, Config.KordyZbierania.y, Config.KordyZbierania.z),
        size = vec3(1, 1, 2),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'uwu_gather',
                event = 'uwu:zbieranieskladnikow',
                icon = 'fas fa-leaf',
                label = 'Zbieraj Skkadniki',
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = vector3(Config.KordyPrzetwarzania.x, Config.KordyPrzetwarzania.y, Config.KordyPrzetwarzania.z),
        size = vec3(1, 1, 2),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'uwu_process',
                event = 'uwu:processskladniki',
                icon = 'fas fa-cogs',
                label = 'Przetwarzaj Składniki',
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = vector3(Config.KordySprzedazy.x, Config.KordySprzedazy.y, Config.KordySprzedazy.z),
        size = vec3(1, 1, 2),
        rotation = 0,
        debug = false,
        options = {
            {
                name = 'uwu_sell',
                event = 'uwu:sprzedajprodukt',
                icon = 'fas fa-dollar-sign',
                label = 'Sprzedaj Produkt',
            }
        }
    })
end)

RegisterNetEvent('uwu:zbieranieskladnikow', function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    if #(coords - vector3(Config.KordyZbierania.x, Config.KordyZbierania.y, Config.KordyZbierania.z)) < 2.0 then
        ESX.TriggerServerCallback('uwu:mozezebrac', function(canGather)
            if canGather then
                TaskStartScenarioInPlace(player, 'world_human_gardener_plant', 0, true)
                Citizen.Wait(15000)
                ClearPedTasks(player)
                TriggerServerEvent('uwu:dodajitem', Config.ZebranyPrzedmiot, 1)
            else
                ESX.ShowNotification("Masz maksymalna ilosc skladnikow.")
            end
        end, Config.ZebranyPrzedmiot, Config.LimitZbierania)
    end
end)

RegisterNetEvent('uwu:processskladniki', function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    if #(coords - vector3(Config.KordyPrzetwarzania.x, Config.KordyPrzetwarzania.y, Config.KordyPrzetwarzania.z)) < 2.0 then
        ESX.TriggerServerCallback('uwu:maprzedmiot', function(hasItem)
            if hasItem then
                TaskStartScenarioInPlace(player, 'world_human_welding', 0, true)
                Citizen.Wait(15000)
                ClearPedTasks(player)
                TriggerServerEvent('uwu:processItem', Config.ZebranyPrzedmiot, Config.PrzetworzonyPrzedmiot)
            else
                ESX.ShowNotification("Nie masz odpowiednich składnikow.")
            end
        end, Config.ZebranyPrzedmiot)
    end
end)

RegisterNetEvent('uwu:sprzedajprodukt', function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    if #(coords - vector3(Config.KordySprzedazy.x, Config.KordySprzedazy.y, Config.KordySprzedazy.z)) < 2.0 then
        ESX.TriggerServerCallback('uwu:maprzedmiot', function(hasItem)
            if hasItem then
                TaskStartScenarioInPlace(player, 'prop_human_bum_shopping_cart', 0, true)
                Citizen.Wait(15000)
                ClearPedTasks(player)
                TriggerServerEvent('uwu:sprzedajitem', Config.PrzetworzonyPrzedmiot, Config.MinKasa, Config.MaxKasa)
            else
                ESX.ShowNotification("Nie masz zadnych przedmiotow do sprzedania.")
            end
        end, Config.PrzetworzonyPrzedmiot)
    end
end)
