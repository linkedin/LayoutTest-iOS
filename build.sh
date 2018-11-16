#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -project LayoutTest.xcodeproj \
    -scheme LayoutTest \
    -sdk iphonesimulator12.1 \
    -destination 'platform=iOS Simulator,name=iPhone SE,OS=12.1' \
| xcpretty
