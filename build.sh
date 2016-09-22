#!/bin/sh

set -o pipefail &&
time xcodebuild clean test \
    -project LayoutTest.xcodeproj \
    -scheme LayoutTest \
    -sdk iphonesimulator10.0 \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
# Disabling tests on 8.4 for now, because they seem to fail because of simulator problems
# We should try to reenable in a few weeks once travis works out its problems
#    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.0' \
| xcpretty

