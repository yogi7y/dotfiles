#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/aerospace-devicehub.XXXXXX")"
base_commit=649301b2875b6eec23abda9b24bc765eecd37bf1

git clone --depth 1 --branch v0.21.2-Beta \
    https://github.com/nikitabobko/AeroSpace.git "$build_dir/source"
cd "$build_dir/source"
test "$(git rev-parse HEAD)" = "$base_commit"
git apply --check "$script_dir/patches/2272-devicehub-invalid-pid.patch"
git apply "$script_dir/patches/2272-devicehub-invalid-pid.patch"

swift test
swift build -c release --product aerospace
xcodebuild \
    -project xcode/AeroSpace.xcodeproj \
    -scheme AeroSpace \
    -configuration Release \
    -destination 'generic/platform=macOS' \
    -derivedDataPath "$build_dir/build" \
    CODE_SIGN_IDENTITY=- \
    CODE_SIGN_STYLE=Manual \
    MARKETING_VERSION=0.21.2-devicehub \
    build

app="$build_dir/build/Build/Products/Release/AeroSpace.app"
codesign --verify --deep --strict "$app"
printf '\nPatched app: %s\nMatching CLI: %s\n' \
    "$app" "$build_dir/source/.build/release/aerospace"
