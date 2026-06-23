#!/bin/bash

set -e

# Автоопределение последнего релиза
REPO="Mekotofeuka/MTPR-FIX-By-MEKO"
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | head -1 | cut -d'"' -f4)

if [ -z "$LATEST_TAG" ]; then
    echo "Ошибка: не удалось определить последний релиз"
    exit 1
fi

SCRIPT_URL="https://raw.githubusercontent.com/$REPO/$LATEST_TAG/main.sh"
LOCAL_FILE="/opt/mtpr-simple/main.sh"
VERSION_FILE="/opt/mtpr-simple/version"

if [ "$(id -u)" -ne 0 ]; then
    echo "root only"
    exit 1
fi

mkdir -p /opt/mtpr-simple

rm -f "$LOCAL_FILE"

curl -fsSL "$SCRIPT_URL" -o "$LOCAL_FILE"

chmod +x "$LOCAL_FILE"

md5sum "$LOCAL_FILE" | awk '{print $1}' > "$VERSION_FILE"

ln -sf "$LOCAL_FILE" /usr/local/bin/mekopr

echo "OK updated"
exec "$LOCAL_FILE" </dev/tty
