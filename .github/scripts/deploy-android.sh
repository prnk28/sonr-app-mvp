# Sonr Deploy Android Script
#
# This script will deploy the latest version of the Sonr Android app to the
# Google Play Store.
#
# This script requires the following environment variables to be set:
#
# APP_VERSION - Current version of the app
# GITHUB_TOKEN - Github token with repo permissions
# ANDROID_KEYSTORE_PASSWORD - Keystore password
# ANDROID_KEYSTORE - Base64 encoded keystore
# ANDROID_PLAYSTORE_CONFIG - Base64 encoded playstore config
# GOOGLE_SERVICES_JSON - Base64 encoded Google Service Info JSON
echo "🟢 Deploying Android..."
SCRIPTDIR=$(dirname "$0")

echo "Setting Paths..."
cd ${SCRIPTDIR}/../../
PROJECT_DIR=$(pwd)
ANDROID_DIR=${PROJECT_DIR}/android
PLUGIN_DIR=${PROJECT_DIR}/plugin/android/libs
echo "Done."
echo "\n"

echo "Setup Project..."
gh release download --repo 'sonr-io/core' --pattern *_android.zip --dir ${PLUGIN_DIR}
unzip ${PLUGIN_DIR}/*_android.zip -d ${PLUGIN_DIR}
echo ${GOOGLE_SERVICES_JSON} >> ${ANDROID_DIR}/google-services.json
cd ${ANDROID_DIR} && fastlane android assemble
echo "Assembled!"

echo "\n"
echo "Building Android..."
cd ${ANDROID_DIR} && fastlane android build
echo "Built!"

echo "\n"
echo "Deploying Android..."
cd ${ANDROID_DIR} && fastlane android deploy_internal
echo "✅  Finished Deploying Android"
