#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Wallep"
APP_BUNDLE="$DIR/$APP_NAME.app"
DMG_NAME="$APP_NAME.dmg"
DMG_PATH="$DIR/$DMG_NAME"
DMG_TMP="/tmp/${APP_NAME}_dmg_staging"

echo "🔨 Building Release binary for $APP_NAME..."
cd "$DIR/Wallep-macOS"
swift build -c release

RELEASE_BIN="$DIR/Wallep-macOS/.build/arm64-apple-macosx/release/wallep"
if [ ! -f "$RELEASE_BIN" ]; then
    RELEASE_BIN="$DIR/Wallep-macOS/.build/release/wallep"
fi

echo "📦 Creating macOS App Bundle ($APP_BUNDLE)..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy binary
cp "$RELEASE_BIN" "$APP_BUNDLE/Contents/MacOS/Wallep"
chmod +x "$APP_BUNDLE/Contents/MacOS/Wallep"

# Copy AppIcon.icns
cp "$DIR/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"

# Create Info.plist
cat <<EOF > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Wallep</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.wallep.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Wallep</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.6</string>
    <key>LSUIElement</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026 Wallep. MIT License.</string>
</dict>
</plist>
EOF

# Create PkgInfo
echo -n "APPL????" > "$APP_BUNDLE/Contents/PkgInfo"

# Ad-hoc codesign
codesign --force --deep --sign - "$APP_BUNDLE"

echo "💿 Creating .dmg installer image ($DMG_PATH)..."
rm -rf "$DMG_TMP" "$DMG_PATH"
mkdir -p "$DMG_TMP"

cp -R "$APP_BUNDLE" "$DMG_TMP/"
ln -s /Applications "$DMG_TMP/Applications"

hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_TMP" -ov -format UDZO "$DMG_PATH"
rm -rf "$DMG_TMP"

echo "✅ DMG Created Successfully at $DMG_PATH"
ls -lh "$DMG_PATH"
