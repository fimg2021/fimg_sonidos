-- Requiere PolyZone
local PolyZone = PolyZone

local zonesConfig = {
    {
        coords = {
            vector2(215.76, -810.12),
            vector2(218.76, -810.12),
            vector2(218.76, -807.12),
            vector2(215.76, -807.12)
        },
        minZ = 29.0,
        maxZ = 31.0,
        soundUrl = "https://www.youtube.com/watch?v=ZgMovmlsh5M",
        debug = false,
        volume = 50 -- Volumen inicial (0-100)
    },
    {
        coords = {
            vector2(100.0, -500.0),
            vector2(103.0, -500.0),
            vector2(103.0, -497.0),
            vector2(100.0, -497.0)
        },
        minZ = 29.0,
        maxZ = 31.0,
        soundUrl = "https://www.youtube.com/watch?v=ZgMovmlsh5M&t",
        debug = false,
        volume = 50 -- Volumen inicial (0-100)
    }
    -- Añade más ubicaciones según sea necesario
}

local zones = {}

-- Función para crear zona
local function createZone(zoneConfig)
    return PolyZone:Create(zoneConfig.coords, {
        name = zoneConfig.name,
        debugPoly = zoneConfig.debug,
        minZ = zoneConfig.minZ,
        maxZ = zoneConfig.maxZ
    })
end

-- Crear zonas basadas en la configuración
for i, zoneConfig in ipairs(zonesConfig) do
    zoneConfig.name = "zone" .. i
    zones[i] = {
        zoneConfig = zoneConfig,
        zone = createZone(zoneConfig),
        soundUrl = zoneConfig.soundUrl,
        isPointInside = false,
        volume = zoneConfig.volume
    }
end

-- Función para reproducir sonido
local function PlaySound(soundUrl, volume)
    SendNUIMessage({
        action = "playSound",
        soundUrl = soundUrl,
        volume = volume
    })
end

-- Función para detener sonido
local function StopSound()
    SendNUIMessage({action = "stopSound"})
end

-- Registrar eventos de entrada y salida de zona
for i, zoneData in ipairs(zones) do
    zoneData.zone:onPlayerInOut(function(isPointInside)
        if isPointInside and not zoneData.isPointInside then
            zoneData.isPointInside = true
            TriggerServerEvent('playAmbientSound', zoneData.soundUrl, zoneData.volume)
        elseif not isPointInside and zoneData.isPointInside then
            zoneData.isPointInside = false
            StopSound()
        end
    end)
end

-- Escuchar el evento desde el servidor
RegisterNetEvent('playAmbientSound')
AddEventHandler('playAmbientSound', function(soundUrl, volume)
    PlaySound(soundUrl, volume)
end)
