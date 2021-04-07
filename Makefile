SHELL=/bin/bash

xcodeproj:
	touch App/Resources/GoogleService-Info.plist
	osascript scripts/CloseXcode.applescript
	mint run swiftgen config run --config Resource/Core/swiftgen.yml
	mint run xcodegen

workspace: xcodeproj
	xed .

release: xcodeproj
	rm -f LocalPackages/UnityFramework.framework/Data/Raw/*
	bundle exec fastlane release

clean:
	rm vear.xcodeproj 
	rm vear.xcworkspace
	
images:
	go run scripts/make_store_image.go
	convert fastlane/metadata/app_icon.png -colorspace RGB fastlane/metadata/app_icon.png

videos:
	ffmpeg -i fastlane/screenshots/ja/master/preview.mov -s 886x1920 -r 30 -strict -2 fastlane/screenshots/ja/preview.mov

license:
	mint run LicensePlist license-plist --output-path App/Resources/Settings.bundle --package-path vear.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.swift

FLD = $(CURDIR)/App/Resources/Background
SRCS = $(wildcard $(FLD)/*.png)

background-thumbnail:
	mkdir -p .tmp
	@for filepath in $(SRCS); do\
		file=$$(basename -- $$filepath);\
		sips  -Z 512 -c 256 256 $$filepath -o .tmp/$$file;\
	done
	open .tmp