#!/bin/bash
echo "🔷 Deploying Mobile..."
SCRIPTDIR=$(dirname "$0")

echo "Setting Paths..."
cd ${SCRIPTDIR}/../../
PROJECT_DIR=$(pwd)
IOS_DIR=${PROJECT_DIR}/ios
ANDROID_DIR=${PROJECT_DIR}/android
APP_BUILD=`cider version | cut -d'+' -f 2`
APP_VERSION=`cider version | cut -d'+' -f 1`
echo "Done."
echo "\n"

echo "Setup Project..."
cd ${PROJECT_DIR}/${SCRIPTDIR} && sh tidy-project.sh
cd ${PROJECT_DIR}/${SCRIPTDIR} && sh update-plugin.sh
echo "Done."
echo "\n"

echo "Bumping Version..."
cd ${PROJECT_DIR} && cider bump build
cd ${IOS_DIR} && agvtool new-version -all ${APP_BUILD} && agvtool new-marketing-version ${APP_VERSION}
echo "Build: ${APP_BUILD}"
echo "Done."
echo "\n"

echo "Deploying iOS..."
cd ${PROJECT_DIR} && flutter build ios --release --no-codesign
cd ${IOS_DIR} && fastlane ios beta
echo "✅  Finished Deploying iOS ➡ " && date

echo "Deploying Android..."
cd ${PROJECT_DIR} && flutter build appbundle --release
cd ${ANDROID_DIR} && fastlane android internal
echo "✅  Finished Deploying Android ➡ " && date
