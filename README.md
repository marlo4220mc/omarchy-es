# Omarchy en Español 🇪🇸

Capa de traducción al español para [Omarchy](https://github.com/basecamp/omarchy).

Añade una capa en español sobre una instalación existente de Omarchy traduciendo
los plugins, el menú y los atajos de teclado **en la fuente y sin modificar los
paquetes originales de Omarchy** (nada bajo `/usr`).

> **Importante:** `omarchy-es` no instala Omarchy ni CachyOS. Primero debes tener
> Omarchy funcionando y después instalar esta capa de traducción. Si instalas
> todo desde cero, usa el instalador que ya integra esta capa.

## Qué traduce

| Componente | Dónde | Mecanismo |
|---|---|---|
| Barra, plugins y paneles | `~/.config/omarchy/plugins/marlo4220.*` | Copias de los plugins con textos y locales en español |
| Menú raíz de Omarchy | `~/.config/omarchy/extensions/omarchy-menu.jsonc` | Extensión del menú en español |
| Shell/barra | `~/.config/omarchy/shell.json` | Config de la barra |
| Reloj y clima | Plugins `marlo4220.clock` / `marlo4220.weather` | `Qt.locale("es")` + días en español |
| Menú de atajos (Super+K) | `~/.config/hypr/bindings.lua` | Catálogo de bindings con descripciones en español |

## Por qué los atajos se traducen "en la fuente"

El menú de atajos (Super+K) es un listado de todos los bindings de Hyprland: sus
descripciones salen de `hyprctl binds`, y `hyprctl binds` copia el campo
`description` que recibe cada binding **al registrarse en la configuración**.

En vez de interceptar binarios o traducir el texto al vuelo, esta capa
re-registra **todos** los bindings con la misma tecla, modificadores, dispatcher
y argumento de los defaults, cambiando solo la descripción a español
(`hypr/bindings.lua`). Resultado:

- El menú Super+K sale 100 % en español leyendo la caché existente — **sin
  coste por apertura** (cero transformaciones en caliente).
- Se desactivan los defaults (`omarchy_default_bindings = false`) para que no
  haya duplicados en inglés.
- No se toca ni `/usr/*` ni el binario `omarchy-menu-keybindings`.
- Cada atajo funciona exactamente igual que antes: la descripción no participa
  en la ejecución.

### El orden agrupado se conserva con anclas invisibles

Las descripciones en español no casan con los patrones de orden del script
original (están en inglés), así que el listado saldría ordenado por combinación
de teclas. Para conservar el agrupado curado de fábrica, `hypr/bindings.lua`
añade a cada descripción una **ancla invisible**:

```
description = "Menú de Omarchy <font color=\"transparent\">Omarchy menu</font>"
```

- El ancla es un texto en inglés dentro de `<font color="transparent">…</font>`:
  los regex de orden del script original la casan y restauran el agrupado
  (Atajos de teclado, Menú de Omarchy, Terminal, Navegador, …).
- Es invisible al usuario: se pinta con color totalmente transparente.
- Cuando la descripción original ya es un patrón de orden (p. ej. regla 27,
  `SUPER SHIFT … B → Browser`), la ancla repite la palabra clave; cuando el
  orden se decide por la propia combinación (p. ej. `XF86`), no lleva ancla.
- El plugin `marlo4220.menu` renderiza esas filas como rich text
  (`Text.RichText`) solo cuando contienen `<font>`; el resto sigue en texto
  plano, y los espacios de la parte visible se convierten en `&nbsp;` para que
  la alineación de teclas y la flecha " → " no colapsen bajo el rich text.

## Instalación (capa sobre Omarchy existente)

```sh
chmod +x bootstrap.sh
./bootstrap.sh
```

Esto copia los plugins, el menú, `shell.json`, instala el catálogo de atajos en
`~/.config/hypr/bindings.lua`, activa `omarchy_default_bindings = false` en
`~/.config/hypr/hyprland.lua` y reinicia el shell de Omarchy.

## Instalación desde cero

El repo [omarchy-on-cachyos-es](https://github.com/marlo4220mc/omarchy-on-cachyos-es)
instala CachyOS + Omarchy y aplica esta capa automáticamente
(`bin/apply-es-layer.sh`).

## Notas

- El título del selector del menú de atajos sigue diciendo `Keybindings`
  (texto fijo del binario original de Omarchy, fuera de alcance de una capa de
  configuración).
- Dos filas del menú («Download Video from Web App» y «Copy URL from Web App»)
  las registra al vuelo el host nativo de Chromium de Omarchy y quedan en su
  idioma original.
- Si Omarchy añade bindings nuevos en una versión futura, aparecerán en inglés
  hasta que el catálogo de esta capa los espeje (cambio de una línea).
- El catálogo `hypr/bindings.lua` es la única fuente de atajos; añade ahí tus
  combinaciones personales en español.