#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q filelight | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/filelight.png
export DESKTOP=/usr/share/applications/org.kde.filelight.desktop

# Deploy dependencies
quick-sharun /usr/bin/filelight

# TODO remove me once qml deployment is improved
for lib in $(find ./AppDir/lib/qt6/qml -type f -name '*.so*'); do
	ldd "$lib" | awk -F"[> ]" '{print $4}' | xargs -I {} cp -vn {} ./AppDir/lib || :
done

# Turn AppDir into AppImage
quick-sharun --make-appimage
