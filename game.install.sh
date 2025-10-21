#!/system/bin/sh
# 🧠 Updatable GPU Driver Enabler for Brevent (Universal)
# Works on root or non-root (with WRITE_SECURE_SETTINGS)
# Android 10+ | Stock or Custom ROM
# Licensed file @willy Project
# Developed by: willygailo**@gmail.com

PACKAGES="com.mobile.legends|com.activision.callofduty.shooter|com.tencent.ig|com.miHoYo.GenshinImpact"

echo "🚀 Starting GPU Driver Optimization..."
sleep 1
echo "📦 Target Apps:"
echo "🎮 Mobile Legends"
echo "🔫 Call of Duty Mobile"
echo "⚔️ PUBG Mobile"
echo "🌌 Genshin Impact"
echo

spinner() {
  pid=$1
  spin=("🔄" "🌀" "💫" "🌕")
  i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r${spin[i % ${#spin[@]}]} Applying..."
    i=$((i+1))
    sleep 0.25
  done
  printf "\r✅ Applied!               \n"
}

apply_setting() {
  TYPE=$1
  CMD=$2
  echo "⚙️  Setting $TYPE..."
  sh -c "$CMD" &
  spinner $!
  echo
}

# === BASE GPU DRIVER SETTINGS ===
apply_setting "GLOBAL DRIVER ENABLE" "settings put global updatable_driver_all_apps 1"
apply_setting "GAME DRIVER (Production)" "settings put global updatable_driver_production_opt_in_apps \"$PACKAGES\""
apply_setting "SYSTEM DRIVER (All Apps)" "settings put system updatable_driver_all_apps 1"
apply_setting "SECURE DRIVER (All Apps)" "settings put secure updatable_driver_all_apps 1"

# === EXTENDED DRIVER CONTROLS ===
echo "🧩 Applying Extended Game Driver Controls..."
sleep 1

# Default / Reset
apply_setting "Default / Reset" "settings delete global game_driver_opt_in_apps"
apply_setting "Default / Reset" "settings put global game_driver_opt_in_apps \"$PACKAGES\""

# Game Driver
apply_setting "Game Driver" "settings delete global updatable_driver_production_opt_in_apps"
apply_setting "Game Driver" "settings put global updatable_driver_production_opt_in_apps \"$PACKAGES\""

# System Driver
apply_setting "System Driver" "settings delete global updatable_driver_production_opt_out_apps"
apply_setting "System Driver" "settings put global updatable_driver_production_opt_out_apps \"$PACKAGES\""

# Developer Driver
apply_setting "Developer Driver" "settings delete global updatable_driver_prerelease_opt_in_apps"
apply_setting "Developer Driver" "settings put global updatable_driver_prerelease_opt_in_apps \"$PACKAGES\""

# === VERIFY SETTINGS ===
echo "🔍 Verifying configuration..."
sleep 1
for TYPE in global system secure; do
  echo "📂 $TYPE:"
  settings get $TYPE updatable_driver_all_apps
  settings get $TYPE updatable_driver_production_opt_in_apps
  echo
done

echo "🎯 GPU driver configuration completed successfully."
echo "💡 If any command fails, grant permission with:"
echo "   adb shell pm grant me.piebridge.brevent android.permission.WRITE_SECURE_SETTINGS"
echo
echo "✅ Done | @Willy Project"