# Plugin Vars
FLUTTER=flutter
RUN=$(FLUTTER) run -d all
BUILDIOS=$(FLUTTER) build ios
BUILDANDROID=$(FLUTTER) build apk
CLEAN=$(FLUTTER) clean
PROJECT_DIR=/Users/prad/Sonr/app

run:
	cd $(PROJECT_DIR) && $(RUN)

build:
	@cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && $(BUILDIOS)
	cd $(PROJECT_DIR) && $(BUILDANDROID)

upgrade:
	

clean:
	cd $(PROJECT_DIR) && rm -rf build
	cd $(PROJECT_DIR) && $(CLEAN)
	cd $(PROJECT_DIR) && flutter pub get
