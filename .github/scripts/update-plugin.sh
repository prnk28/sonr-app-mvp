#!/bin/bash
echo "🔷 Updating Plugin..."
SCRIPTDIR=$(dirname "$0")

echo "Setting Paths..."
cd ${SCRIPTDIR}/../../../
ROOT_DIR=$(pwd)
PROJECT_DIR=${ROOT_DIR}/app
PLUGIN_DIR=${ROOT_DIR}/plugin
APP_PLUGIN_DIR=${PROJECT_DIR}/plugin
APP_IOS_FRAMEWORK=${APP_PLUGIN_DIR}/ios/Frameworks/Core.framework
APP_ANDROID_AAR=${APP_PLUGIN_DIR}/android/libs/io.sonr.core.aar
IOS_FRAMEWORK_DIR=${PLUGIN_DIR}/ios/Frameworks
IOS_FRAMEWORK=${IOS_FRAMEWORK_DIR}/Core.framework
ANDROID_AAR_DIR=${PLUGIN_DIR}/android/libs
ANDROID_AAR=${ANDROID_AAR_DIR}/io.sonr.core.aar
echo "Done."
echo "\n"

echo "Cleaning Project..."
cd ${PROJECT_DIR}/${SCRIPTDIR} && sh tidy-project.sh
rm -rf ${APP_IOS_FRAMEWORK}
rm -rf ${APP_ANDROID_AAR}
echo "Done."
echo "\n"

echo 'Updating Submodules...'
cd ${PLUGIN_DIR} && make update
cd ${PROJECT_DIR} && git submodule update --remote plugin
echo "Done."
echo "\n"

echo 'Copying Frameworks to App...'
cp -R ${IOS_FRAMEWORK} ${APP_IOS_FRAMEWORK}
cp -R ${ANDROID_AAR} ${APP_ANDROID_AAR}
echo "Done."
echo "\n"

echo 'Updating Packages...'
cd ${PROJECT_DIR} && flutter pub upgrade
echo "Done."
echo "\n"

echo "----"
echo "✅ Finished Updating Plugin ➡ `date`"
