export SHELL := /bin/bash

CARTHAGE_DIR:=Carthage
BUILD_DIR:=build

# PHONY (non-file) Targets
# ------------------------
.PHONY: build clean help

# Common targets
# --------------
build: carthage app  ## Build everything

clean: ## Clean up make artifacts
	rm -rf $(BUILD_DIR)


# Carthage dependencies
# ---------------------
carthage: $(CARTHAGE_DIR)/.make ## Install or update carthage dependencies

$(CARTHAGE_DIR)/.make: Cartfile
	carthage update --platform mac
	touch $@


# Building Markoff.app with `xcodebuild`
# --------------------------------------
app: carthage $(BUILD_DIR)/Markoff.app

$(BUILD_DIR)/Markoff.app:
	xcodebuild build
	mv $(BUILD_DIR)/Release/Markoff.app $(BUILD_DIR)/Markoff.app


# Building Markoff.app DMG for release
# ------------------------------------
dmg: build $(BUILD_DIR)/Markoff.dmg

$(BUILD_DIR)/Markoff.dmg:
	mkdir -p $(BUILD_DIR)/tmp/
	cp -r $(BUILD_DIR)/Markoff.app $(BUILD_DIR)/tmp/
	cd $(BUILD_DIR)/tmp/ && hdiutil create -srcfolder . -volname Markoff ../Markoff.dmg
	rm -r $(BUILD_DIR)/tmp/




# `make help` -  see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# ------------------------------------------------------------------------------------
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
