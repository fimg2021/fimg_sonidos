RegisterServerEvent('playAmbientSound')
AddEventHandler('playAmbientSound', function(soundUrl, volume)
    -- Enviar el evento a todos los jugadores cercanos
    TriggerClientEvent('playAmbientSound', -1, soundUrl, volume)
end)






