ESX = exports['es_extended']:getSharedObject()


ESX.RegisterServerCallback('uwu:mozezebrac', function(source, cb, itemName, limit)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemName).count

    if itemCount < limit then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('uwu:maprzedmiot', function(source, cb, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemName).count

    if itemCount > 0 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('uwu:dodajitem')
AddEventHandler('uwu:dodajitem', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(itemName, count)
end)

RegisterServerEvent('uwu:processItem')
AddEventHandler('uwu:processItem', function(inputItem, outputItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(inputItem).count

    if itemCount > 0 then
        xPlayer.removeInventoryItem(inputItem, 1)
        xPlayer.addInventoryItem(outputItem, 1)
        TriggerClientEvent('esx:showNotification', source, 'Zrobiles Zestaw byq.')
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz odpowiednich skladnikow.')
    end
end)

RegisterServerEvent('uwu:sprzedajitem')
AddEventHandler('uwu:sprzedajitem', function(itemName, minReward, maxReward)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemName).count

    if itemCount > 0 then
        local reward = math.random(minReward, maxReward)
        xPlayer.removeInventoryItem(itemName, 1)
        xPlayer.addMoney(reward)
        TriggerClientEvent('esx:showNotification', source, 'Sprzedales produkt za $' .. reward)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz zadnych produktow.')
    end
end)