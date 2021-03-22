SONR_ROOT_DIR=/Users/prad/Sonr # Set this to Folder of Sonr

# Project Dirs
PROJECT_DIR=/Users/prad/Sonr/mobile
ANDROID_DIR=/Users/prad/Sonr/mobile/android
IOS_DIR=/Users/prad/Sonr/mobile/ios

# Mobile Actions
FLUTTER=flutter
RUN_MOBILE=$(FLUTTER) run -d 00008020-000975662686002E && $(FLUTTER) run -d 0A031FDD4004M5 --suppress-analytics
RUN_DESKTOP=$(FLUTTER) run -d macos

BUILDIOS=$(FLUTTER) build ios
BUILDANDROID=$(FLUTTER) build appbundle
CLEAN=$(FLUTTER) clean

# Result Dirs/Files
IOS_ARCHIVE_DIR=/Users/prad/Sonr/mobile/build/ios/archive/
ANDROID_ARCHIVE_DIR=/Users/prad/Sonr/mobile/build/app/outputs/bundle/release/
SKL_FILE=/Users/prad/Sonr/mobile/assets/animations/flutter_01.sksl.json

# Lists Options
all: Makefile
	@echo '--- Sonr App Module Actions ---'
	@echo ''
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

##
## debug         :   Run App in Debug Mode to ALL Devices
debug: debug.mobile debug.desktop


## └─ mobile          - Run in Debug mode on Mobile Devices
debug.mobile:
	cd $(PROJECT_DIR) && cider bump build
	@echo '--------------------------------'
	@echo 'Press d after Launch to Continue'
	@echo '--------------------------------'
	cd $(PROJECT_DIR) && $(RUN_MOBILE)

## └─ desktop         - Run in Debug mode on Desktop Devices
debug.desktop:
	cd $(PROJECT_DIR) && cider bump build
	cd $(PROJECT_DIR) && $(RUN_DESKTOP)

##
## deploy        :   Builds AppBundle/iOS Archive and Uploads to PlayStore/AppStore
deploy: deploy.ios deploy.android
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo ""
	@echo ""
	@echo "--------------------------------------------------------------"
	@echo "-------- ✅ ✅ ✅   FINISHED DEPLOYING  ✅ ✅ ✅  --------------"
	@echo "--------------------------------------------------------------"

## └─ ios             - IPA for AppStore Connect
deploy.ios:
# --bundle-sksl-path $(SKL_FILE) --release
	cd $(PROJECT_DIR) && flutter clean && $(BUILDIOS)
	@echo "Finished Building Sonr iOS ➡ " && date
	cd $(IOS_DIR) && fastlane internal
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Uploading Sonr iOS to AppStore Connect ➡ " && date

## └─ android         - APB for PlayStore
deploy.android:
	cd $(PROJECT_DIR) && cider bump build
# --bundle-sksl-path $(SKL_FILE)
	cd $(PROJECT_DIR) && flutter clean && $(BUILDANDROID)
	@echo "Finished Building Sonr Android ➡ " && date
	cd $(ANDROID_DIR) && fastlane android internal
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Uploading Sonr Android to PlayStore ➡ " && date

##
## profile       :   Run App for Profile Mode on ALL Devices
profile: profile.mobile

## └─ mobile          - Run in Profile mode on Mobile Devices
profile.mobile:
	cd $(PROJECT_DIR) && cider bump build
	@echo '--------------------------------'
	@echo 'Press d after Launch to Continue'
	@echo '--------------------------------'
	cd $(PROJECT_DIR) && $(RUN_MOBILE) --profile --cache-sksl

## └─ desktop         - Run in Profile mode on Desktop Devices
profile.desktop:
	cd $(PROJECT_DIR) && cider bump build
	cd $(PROJECT_DIR) && $(RUN_DESKTOP) --profile --cache-sksl

##
## release       :   Run App for Release Mode on All Devices
release: relase.mobile release.desktop

## └─ mobile          - Run in Profile mode on Mobile Devices
release.mobile:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && cider bump build
	@echo '--------------------------------'
	@echo 'Press d after Launch to Continue'
	@echo '--------------------------------'
	cd $(PROJECT_DIR) && $(RUN_MOBILE) --release

## └─ desktop         - Run in Profile mode on Desktop Devices
release.desktop:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && cider bump build
	cd $(PROJECT_DIR) && $(RUN_DESKTOP) --release

##
## [clean]       :   Cleans Project Cache and Build Folder
clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	@cd $(PROJECT_DIR)/ios && find . -name "*.zip" -type f -delete && find . -name "*.ipa" -type f -delete
	@echo 'Cleaning iOS Fastlane Cache'
	cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Cleaning Sonr Mobile Frontend ➡ " && date

## [kill]        :   Kill Current DartVM Instances
kill:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	@cd $(PROJECT_DIR)/ios && find . -name "*.zip" -type f -delete && find . -name "*.ipa" -type f -delete
	@echo 'Cleaning iOS Fastlane Cache'
	cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo '--------------------------------------------------'
	@echo "Finished Cleaning Sonr Mobile Frontend ➡ " && date

