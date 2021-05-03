SONR_ROOT_DIR=/Users/prad/Sonr # Set this to Folder of Sonr

# Project Dirs
PROJECT_DIR=/Users/prad/Sonr/app
ANDROID_DIR=/Users/prad/Sonr/app/android
IOS_DIR=/Users/prad/Sonr/app/ios

# Plugin Dirs
PLUGIN_DIR=/Users/prad/Sonr/app/plugin
PLUGIN_EXAMPLE_DIR=/Users/prad/Sonr/app/plugin/example

# Mobile Actions
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ios
BUILDANDROID=$(FLUTTER) build appbundle
BUILDIOS_SKL=$(FLUTTER) build ios --bundle-sksl-path $(SKL_FILE) --release
BUILDANDROID_SKL=$(FLUTTER) build appbundle --bundle-sksl-path $(SKL_FILE)
CLEAN=$(FLUTTER) clean

# Result Dirs/Files
IOS_ARCHIVE_DIR=/Users/prad/Sonr/app/build/ios/archive/
ANDROID_ARCHIVE_DIR=/Users/prad/Sonr/app/build/app/outputs/bundle/release/
SKL_FILE=/Users/prad/Sonr/app/assets/animations/flutter_01.sksl.json

# Lists Options
all: Makefile
	@figlet -f larry3d "Sonr Mobile"
	@sed -n 's/^##//p' $<

## build         :   Builds IPA and APB for Flutter Frontend Module
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
	cd $(PROJECT_DIR) && $(BUILDIOS) --bundle-sksl-path $(SKL_FILE) --release
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Building iOS ➡ " && date

## └─ android         - APB for Android
build.android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID) --bundle-sksl-path $(SKL_FILE)
	cd $(ANDROID_ARCHIVE_DIR) && open .
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Building Android ➡ " && date

## deploy        :   Builds AppBundle/iOS Archive and Uploads to PlayStore/AppStore
deploy: deploy.ios deploy.android
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
	cd $(PROJECT_DIR) && flutter clean && $(BUILDIOS)
	@echo "Finished Building Sonr iOS ➡ " && date
	cd $(IOS_DIR) && fastlane internal
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

## debug         :   Run Mobile App in Debug Mode
debug:
	cd $(PROJECT_DIR) && $(RUN)

## └─ clean           - Clean before running in Debug Mode
debug.clean: plugin.clean clean
	cd $(PROJECT_DIR) && $(RUN)


## plugin        :   Lists Options for Binded Proxy Plugin
plugin: Makefile
	@echo 'Plugin Options'
	@sed -n 's/^##//p' $<

## └─ run             - Runs the Plugin Example App in Debug Mode
plugin.run:
	cd $(PLUGIN_EXAMPLE_DIR) && $(CLEAN)
	cd $(PLUGIN_EXAMPLE_DIR) && $(RUN)

## └─ xcode           - Opens iOS Project in Xcode
plugin.xcode:
	cd /Users/prad/Sonr/plugin/example/ios && xed .

## └─ clean           - Cleans Plugin Project Directory
plugin.clean:
	cd $(PLUGIN_DIR) && $(CLEAN)
	cd $(PLUGIN_EXAMPLE_DIR) && $(CLEAN)
	cd $(PLUGIN_DIR) && flutter pub get
	cd $(PLUGIN_EXAMPLE_DIR) && flutter pub get


## push          :   Push Mobile and Plugin SubModule to Remote Repo
push: push.plugin push.mobile
	cd $(PROJECT_DIR) && git submodule update --remote
	@cd /System/Library/Sounds && afplay Hero.aiff

## └─ mobile          - Push Mobile App Repo to Git Remote
push.mobile:
	cd $(PROJECT_DIR) && flutter clean
	cd $(PROJECT_DIR) && git add . && git commit -m 'Updated Plugin Project' && git push
	cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Pushing Mobile ➡ " && date

## └─ plugin          - Push Plugin Repo to Git Remote
push.plugin:
	cd $(PLUGIN_DIR) && flutter clean
	cd $(PLUGIN_DIR) && git add . && git commit -m 'Updated Plugin Project' && git push
	cd $(PLUGIN_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Pushing Plugin ➡ " && date

##
## [profile]     :   Run Mobile App for Profile Mode
profile:
	cd $(PROJECT_DIR) && cider bump build
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl --write-sksl-on-exit $(SKL_FILE)

## [release]     :   Run Mobile App for Release Mode
release:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && $(RUN) --release

## [clean]       :   Cleans Project Cache and Build Folder
clean:
	@echo 'Cleaning Builds'
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	@echo 'Cleaning iOS Fastlane Cache'
	@cd $(PROJECT_DIR)/ios && find . -name "*.zip" -type f -delete && find . -name "*.ipa" -type f -delete
	@cd $(PROJECT_DIR)/ios/fastlane && find . -name "report.xml" -type f -delete
	@cd $(PROJECT_DIR)/android/fastlane && find . -name "report.xml" -type f -delete
	cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Cleaning Sonr Mobile Frontend ➡ " && date

