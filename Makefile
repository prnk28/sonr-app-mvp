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

## beta          :   Builds AppBundle/iOS Archive and Uploads to PlayStore/AppStore
beta:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS) --release
	@echo "Finished Building Sonr iOS ➡ " && date
	cd $(IOS_DIR) && fastlane beta
	@echo "Finished Uploading Sonr iOS to AppStore Connect ➡ " && date

	cd $(PROJECT_DIR) && $(BUILDANDROID) --release
	@echo "Finished Building Sonr Android ➡ " && date
	cd $(ANDROID_DIR) && fastlane beta
	@echo "Finished Uploading Sonr Android to AppStore Connect ➡ " && date

## ios           :   Builds IPA for iOS
ios:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS) --release
	cd $(IOS_ARCHIVE_DIR) && open .
# cd $(PROJECT_DIR) && $(BUILDIOS) --bundle-sksl-path $(SKL_FILE) --release

## android       :   Builds APK for Android
android:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDANDROID) --release
	cd $(ANDROID_ARCHIVE_DIR) && open .
# cd $(PROJECT_DIR) && $(BUILDANDROID) --bundle-sksl-path $(SKL_FILE) --release

## clean         :   Cleans Project Cache and Build Folder
clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
