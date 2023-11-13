#! /bin/bash

# Build the project

set -euo pipefail

xcodebuild archive -project "TimeMachineStatus.xcodeproj" \
    -scheme "TimeMachineStatus" \
    -configuration "Release" \
    -derivedDataPath "build" \
    -archivePath "build/TimeMachineStatus.xcarchive" \
    DEVELOPMENT_TEAM=$APPLE_TEAM_ID | xcpretty

codesign \
    --sign "$CODE_SIGN_IDENTITY" \
    -vvv --verbose --strict \
    --options=runtime \
    --prefix com.lukaspistrol.TimeMachineStatus \
    --force --deep --timestamp \
    "build/TimeMachineStatus.xcarchive/Products/Applications/TimeMachineStatus.app"

xcrun notarytool store-credentials TimeMachineStatus \
    --apple-id "$APPLE_ID" \
    --team-id "$APPLE_TEAM_ID" \
    --password "$APPLE_ID_PASSWORD"

create-dmg \
    --volname "TimeMachineStatus" \
    --volicon "build/TimeMachineStatus.xcarchive/Products/Applications/TimeMachineStatus.app/Contents/Resources/AppIcon.icns" \
    --window-pos 200 120 \
    --window-size 800 400 \
    --icon-size 100 \
    --icon "TimeMachineStatus.app" 200 190 \
    --hide-extension "TimeMachineStatus.app" \
    --app-drop-link 600 185 \
    --notarize "TimeMachineStatus" \
    --skip-jenkins \
    "build/TimeMachineStatus.dmg" \
    "build/TimeMachineStatus.xcarchive/Products/Applications/TimeMachineStatus.app"


