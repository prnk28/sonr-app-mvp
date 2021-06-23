SONR_ROOT_DIR=/Users/prad/Sonr # Set this to Folder of Sonr

# Project Dirs
PROJECT_DIR=/Users/prad/Sonr/app
ANDROID_DIR=/Users/prad/Sonr/app/android
IOS_DIR=/Users/prad/Sonr/app/ios

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
## [profile]     :   Run App for Profiling and Save SKSL File
profile:
	@echo 'Hit Shift+M during Run to Save Profiling Result'
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl

## [update]      :   Fetch Plugin Submodule, and Upgrade Dependencies
update:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd %(PROJECT_DIR) && git submodule update --remote plugin
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && flutter pub upgrade
	cd $(PROJECT_DIR) && $(RUN) --release
