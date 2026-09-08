-- Capa omarchy-es: catálogo de bindings en español (en la fuente).
--
-- Se registran TODAS las combinaciones por defecto de Omarchy (media,
-- portapapeles, tiling, utilidades, aplicaciones y apps preinstaladas) con
-- descripciones en español. Solo cambia el texto visible: teclas, modificadores,
-- dispatchers y argumentos son idénticos a los defaults, así que el
-- comportamiento de cada atajo no varía.
--
-- Requiere en ~/.config/hypr/hyprland.lua (antes de require("default.hypr.omarchy")):
--   omarchy_default_bindings = false

-- ===== apps: aplicaciones esenciales =====
o.bind("SUPER + RETURN", "Terminal <font color=\"transparent\">Terminal</font>", { omarchy = "terminal" })
o.bind("SUPER + SHIFT + RETURN", "Navegador <font color=\"transparent\">Browser</font>", { omarchy = "browser" })
o.bind("SUPER + SHIFT + F", "Administrador de archivos <font color=\"transparent\">File manager</font>", { omarchy = "nautilus" })
o.bind("SUPER + ALT + SHIFT + F", "Administrador de archivos (carpeta actual) <font color=\"transparent\">File manager (cwd)</font>", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + B", "Navegador <font color=\"transparent\">Browser</font>", { omarchy = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Navegador (privado)", { omarchy = "browser --private" })
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })

