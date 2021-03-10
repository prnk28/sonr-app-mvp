# Plugin Vars
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ipa
BUILDANDROID=$(FLUTTER) build appbundle
CLEAN=$(FLUTTER) clean
ANDROID_DIR=/Users/prad/Sonr/app/android
IOS_DIR=/Users/prad/Sonr/app/ios
IOS_ARCHIVE_DIR=/Users/prad/Sonr/app/build/ios/archive/
ANDROID_ARCHIVE_DIR=/Users/prad/Sonr/app/build/app/outputs/bundle/release/
PROJECT_DIR=/Users/prad/Sonr/app
SKL_FILE=/Users/prad/Sonr/app/assets/animations/flutter_01.sksl.json

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
	cd $(PROJECT_DIR) && $(BUILDIOS) --release
	cd $(IOS_ARCHIVE_DIR) && open .
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo "Finished Building iOS ➡ " && date
# cd $(PROJECT_DIR) && $(BUILDIOS) --bundle-sksl-path $(SKL_FILE) --release

## └─ android         - APB for Android
build.android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID) --release
	cd $(ANDROID_ARCHIVE_DIR) && open .
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo "Finished Building Android ➡ " && date
# cd $(PROJECT_DIR) && $(BUILDANDROID) --bundle-sksl-path $(SKL_FILE) --release

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
	cd $(PROJECT_DIR) && $(BUILDIOS) --release
	@echo "Finished Building Sonr iOS ➡ " && date
	cd $(IOS_DIR) && fastlane beta
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo "Finished Uploading Sonr iOS to AppStore Connect ➡ " && date

## └─ android         - APB for PlayStore
deploy.android:
	cd $(PROJECT_DIR) && $(BUILDANDROID) --release
	@echo "Finished Building Sonr Android ➡ " && date
	cd $(ANDROID_DIR) && fastlane alpha
	@cd /System/Library/Sounds && afplay Glass.aiff
	@echo "Finished Uploading Sonr Android to AppStore Connect ➡ " && date

##
## [debug]       :   Run Mobile App in Debug Mode
debug:
	cd $(PROJECT_DIR) && $(RUN)

## [profile]     :   Run Mobile App for Profile Mode
profile:
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl

## [release]     :   Run Mobile App for Release Mode
release:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && $(RUN) --release

## [clean]       :   Cleans Project Cache and Build Folder
clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
