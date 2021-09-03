#!/bin/bash
echo "🔷 Cleaning Project..."
SCRIPTDIR=$(dirname "$0")

cd ${SCRIPTDIR}/../../
flutter clean
rm -rf build
rm -rf ios/build
find ios -name "*.zip" -type f -delete && find . -name "*.ipa" -type f -delete
find ios/fastlane -name "report.xml" -type f -delete
find android/fastlane -name "report.xml" -type f -delete
pub global activate cider
pub global activate protoc_plugin
pub global activate devtools
flutter pub get
echo "✅ Finished Cleaning ➡ `date`"
