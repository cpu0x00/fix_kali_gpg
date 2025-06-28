#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
KEYRING_PATH="/usr/share/keyrings/kali-archive-keyring.gpg"
KEY_URL="https://archive.kali.org/archive-keyring.gpg"
EXPECTED_SHA1="603374c107a90a69d983dbcb4d31e0d6eedfc325"
SOURCES_LIST="/etc/apt/sources.list"
BACKUP_SUFFIX=".bak"

# --- Root check ---
if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: This script must be run as root. Use sudo." >&2
  exit 1
fi

echo "[*] Downloading new Kali archive signing key..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$KEY_URL" -o "$KEYRING_PATH"
else
  wget -qO "$KEYRING_PATH" "$KEY_URL"
fi

echo "[*] Verifying SHA-1 checksum..."
actual_sha1=$(sha1sum "$KEYRING_PATH" | awk '{print $1}')
if [ "$actual_sha1" != "$EXPECTED_SHA1" ]; then
  echo "ERROR: Checksum mismatch (expected $EXPECTED_SHA1, got $actual_sha1)" >&2
  exit 1
fi

echo "[*] Backing up existing sources.list to ${SOURCES_LIST}${BACKUP_SUFFIX}..."
cp "$SOURCES_LIST" "${SOURCES_LIST}${BACKUP_SUFFIX}"

echo "[*] Commenting out old kali-rolling entries..."
sed -i '/^[[:space:]]*deb .*kali-rolling/ s/^/# /' "$SOURCES_LIST"

echo "[*] Appending signed-by entry to sources.list..."
if ! grep -q "signed-by=${KEYRING_PATH}" "$SOURCES_LIST"; then
  cat <<EOF >> "$SOURCES_LIST"

deb [signed-by=${KEYRING_PATH}] http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
EOF
fi

echo "[*] Updating APT package lists..."
apt update

echo "[+] All done! The NO_PUBKEY ED65462EC8D5E4C5 error should now be resolved."
