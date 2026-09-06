# Omarchy en Español

Capa de idioma para Omarchy: la interfaz del shell (barra, paneles, menú,
notificaciones, bloqueo, portapapeles, pruebas de velocidad…) en español.

Se implementa con los mecanismos oficiales de Omarchy — **clones de plugin**
(`marlo4220.*`) y la **extensión de menú** — de modo que sobrevive a
`omarchy update` y no modifica los paquetes de sistema.

## Contenido

| Ruta | Qué es |
|------|--------|
| `plugins/marlo4220.*` (22) | Clones traducidos en español de los plugins de Omarchy (audio, bluetooth, monitor, power, weather, clock, network, tray, indicators, system-update, agents, menu, notifications, reminders, lock, polkit, clipboard, image-picker, emojis, speedtest, disk-speedtest) |
| `extensions/omarchy-menu.jsonc` | Menú completo en español (iconos, acciones y condiciones originales intactos) |
| `shell.json` | Configuración de barra y plugins usando los ids `marlo4220.*` |

## Instalación en un Omarchy limpio

```bash
git clone <tu-repo> omarchy-es && cd omarchy-es
./bootstrap.sh
```

El script copia los plugins y el menú a `~/.config/omarchy/`, hace copia de
seguridad de tu `shell.json` y reinicia el shell.

## Notas

- Los ids de plugin son `marlo4220.…`: si los copias a otra cuenta, cambia el
  prefijo del manifest y las referencias de `shell.json` (o usa `omarchy
  plugin clone <id>` para regenerar un clon propio y vuelca tus archivos encima).
- El menú se recarga solo al abrirlo; `shell.json` y los plugins requieren
  `omarchy restart shell` tras la instalación (el script ya lo hace).
- No cubre textos de los binarios `omarchy …` (CLI) ni del núcleo `qs.Ui`/
  `qs.Commons`: esos forman parte del paquete /usr/share/omarchy y solo se
  traducen con un fork del fuente.