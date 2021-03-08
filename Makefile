# Plugin Vars
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ipa
BUILDANDROID=$(FLUTTER) build appbundle
CLEAN=$(FLUTTER) clean
IOS_DIR=/Users/prad/Sonr/app/ios
PROJECT_DIR=/Users/prad/Sonr/app
SKL_FILE=/Users/prad/Sonr/app/assets/animations/flutter_01.sksl.json

# Lists Options
all: Makefile
	@echo 'Sonr App Module'
	@sed -n 's/^##//p' $<

## run           :   Run Mobile App in Debug Mode
run:
	cd $(PROJECT_DIR) && $(RUN)

profile:
	cd $(PROJECT_DIR) && $(RUN) --profile --cache-sksl

## release       :   Run Mobile App for Release Mode
release:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && $(RUN) --release

## beta          :   Builds AppBundle/iOS Archive and Uploads
beta:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter build ios --release --no-codesign
	cd $(IOS_DIR) && fastlane beta

## build         :   Builds IPA for iOS and Android
build: build-ipa build-apk

## build-ipa     :   Builds IPA for iOS
build-ipa:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS) --release
	cd /Users/prad/Sonr/app/build/ios/archive/ && open .
# cd $(PROJECT_DIR) && $(BUILDIOS) --bundle-sksl-path $(SKL_FILE) --release

## build-apk     :   Builds APK for Android
build-apk:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID) --release
# cd $(PROJECT_DIR) && $(BUILDANDROID) --bundle-sksl-path $(SKL_FILE) --release

## clean         :   Cleans Project Cache and Build Folder
clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
