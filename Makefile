# Plugin Vars
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ios
BUILDANDROID=$(FLUTTER) build apk
CLEAN=$(FLUTTER) clean
PROJECT_DIR=/Users/prad/Sonr/app

# Lists Options
all: Makefile
	@echo 'Sonr App Module'
	@sed -n 's/^##//p' $<

## run       :   Run Mobile App in Debug Mode
run:
	cd $(PROJECT_DIR) && $(RUN)

## release   :   Run Mobile App for Release Mode
release:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
	cd $(PROJECT_DIR) && $(RUN) --release

## build     :   Builds IPA and APK
build:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS)
	cd $(PROJECT_DIR) && $(BUILDANDROID)

## clean     :   Cleans Project Cache and Build Folder
clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
