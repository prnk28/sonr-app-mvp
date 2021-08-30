SONR_ROOT_DIR=/Users/prad/Sonr # Set this to Folder of Sonr

# Project Dirs
PROJECT_DIR=/Users/prad/Sonr/app
ANDROID_DIR=/Users/prad/Sonr/app/android
IOS_DIR=/Users/prad/Sonr/app/ios

# Mobile Actions
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ios --release --no-codesign
BUILDANDROID=$(FLUTTER) build appbundle --release
BUILDIOS_SKL=$(FLUTTER) build ios --bundle-sksl-path $(SKL_FILE) --release --no-codesign
BUILDANDROID_SKL=$(FLUTTER) build appbundle --bundle-sksl-path $(SKL_FILE) --release
CLEAN=$(FLUTTER) clean

# Result Dirs/Files
IOS_ARCHIVE_DIR=/Users/prad/Sonr/app/build/ios/archive/
ANDROID_ARCHIVE_DIR=/Users/prad/Sonr/app/build/app/outputs/bundle/release/
SKL_FILE=/Users/prad/Sonr/app/assets/data/flutter_01.sksl.json

# References
PLUGIN_DIR=/Users/prad/Sonr/plugin
IOS_FRAMEWORK_DIR=${PLUGIN_DIR}/ios/Frameworks
IOS_FRAMEWORK=${IOS_FRAMEWORK_DIR}/Core.framework
ANDROID_AAR_DIR=${PLUGIN_DIR}/android/libs
ANDROID_AAR=${ANDROID_AAR_DIR}/io.sonr.core.aar

# App References
APP_PLUGIN_DIR="/Users/prad/Sonr/app/plugin"
APP_IOS_FRAMEWORK=${APP_PLUGIN_DIR}/ios/Frameworks/Core.framework
APP_ANDROID_AAR=${APP_PLUGIN_DIR}/android/libs/io.sonr.core.aar

# Lists Options
all: Makefile
	@figlet -f larry3d "Sonr App"
	@echo ""
	@sed -n 's/^##//p' $<

## build         :   Builds IPA and APB for Sonr App
build: build.ios build.android
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo ""
	@echo ""
	@echo "------------------------------------------------------------------"
	@echo "-------- ✅ ✅ ✅   FINISHED FLUTTER BUILD  ✅ ✅ ✅  --------------"
	@echo "------------------------------------------------------------------"

## └─ ios             - IPA for iOS
build.ios:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS)
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building iOS ➡ " && date

## └─ android         - APB for Android
build.android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID)
	cd android && fastlane internal
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building Android ➡ " && date

## build-skl     :   Builds IPA and APB for Sonr App with SKL Embedding
build-skl: build-skl.ios build.android
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo ""
	@echo ""
	@echo "------------------------------------------------------------------"
	@echo "-------- ✅ ✅ ✅   FINISHED FLUTTER BUILD  ✅ ✅ ✅  --------------"
	@echo "------------------------------------------------------------------"

## └─ ios             - IPA for iOS with SKL Embedding
build-skl.ios:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS_SKL)
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building iOS ➡ " && date

## └─ android         - APB for Android with SKL Embedding
build-skl.android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID_SKL)
	cd android && fastlane internal
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building Android ➡ " && date

## deploy        :   Builds AppBundle/iOS Archive and Uploads to PlayStore/AppStore
deploy: fetch deploy.ios deploy.android
	@echo 'Cleaning Builds'
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	@echo 'Cleaning iOS Fastlane Cache'
	@cd $(PROJECT_DIR)/ios && find . -name "*.zip" -type f -delete && find . -name "*.ipa" -type f -delete
	@cd $(PROJECT_DIR)/ios/fastlane && find . -name "report.xml" -type f -delete
	@cd $(PROJECT_DIR)/android/fastlane && find . -name "report.xml" -type f -delete
	@cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo ""
	@echo ""
	@echo "--------------------------------------------------------------"
	@echo "-------- ✅ ✅ ✅   FINISHED DEPLOYING  ✅ ✅ ✅  --------------"
	@echo "--------------------------------------------------------------"

