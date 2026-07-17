#!/bin/sh

set -e

cd "$CI_PRIMARY_REPOSITORY_PATH"

git clone https://github.com/flutter/flutter.git --depth 1 --branch stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

flutter precache --ios
flutter pub get

export HOMEBREW_NO_AUTO_UPDATE=1
if ! command -v pod >/dev/null 2>&1; then
  brew install cocoapods
fi

cd ios
pod install
