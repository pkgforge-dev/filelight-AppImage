#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q filelight | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.kde.filelight.svg
export DESKTOP=/usr/share/applications/org.kde.filelight.desktop

# Deploy dependencies
quick-sharun /usr/bin/filelight

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
