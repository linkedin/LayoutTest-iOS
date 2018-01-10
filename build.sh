#!/bin/sh

instruments -s devices

set -o pipefail &&
time xcodebuild clean test \
    -project LayoutTest.xcodeproj \
    -scheme LayoutTest \
    -sdk iphonesimulator11.2 \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=11.2' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=11.2' \
| xcpretty

# Disabling tests on 8.4 for now, because they seem to fail because of simulator problems
# We should try to reenable in a few weeks once travis works out its problems
#    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \

