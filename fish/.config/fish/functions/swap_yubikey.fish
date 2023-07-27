
# Swap Yubikey for currently plugged in one in GPG
#
function swap_yubikey -d "Swap registered Yubikey in GPP"
  gpg-connect-agent "scd serialno" "learn --force" /bye
end
