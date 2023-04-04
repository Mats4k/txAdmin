-- Prevent running in monitor mode
if not TX_SERVER_MODE then return end
-- Prevent running if menu is disabled
if not TX_MENU_ENABLED then return end

local IS_PTFX_DISABLED = GetConvarBool('txAdmin-menuPtfxDisable')

RegisterNetEvent('txAdmin:menu:playerModeChanged', function(mode, nearbyPlayers)
  local src = source
  if mode ~= 'godmode' and mode ~= 'noclip' and mode ~= 'superjump' and mode ~= 'none' then
    debugPrint("Invalid player mode requested by " .. GetPlayerName(src) .. " (mode: " .. (mode or 'nil'))
    return
  end

  local allow = PlayerHasTxPermission(src, 'players.playermode')
  TriggerEvent("txaLogger:menuEvent", src, "playerModeChanged", allow, mode)
  if allow then
    TriggerClientEvent('txAdmin:menu:playerModeChanged', src, mode, not IS_PTFX_DISABLED)

    if not IS_PTFX_DISABLED then
      for _, v in ipairs(nearbyPlayers) do
        TriggerClientEvent('txcl:syncPtfxEffect', v, src)
      end
    end
  end
end)
