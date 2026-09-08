#!/usr/bin/env bash
# Omarchy en Español — instalador.
# Copia la capa de idioma a ~/.config/omarchy y reinicia el shell.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${OMARCHY_CONFIG_HOME:-$HOME/.config}/omarchy"

if ! command -v omarchy >/dev/null 2>&1; then
  echo "Omarchy no está instalado. Salgo." >&2
  exit 1
fi

mkdir -p "$DEST/plugins" "$DEST/extensions"

echo "→ Copiando el menú en español…"
cp "$SRC/extensions/omarchy-menu.jsonc" "$DEST/extensions/"

echo "→ Copiando los 22 plugins traducidos…"
for plugin in "$SRC"/plugins/marlo4220.*; do
  [ -d "$plugin" ] || continue
  name="$(basename "$plugin")"
  if [ -d "$DEST/plugins/$name" ]; then
    echo "   Actualizando $name"
    rm -rf "$DEST/plugins/$name"
  fi
  cp -r "$plugin" "$DEST/plugins/$name"
done

if [ -f "$SRC/shell.json" ]; then
  if [ -f "$DEST/shell.json" ]; then
    cp "$DEST/shell.json" "$DEST/shell.json.bak.$(date +%s)"
  fi
  echo "→ Copiando shell.json (barra con ids español)"
  cp "$SRC/shell.json" "$DEST/shell.json"
fi

if [ -f "$SRC/hypr/bindings.lua" ]; then
  echo "→ Instalando el catálogo de atajos en español (~/.config/hypr/bindings.lua)…"
  mkdir -p "$HOME/.config/hypr"
  if [ -f "$HOME/.config/hypr/bindings.lua" ] && ! grep -q "Capa omarchy-es" "$HOME/.config/hypr/bindings.lua"; then
    cp "$HOME/.config/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua.bak.$(date +%s)"
  fi
  cp "$SRC/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
fi

if [ -f "$HOME/.config/hypr/hyprland.lua" ] \
    && ! grep -q '^omarchy_default_bindings = false' "$HOME/.config/hypr/hyprland.lua"; then
  echo "→ Activando omarchy_default_bindings = false (el catálogo ES gobierna los atajos)…"
  sed -i '1i\omarchy_default_bindings = false' "$HOME/.config/hypr/hyprland.lua"
fi

echo "→ Reiniciando el shell…"
omarchy restart shell

echo "Listo: Omarchy en español."