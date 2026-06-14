#!/bin/bash

SOURCE="$HOME/.config/hypr/colors.conf"

WAYBAR_DEST="$HOME/.config/waybar/colors.css"
KITTY_DEST="$HOME/.config/kitty/colors.conf"

STARSHIP_COLORS="$HOME/.config/starship_colors.toml"
YAZI_COLORS="$HOME/.config/yazi/colors.toml"

STARSHIP_DEST="$HOME/.config/starship.toml"
YAZI_DEST="$HOME/.config/yazi/theme.toml"

STARSHIP_BASE="$HOME/.config/starship_base.toml"
YAZI_BASE="$HOME/.config/yazi/theme_base.toml"
# Príprava
echo "/*Script Generated */" >"$WAYBAR_DEST"
echo "#Script Generated" >"$KITTY_DEST"
echo "[Script Generated]" >"$STARSHIP_DEST"
echo "[Script Generated]" >"$YAZI_DEST"

# 1. WAYBAR (CSS)
sed -n 's/^\$\([^ ]*\) = rgb(\([^)]*\)).*/@define-color \1 #\2;/p' "$SOURCE" >>"$WAYBAR_DEST"
# RGBA
sed -n 's/^\$\([^ ]*\) = rgba(\([^)]*\)).*/@define-color \1 rgba(\2);/p' "$SOURCE" >>"$WAYBAR_DEST"

# 2. KITTY (Conf)
sed -n 's/^\$\([^ ]*\) = rgb(\([^)]*\)).*/\1 #\2/p' "$SOURCE" >>"$KITTY_DEST"

# 3. STARSHIP (TOML) - formát: meno = "#hex"
sed -n 's/^\$\([^ ]*\) = rgb(\([^)]*\)).*/\1 = "#\2"/p' "$SOURCE" >>"$STARSHIP_COLORS"

# 4. YAZI (TOML)
sed -n 's/^\$\([^ ]*\) = rgb(\([^)]*\)).*/\1 = "#\2"/p' "$SOURCE" >>"$YAZI_COLORS"

# Waybar Reload (in case of dependency stuck)
pkill -USR2 waybar

# Na záver spojíme statický config s vygenerovanými farbami
cat "$STARSHIP_BASE" "$STARSHIP_COLORS" >"$STARSHIP_DEST"
cat "$YAZI_BASE" "$YAZI_COLORS" >"$YAZI_DEST"