## └─ ios             - IPA for AppStore Connect
deploy.ios:
	cd $(PROJECT_DIR) && cider bump build
#cd $(PROJECT_DIR) && flutter clean && $(BUILDIOS)
	@echo "Finished Building Sonr iOS ➡ " && date
	cd $(IOS_DIR) && fastlane ios beta
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Uploading Sonr iOS to AppStore Connect ➡ " && date

## └─ android         - APB for PlayStore
deploy.android:
	cd $(PROJECT_DIR) && cider bump build
	cd $(PROJECT_DIR) && flutter clean && $(BUILDANDROID)
	@echo "Finished Building Sonr Android ➡ " && date
	cd $(ANDROID_DIR) && fastlane android internal
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Uploading Sonr Android to PlayStore ➡ " && date

##
## [fetch]        :   Fetch latest version of frameworks
fetch:
	@echo "🔹 Fetching Sonr Frameworks"
	@echo '	1. Setup Directories...'
	@rm -rf ${IOS_FRAMEWORK_DIR}
	@rm -rf ${ANDROID_AAR_DIR}
	@mkdir -p ${IOS_FRAMEWORK_DIR}
	@mkdir -p ${ANDROID_AAR_DIR}
	@echo '	2. Fetching Frameworks...'
	@gh release download --repo 'sonr-io/core' --pattern *_android.zip --dir ${ANDROID_AAR_DIR}
	@gh release download --repo 'sonr-io/core' --pattern *_ios.zip --dir ${IOS_FRAMEWORK_DIR}
	@echo '	3. Unzipping Frameworks...'
	@unzip ${ANDROID_AAR_DIR}/*_android.zip -d ${ANDROID_AAR_DIR}
	@unzip ${IOS_FRAMEWORK_DIR}/*_ios.zip -d ${IOS_FRAMEWORK_DIR}
	@echo '	4. Cleaning Up...'
	@cd ${ANDROID_AAR_DIR} && find . -name "*.zip" -type f -delete
	@cd ${IOS_FRAMEWORK_DIR} && find . -name "*.zip" -type f -delete
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo '✅ Done!'

## [profile]     :   Run App for Profiling and Save SKSL File
profile:
	@echo '-----------------------------------------------'
	@echo 'Hit Shift+M during Run to Save Profiling Result'
	@echo '-----------------------------------------------'
	@echo ''
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl

## [update]      :   Fetch Plugin Submodule, and Upgrade Dependencies
update:
	@echo '🔹 Cleaning Project...'
	@cd $(PROJECT_DIR) && rm -rf build
	@cd $(PROJECT_DIR) && $(CLEAN)
	@rm -rf $(APP_IOS_FRAMEWORK)
	@rm -rf $(APP_ANDROID_AAR)
	@echo '🔹 Updating Submodules...'
	@cd $(PLUGIN_DIR) && make update
	@cd $(PROJECT_DIR) && git submodule update --remote plugin
	@echo '🔹 Copying Frameworks to App...'
	@cp -R ${IOS_FRAMEWORK} ${APP_IOS_FRAMEWORK}
	@cp -R ${ANDROID_AAR} ${APP_ANDROID_AAR}
	@echo '🔹 Fetch Packages...'
	@cd $(PROJECT_DIR) && flutter pub upgrade
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo "✅ Finished Updating Binary ➡ " && date

## [clean]       :   Cleans App Build Cache
clean:
	@echo '-- Removing Build Folders --'
	@cd $(PROJECT_DIR) && rm -rf build
	@cd $(PROJECT_DIR) && rm -rf dist
	@echo '-- Cleaning Flutter --'
	cd $(PROJECT_DIR) && git submodule foreach --recursive git reset --hard
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	pub global activate cider
	pub global activate protoc_plugin
	pub global activate devtools