-- Bindings de aplicaciones preinstaladas, TUIs y web apps.
o.bind("SUPER + ALT + RETURN", "Tmux <font color=\"transparent\">Tmux</font>", { omarchy = "terminal-tmux" })
o.bind("SUPER + CTRL + RETURN", "Herdr <font color=\"transparent\">Herdr</font>", { omarchy = "terminal-herdr" })
o.bind("SUPER + SHIFT + M", "Música", { omarchy = "spotify" })
o.bind("SUPER + SHIFT + ALT + M", "Música (TUI)", { tui = "cliamp", focus = true })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "omarchy-launch-docker-tui" })
o.bind("SUPER + SHIFT + G", "Signal", { omarchy = "signal" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + W", "Omawrite", { launch = "omawrite" })
o.bind("SUPER + SHIFT + SLASH", "Contraseñas", { omarchy = "1password" })

o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
o.bind("SUPER + SHIFT + ALT + A", "Grok", { webapp = "https://grok.com" })
o.bind("SUPER + SHIFT + C", "Calendario", { webapp = "https://app.hey.com/calendar/weeks/" })
o.bind("SUPER + SHIFT + E", "Correo electrónico", { webapp = "https://app.hey.com" })
o.bind("SUPER + SHIFT + ALT + E", "Nuevo correo electrónico", { webapp = "https://app.hey.com/messages/new?display=standalone&new_window=true" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + SHIFT + CTRL + G", "Google Messages", { webapp = "https://messages.google.com/web/conversations", focus = true })
o.bind("SUPER + SHIFT + P", "Google Photos", { webapp = "https://photos.google.com/", focus = true })
o.bind("SUPER + SHIFT + S", "Google Maps", { webapp = "https://maps.google.com/", focus = true })
o.bind("SUPER + SHIFT + X", "X", { webapp = "https://x.com/" })
o.bind("SUPER + SHIFT + ALT + X", "Publicar en X", { webapp = "https://x.com/compose/post" })

-- ===== portapapeles: accesos directos universales =====
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

o.bind("SUPER + C", "Copia universal <font color=\"transparent\">Universal</font>", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
o.bind("SUPER + V", "Pegado universal <font color=\"transparent\">Universal</font>", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
o.bind("SUPER + X", "Cortado universal <font color=\"transparent\">Universal</font>", send_shortcut_once("CTRL", "X"))
o.bind("SUPER + CTRL + V", "Administrador del portapapeles <font color=\"transparent\">Clipboard</font>", "omarchy-shell shell toggle omarchy.clipboard")

-- ===== tiling: ventanas, espacios de trabajo y grupos =====
o.bind("SUPER + W", "Cerrar ventana <font color=\"transparent\">Close window</font>", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Cerrar todas las ventanas <font color=\"transparent\">Close all windows</font>", "omarchy-hyprland-window-close-all")

o.bind("SUPER + J", "Alternar división de ventana <font color=\"transparent\">Toggle window split</font>", hl.dsp.layout("togglesplit"))
o.bind("SUPER + P", "Ventana pseudo", hl.dsp.window.pseudo())
o.bind("SUPER + T", "Alternar ventana flotante/expandida <font color=\"transparent\">Toggle window floating</font>", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + F", "Pantalla completa <font color=\"transparent\">Full screen</font>", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + CTRL + F", "Pantalla completa en mosaico", "omarchy-hyprland-window-tiled-fullscreen-toggle")
o.bind("SUPER + ALT + F", "Ancho completo <font color=\"transparent\">Full width</font>", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + O", "Sacar ventana (flotar y fijar) <font color=\"transparent\">Pop window</font>", "omarchy-hyprland-window-pop")
o.bind("SUPER + ALT + Home", "Guardar el ancho de la ventana", "omarchy-hyprland-window-width save")
o.bind("SUPER + Home", "Restaurar el ancho de la ventana", "omarchy-hyprland-window-width restore")
o.bind("SUPER + L", "Alternar el diseño del espacio de trabajo", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + LEFT", "Enfocar la ventana de la izquierda <font color=\"transparent\">Focus</font>", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + RIGHT", "Enfocar la ventana de la derecha <font color=\"transparent\">Focus</font>", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + UP", "Enfocar la ventana superior <font color=\"transparent\">Focus</font>", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + DOWN", "Enfocar la ventana inferior <font color=\"transparent\">Focus</font>", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  o.bind("SUPER + " .. key, "Cambiar al espacio de trabajo " .. workspace .. " <font color=\"transparent\">Switch to workspace</font>", hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key, "Mover ventana al espacio de trabajo " .. workspace .. " <font color=\"transparent\">Move window to workspace</font>", hl.dsp.window.move({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + ALT + " .. key, "Mover ventana en silencio al espacio de trabajo " .. workspace .. " <font color=\"transparent\">Move window silently to workspace</font>", hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

o.bind("SUPER + S", "Alternar anotador (scratchpad) <font color=\"transparent\">scratchpad</font>", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + ALT + S", "Mover ventana al anotador (scratchpad) <font color=\"transparent\">scratchpad</font>", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

o.bind("SUPER + TAB", "Siguiente espacio de trabajo <font color=\"transparent\">Next workspace</font>", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + SHIFT + TAB", "Anterior espacio de trabajo <font color=\"transparent\">Previous workspace</font>", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + CTRL + TAB", "Anterior espacio de trabajo <font color=\"transparent\">Previous workspace</font>", hl.dsp.focus({ workspace = "previous" }))

o.bind("SUPER + SHIFT + ALT + LEFT", "Mover el espacio de trabajo al monitor de la izquierda", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + RIGHT", "Mover el espacio de trabajo al monitor de la derecha", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + UP", "Mover el espacio de trabajo al monitor superior", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + DOWN", "Mover el espacio de trabajo al monitor inferior", hl.dsp.workspace.move({ monitor = "d" }))

o.bind("SUPER + SHIFT + LEFT", "Intercambiar ventana a la izquierda <font color=\"transparent\">Swap window</font>", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + RIGHT", "Intercambiar ventana a la derecha <font color=\"transparent\">Swap window</font>", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + UP", "Intercambiar ventana hacia arriba <font color=\"transparent\">Swap window</font>", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + DOWN", "Intercambiar ventana hacia abajo <font color=\"transparent\">Swap window</font>", hl.dsp.window.swap({ direction = "d" }))

o.bind("ALT + TAB", "Enfocar la siguiente ventana <font color=\"transparent\">Focus</font>", hl.dsp.window.cycle_next())
o.bind("ALT + SHIFT + TAB", "Enfocar la ventana anterior <font color=\"transparent\">Focus</font>", hl.dsp.window.cycle_next({ next = false }))
o.bind("ALT + TAB", "Presentar la ventana activa en primer plano <font color=\"transparent\">Reveal active</font>", hl.dsp.window.bring_to_top())
o.bind("ALT + SHIFT + TAB", "Presentar la ventana activa en primer plano <font color=\"transparent\">Reveal active</font>", hl.dsp.window.bring_to_top())

o.bind("CTRL + ALT + TAB", "Enfocar el siguiente monitor <font color=\"transparent\">Focus</font>", hl.dsp.focus({ monitor = "+1" }))
o.bind("CTRL + ALT + SHIFT + TAB", "Enfocar el monitor anterior <font color=\"transparent\">Focus</font>", hl.dsp.focus({ monitor = "-1" }))

o.bind("SUPER + code:20", "Expandir ventana a la izquierda <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + code:21", "Contraer ventana a la izquierda <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + code:20", "Contraer ventana hacia arriba <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + SHIFT + code:21", "Expandir ventana hacia abajo <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

o.bind("SUPER + ALT + code:20", "Expandir ventana un poco a la izquierda <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
o.bind("SUPER + ALT + code:21", "Contraer ventana un poco a la izquierda <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:20", "Contraer ventana un poco hacia arriba <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:21", "Expandir ventana un poco hacia abajo <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

o.bind("SUPER + CTRL + code:20", "Expandir ventana mucho a la izquierda <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
o.bind("SUPER + CTRL + code:21", "Contraer ventana mucho a la izquierda <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:20", "Contraer ventana mucho hacia arriba <font color=\"transparent\">Shrink window</font>", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:21", "Expandir ventana mucho hacia abajo <font color=\"transparent\">Expand window</font>", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))

o.bind("SUPER + mouse_down", "Desplazar el espacio activo hacia adelante <font color=\"transparent\">Scroll active workspace</font>", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + mouse_up", "Desplazar el espacio activo hacia atrás <font color=\"transparent\">Scroll active workspace</font>", hl.dsp.focus({ workspace = "e-1" }))

o.bind("SUPER + mouse:272", "Mover ventana <font color=\"transparent\">Move window</font>", hl.dsp.window.drag(), { mouse = true })
o.bind("SUPER + mouse:273", "Redimensionar ventana <font color=\"transparent\">Resize window</font>", hl.dsp.window.resize(), { mouse = true })

o.bind("SUPER + G", "Alternar agrupación de ventanas <font color=\"transparent\">group</font>", hl.dsp.group.toggle())
o.bind("SUPER + ALT + G", "Sacar la ventana activa del grupo <font color=\"transparent\">group</font>", hl.dsp.window.move({ out_of_group = true }))

o.bind("SUPER + ALT + LEFT", "Mover ventana al grupo de la izquierda <font color=\"transparent\">group</font>", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + RIGHT", "Mover ventana al grupo de la derecha <font color=\"transparent\">group</font>", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + UP", "Mover ventana al grupo superior <font color=\"transparent\">group</font>", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + DOWN", "Mover ventana al grupo inferior <font color=\"transparent\">group</font>", hl.dsp.window.move({ into_group = "d" }))

o.bind("SUPER + ALT + TAB", "Siguiente ventana del grupo <font color=\"transparent\">group</font>", hl.dsp.group.next())
o.bind("SUPER + ALT + SHIFT + TAB", "Ventana anterior del grupo <font color=\"transparent\">group</font>", hl.dsp.group.prev())

o.bind("SUPER + CTRL + LEFT", "Mover el enfoque del grupo a la izquierda <font color=\"transparent\">group</font>", hl.dsp.group.prev())
o.bind("SUPER + CTRL + RIGHT", "Mover el enfoque del grupo a la derecha <font color=\"transparent\">group</font>", hl.dsp.group.next())

o.bind("SUPER + ALT + mouse_down", "Siguiente ventana del grupo <font color=\"transparent\">group</font>", hl.dsp.group.next())
o.bind("SUPER + ALT + mouse_up", "Ventana anterior del grupo <font color=\"transparent\">group</font>", hl.dsp.group.prev())

for index = 1, 5 do
  o.bind("SUPER + ALT + code:" .. tostring(index + 9), "Cambiar a la ventana " .. index .. " del grupo <font color=\"transparent\">group</font>", hl.dsp.group.active({ index = index }))
end

o.bind("SUPER + SLASH", "Subir la escala del monitor", "omarchy-hyprland-monitor-scaling up")
o.bind("SUPER + ALT + SLASH", "Bajar la escala del monitor", "omarchy-hyprland-monitor-scaling down")

-- ===== utilidades y menús =====
o.bind("SUPER + SPACE", "Menú de Omarchy <font color=\"transparent\">Omarchy menu</font>", "omarchy-menu toggle")
o.bind("SUPER + ALT + SPACE", "Menú de aplicaciones", "omarchy-menu toggle apps")
o.bind("SUPER + CTRL + E", "Emojis <font color=\"transparent\">Emojis</font>", "omarchy-shell shell toggle omarchy.emojis")
o.bind("SUPER + CTRL + C", "Menú de captura", "omarchy-menu toggle capture")
o.bind("SUPER + CTRL + O", "Alternar menú", "omarchy-menu toggle toggle")
o.bind("SUPER + CTRL + H", "Menú de hardware", "omarchy-menu toggle hardware")
o.bind("SUPER + SHIFT + code:201", "Menú de Omarchy <font color=\"transparent\">Omarchy menu</font>", "omarchy-menu toggle root")
o.bind("SUPER + ESCAPE", "Menú de sistema <font color=\"transparent\">System menu</font>", "omarchy-menu toggle system")
o.bind("XF86PowerOff", "Menú de energía", "omarchy-menu toggle system", { locked = true })
o.bind("SUPER + K", "Atajos de teclado <font color=\"transparent\">Keybindings</font>", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + K", "Atajos de Tmux <font color=\"transparent\">Tmux</font>", "omarchy-menu-tmux-keybindings")
o.bind("SUPER + CTRL + K", "Atajos de Herdr <font color=\"transparent\">Herdr</font>", "omarchy-menu-herdr-keybindings")
o.bind("SUPER + CTRL + Q", "Calculadora", "omacalc")
o.bind("XF86Calculator", "Calculadora", "omacalc")

o.bind_toggle("SUPER + SHIFT + SPACE", "Alternar la barra superior", "bar")
o.bind("SUPER + CTRL + SPACE", "Cambiador de fondo", "omarchy-menu toggle background")
o.bind("SUPER + SHIFT + CTRL + SPACE", "Menú de temas <font color=\"transparent\">Theme menu</font>", "omarchy-menu toggle theme")
o.bind("SUPER + BACKSPACE", "Alternar transparencia de ventana <font color=\"transparent\">Toggle window transparency</font>", "omarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + SHIFT + BACKSPACE", "Alternar márgenes de ventana", "omarchy-hyprland-window-gaps-toggle")
o.bind("SUPER + CTRL + BACKSPACE", "Alternar aspecto cuadrado de ventana única", "omarchy-hyprland-window-single-square-aspect-toggle")

o.bind("SUPER + comma", "Descartar la última notificación <font color=\"transparent\">notification</font>", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SHIFT + comma", "Descartar todas las notificaciones <font color=\"transparent\">notification</font>", "omarchy-shell notifications dismissAll")
o.bind_toggle("SUPER + CTRL + comma", "Alternar silencio de notificaciones <font color=\"transparent\">notification</font>", "notification-silencing")
o.bind("SUPER + ALT + comma", "Invocar la última notificación <font color=\"transparent\">notification</font>", "omarchy-shell notifications invokeLast")
o.bind("SUPER + SHIFT + ALT + comma", "Abrir histórico de notificaciones <font color=\"transparent\">notification</font>", "omarchy-shell notifications showHistory")

o.bind_toggle("SUPER + CTRL + I", "Alternar bloqueo al reposo <font color=\"transparent\">Toggle locking</font>", "idle")
o.bind_toggle("SUPER + CTRL + N", "Alternar luz nocturna <font color=\"transparent\">Toggle nightlight</font>", "nightlight")
o.bind("SUPER + CTRL + Delete", "Alternar la pantalla del portátil", "omarchy-hyprland-monitor-internal toggle")
o.bind("SUPER + CTRL + ALT + Delete", "Alternar duplicado de la pantalla del portátil", "omarchy-hyprland-monitor-internal-mirror toggle")
o.bind("switch:on:Lid Switch", nil, "omarchy-system-lid-close", { locked = true })
o.bind("switch:off:Lid Switch", nil, "omarchy-hyprland-monitor-clamshell", { locked = true })

o.bind("PRINT", "Captura de pantalla <font color=\"transparent\">Screenshot</font>", "omarchy-capture-screenshot")
o.bind("ALT + PRINT", "Grabación de pantalla <font color=\"transparent\">Screenrecording</font>", "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
o.bind("SUPER + ALT + code:34", "Reducir la superposición de la webcam", "omarchy-capture-webcam-resize smaller")
o.bind("SUPER + ALT + code:35", "Agrandar la superposición de la webcam", "omarchy-capture-webcam-resize larger")
o.bind("SUPER + PRINT", "Selector de color <font color=\"transparent\">Color picker</font>", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + PRINT", "Extraer texto (OCR) de una captura", "omarchy-capture-text")

local selection_layers = 0
local selection_binds = {}

hl.on("layer.opened", function(layer)
  if layer.namespace == "selection" then
    selection_layers = selection_layers + 1
    if selection_layers == 1 then
      selection_binds = {
        hl.bind("RETURN", hl.dsp.exec_cmd("omarchy-capture-region --take-window"), { description = "Capturar la ventana resaltada" }),
        hl.bind("CTRL + RETURN", hl.dsp.exec_cmd("omarchy-capture-region --take-fullscreen"), { description = "Capturar la pantalla completa" }),
        hl.bind("TAB", hl.dsp.exec_cmd("omarchy-capture-region --select-window next"), { description = "Seleccionar la siguiente ventana para capturar" }),
        hl.bind("CTRL + TAB", hl.dsp.exec_cmd("omarchy-capture-region --select-window prev"), { description = "Seleccionar la ventana anterior para capturar" }),
      }
      for _, direction in ipairs({ "left", "right", "up", "down" }) do
        table.insert(
          selection_binds,
          hl.bind(direction:upper(), hl.dsp.exec_cmd("omarchy-capture-region --select-window " .. direction), { description = "Seleccionar la ventana para capturar" })
        )
      end
    end
  end
end)

hl.on("layer.closed", function(layer)
  if layer.namespace == "selection" and selection_layers > 0 then
    selection_layers = selection_layers - 1
    if selection_layers == 0 then
      for _, keybind in ipairs(selection_binds) do
        keybind:unbind()
      end
      selection_binds = {}
    end
  end
end)

o.bind("SUPER + CTRL + S", "Compartir", "omarchy-menu toggle share")

o.bind("SUPER + CTRL + PERIOD", "Transcodificar", "omarchy-transcode")

o.bind("SUPER + CTRL + R", "Programar recordatorio", "omarchy-menu toggle reminder-set")
o.bind("SUPER + CTRL + ALT + R", "Mostrar recordatorios", "omarchy-reminder show")
o.bind("SUPER + SHIFT + CTRL + R", "Borrar recordatorios", "omarchy-reminder clear")

o.bind("SUPER + CTRL + ALT + T", "Mostrar la hora", "omarchy-notification-time")
o.bind("SUPER + CTRL + ALT + B", "Mostrar la batería restante", "omarchy-notification-battery")
o.bind("SUPER + CTRL + ALT + W", "Alternar clima", "omarchy-notification-weather")

o.bind("SUPER + SHIFT + CTRL + A", "Agente", "omarchy-agent --pick")
o.bind("SUPER + CTRL + A", "Audio", "omarchy-shell shell toggle omarchy.audio")
o.bind("SUPER + CTRL + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")
o.bind("SUPER + CTRL + D", "Pantalla", "omarchy-shell shell toggle omarchy.monitor")
o.bind("SUPER + CTRL + ALT + D", "Calendario", "omarchy-shell shell toggle omarchy.clock")
o.bind("SUPER + CTRL + W", "Red", "omarchy-shell shell toggle omarchy.network")
o.bind("SUPER + CTRL + P", "Energía", "omarchy-shell shell toggle omarchy.power")
o.bind("SUPER + CTRL + T", "Actividad", { tui = "btop" })

for panel = 1, 9 do
  o.bind(
    "SUPER + CTRL + code:" .. tostring(panel + 9),
    "Panel de barra " .. panel,
    "omarchy-shell -q shell togglePanelAt right " .. panel
  )
end

o.bind("SUPER + CTRL + Z", "Acercar", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)

o.bind("SUPER + CTRL + ALT + Z", "Restablecer zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

o.bind("SUPER + CTRL + L", "Bloquear sistema <font color=\"transparent\">Lock system</font>", "omarchy-system-lock")

-- ===== multimedia, brillo, táctil y medios =====
o.bind("XF86AudioRaiseVolume", "Subir volumen", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Bajar volumen", "omarchy-audio-output-volume lower", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Silenciar", "omarchy-audio-output-volume mute-toggle", { locked = true })
o.bind("XF86AudioMicMute", "Silenciar micrófono", "omarchy-audio-input-mute", { locked = true })
o.bind("XF86MonBrightnessUp", "Subir brillo", "omarchy-brightness-display +5%", { locked = true, repeating = true })
o.bind("XF86MonBrightnessDown", "Bajar brillo", "omarchy-brightness-display 5%-", { locked = true, repeating = true })
o.bind("SHIFT + XF86MonBrightnessUp", "Brillo máximo", "omarchy-brightness-display 100%", { locked = true, repeating = true })
o.bind("SHIFT + XF86MonBrightnessDown", "Brillo mínimo", "omarchy-brightness-display 1%", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessUp", "Subir el brillo del teclado", "omarchy-brightness-keyboard up", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessDown", "Bajar el brillo del teclado", "omarchy-brightness-keyboard down", { locked = true, repeating = true })
o.bind("XF86KbdLightOnOff", "Ciclar la retroiluminación del teclado", "omarchy-brightness-keyboard cycle", { locked = true })
o.bind_toggle("XF86TouchpadToggle", "Alternar panel táctil", "touchpad", { locked = true })
o.bind("XF86TouchpadOn", "Activar panel táctil", "omarchy-toggle-touchpad on", { locked = true })
o.bind("XF86TouchpadOff", "Desactivar panel táctil", "omarchy-toggle-touchpad off", { locked = true })

o.bind("ALT + XF86AudioRaiseVolume", "Subir volumen (preciso)", "omarchy-audio-output-volume +1", { locked = true, repeating = true })
o.bind("ALT + XF86AudioLowerVolume", "Bajar volumen (preciso)", "omarchy-audio-output-volume -1", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessUp", "Subir brillo (preciso)", "omarchy-brightness-display +1%", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessDown", "Bajar brillo (preciso)", "omarchy-brightness-display 1%-", { locked = true, repeating = true })

o.bind("XF86AudioNext", "Siguiente pista", "omarchy-shell media next", { locked = true })
o.bind("ALT + XF86AudioPlay", "Siguiente pista", "omarchy-shell media next", { locked = true })
o.bind("XF86AudioPause", "Pausar", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPlay", "Reproducir", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPrev", "Pista anterior", "omarchy-shell media previous", { locked = true })
o.bind("ALT + SHIFT + XF86AudioPlay", "Pista anterior", "omarchy-shell media previous", { locked = true })
o.bind("XF86Eject", "Expulsar medio", "eject", { locked = true })

o.bind("SHIFT + XF86AudioMute", "Cambiar salida de audio", "omarchy-audio-output-switch", { locked = true })
o.bind("SHIFT + XF86AudioPause", "Cambiar fuente multimedia", "omarchy-audio-source-switch", { locked = true })
o.bind("SHIFT + XF86AudioPlay", "Cambiar fuente multimedia", "omarchy-audio-source-switch", { locked = true })

-- ===== dictado (solo si voxtype está instalado) =====
if o.cmd_present("voxtype") then
  o.bind("SUPER + CTRL + X", "Alternar dictado", "voxtype record toggle")
  o.bind("F9", "Iniciar dictado (pulsar para hablar)", "voxtype record start")
  o.bind("F9", "Detener dictado (pulsar para hablar)", "voxtype record stop", { release = true })
end