# Sonr Deploy iOS Script
#
# This script will deploy the latest version of the Sonr iOS app to the
# Apple App Store.
#
# This script requires the following environment variables to be set:
#
# APP_VERSION - Current version of the app
# GITHUB_TOKEN - GitHub token with repo permissions
# MATCH_PASSWORD - Fastlane match password
# FASTLANE_USER - Fastlane username
# FASTLANE_PASSWORD - Fastlane password
# FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD - Fastlane apple application specific password
# FASTLANE_SESSION - Fastlane session
# MATCH_GIT_BASIC_AUTHORIZATION - Base64 Fastlane match git basic authorization
# GOOGLE_SERVICE_INFO_PLIST - Encoded GoogleService-Info.plist Data
echo "🔷 Deploying iOS..."
SCRIPTDIR=$(dirname "$0")

echo "Setting Paths..."
cd ${SCRIPTDIR}/../../
PROJECT_DIR=$(pwd)
IOS_DIR=${PROJECT_DIR}/ios
PLUGIN_DIR=${PROJECT_DIR}/plugin/ios/Frameworks
echo "Done."
echo "\n"

echo "Setup Project..."
gh release download --repo 'sonr-io/core' --pattern *_ios.zip --dir ${PLUGIN_DIR}
unzip ${PLUGIN_DIR}/*_ios.zip -d ${PLUGIN_DIR}
echo ${GOOGLE_SERVICE_INFO_PLIST} >> ${IOS_DIR}/GoogleService-Info.plist
cd ${IOS_DIR} && fastlane ios assemble
echo "Assembled!"

echo "\n"
echo "Building iOS..."
cd ${IOS_DIR} && fastlane ios build
echo "Built!"

echo "\n"
echo "Deploying iOS..."
cd ${IOS_DIR} && fastlane ios deploy_internal
echo "✅  Finished Deploying iOS"
