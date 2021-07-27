SONR_ROOT_DIR=/Users/prad/Sonr # Set this to Folder of Sonr

# Project Dirs
PROJECT_DIR=/Users/prad/Sonr/app
ANDROID_DIR=/Users/prad/Sonr/app/android
IOS_DIR=/Users/prad/Sonr/app/ios
DESK_BUILD_DIR=/Users/prad/Sonr/app/go/build
PLUGIN_DIR=/Users/prad/Sonr/plugin

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

# References
PLUGIN_VERSION=`cd $(PLUGIN_DIR) && cider version`
COMMIT_MESSAGE="Updated Core Binary to ${PLUGIN_VERSION}"

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
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building iOS ➡ " && date

## └─ android         - APB for Android
build.android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID) --bundle-sksl-path $(SKL_FILE)
	cd $(ANDROID_ARCHIVE_DIR) && open .
	@echo '--------------------------------------------------'
	@echo "✅ Finished Building Android ➡ " && date

##
## [profile]     :   Run App for Profiling and Save SKSL File
profile:
	@echo '-----------------------------------------------'
	@echo 'Hit Shift+M during Run to Save Profiling Result'
	@echo '-----------------------------------------------'
	@echo ''
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl

## [update]      :   Fetch Plugin Submodule, and Upgrade Dependencies
update:
	@echo '🔹 Bumping Plugin Version...'
	@cd $(PLUGIN_DIR) && cider bump patch
	@cd $(PLUGIN_DIR) && git add . && git commit -m ${COMMIT_MESSAGE} && git push
	@echo '🔹 Cleaning Project...'
	@cd $(PROJECT_DIR) && rm -rf build
	@cd $(PROJECT_DIR) && $(CLEAN)
	@echo '🔹 Updating Submodules...'
	@cd $(PROJECT_DIR) && git submodule update --remote plugin
	@echo '🔹 Fetch Packages...'
	@cd $(PROJECT_DIR) && flutter pub upgrade
	@cd $(PROJECT_DIR) && flutter pub get
	@cd /System/Library/Sounds && afplay Hero.aiff
	@echo "✅ Finished Updating Binary ➡ " && date

## [clean]       :   Cleans App Build Cache
clean:
	@echo '-- Removing Build Folders --'
	cd $(PROJECT_DIR) && rm -rf build
	cd $(DESK_BUILD_DIR) && rm -rf outputs
	cd $(DESK_BUILD_DIR) && rm -rf intermediates
	@echo '-- Cleaning Flutter --'
	cd $(PROJECT_DIR) && git submodule foreach --recursive git reset --hard
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && hover clean-cache
	cd $(PROJECT_DIR) && flutter pub get
	pub global activate cider
	pub global activate protoc_plugin
	pub global activate devtools

##
##
## Shortcuts   : (b) => build                    |      (c) => clean
##               └─ (bi) => build.ios            |      (p) => profile
##               └─ (ba) => build.android        |      (u) => update
##
b:build
bi:build.ios
ba:build.android
p:profile
u:update
c:clean
