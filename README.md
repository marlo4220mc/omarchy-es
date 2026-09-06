# Omarchy en Español 🇪🇸

Capa de traducción al español para [Omarchy](https://github.com/basecamp/omarchy).

Este proyecto añade una capa en español sobre una instalación existente de Omarchy, traduciendo la interfaz de los plugins y el menú sin modificar los paquetes originales de Omarchy.

> **Importante:** `omarchy-es` no instala Omarchy ni CachyOS. Primero debes tener Omarchy funcionando y después instalar esta capa de traducción.

## ¿Qué traduce?

Actualmente incluye:

- Barra y paneles de Omarchy.
- Menú principal.
- Notificaciones.
- Bloqueo de pantalla.
- Portapapeles.
- Selector de imágenes.
- Selector de emojis.
- Audio y Bluetooth.
- Red y bandeja del sistema.
- Indicadores del sistema.
- Actualizaciones del sistema.
- Agentes.
- Recordatorios.
- Polkit.
- Pruebas de velocidad.
- Prueba de velocidad del disco.
- Clima y reloj.

### Componentes

| Ruta | Descripción |
|------|-------------|
| `plugins/marlo4220.*` | Plugins traducidos al español. |
| `extensions/omarchy-menu.jsonc` | Menú de Omarchy traducido al español. |
| `shell.json` | Configuración de la barra utilizando los plugins traducidos. |
| `bootstrap.sh` | Instalador de la capa de traducción. |

## Requisitos

- Omarchy ya instalado y funcionando.
- Usuario con acceso a `~/.config/omarchy/`.
- Bash.
- Comando `omarchy` disponible.

No es necesario reinstalar Omarchy ni modificar los paquetes del sistema.

## Instalación

Clona el repositorio y ejecuta el instalador:

```bash
git clone https://github.com/marlo4220mc/omarchy-es.git
cd omarchy-es
chmod +x bootstrap.sh
./bootstrap.sh
```

El instalador:

1. Comprueba que Omarchy esté instalado.
2. Crea las carpetas necesarias dentro de `~/.config/omarchy/`.
3. Copia el menú traducido.
4. Copia los plugins `marlo4220.*`.
5. Hace una copia de seguridad del `shell.json` existente antes de reemplazarlo.
6. Reinicia el shell de Omarchy.

Al finalizar debería aparecer:

```text
Listo: Omarchy en español.
```

## Copias de seguridad

Si ya tienes un `shell.json`, el instalador crea automáticamente una copia de seguridad con un nombre similar a:

```text
shell.json.bak.XXXXXXXXXX
```

Los plugins y el menú instalados por esta capa utilizan el espacio de configuración del usuario, por lo que no reemplazan los archivos originales de `/usr/share/omarchy`.

## Actualizar la traducción

Para instalar una versión más reciente:

```bash
cd omarchy-es
git pull
./bootstrap.sh
```

## Limitaciones actuales

Esta capa no traduce todo Omarchy.

No están cubiertos actualmente:

- Textos generados directamente por los binarios/comandos `omarchy …`.
- Textos pertenecientes al núcleo `qs.Ui` y `qs.Commons`.
- Componentes que formen parte directamente del paquete original de Omarchy y no puedan ser sustituidos mediante plugins o extensiones.

Esos componentes requieren modificar o mantener un fork del código fuente de Omarchy.

## Filosofía del proyecto

`omarchy-es` mantiene la traducción separada de los archivos originales de Omarchy. De esta forma, las actualizaciones de Omarchy pueden continuar realizándose sin tener que modificar manualmente los archivos del sistema.

Los plugins de esta capa utilizan el prefijo `marlo4220.*` para diferenciarlos de los plugins originales.

## Desarrollo

Las traducciones y modificaciones se mantienen en este repositorio:

```text
https://github.com/marlo4220mc/omarchy-es
```

Las contribuciones, correcciones de traducción y nuevas traducciones son bienvenidas.

## Licencia

Consulta los archivos y licencias correspondientes de Omarchy y de cada componente incluido. Esta capa de traducción no pretende sustituir las licencias originales de los proyectos sobre los que se basa.
