#!/bin/sh

#  ci_pre_xcodebuild.sh
#  UXCamFramework
#
#  Created by Ankit Karna on 08/08/2023.
#  Copyright © 2023 UXCam. All rights reserved.

set -e

DATE=$(date -u +'%Y%m%d')

cd $CI_WORKSPACE
PROJECT_FILE=UXCam/UXCamFramework.xcodeproj/project.pbxproj
INFOPLIST_FILE=UXCam/UXCam/Info.plist

BUILD_NUMBER=${DATE}
if [[ -n $CI_TAG ]];
then
    VERSION_NUMBER="${CI_TAG:1}" # Remove v from the version number
else
    OLD_VERSION=$(cat UXCam/UXCamFramework.xcodeproj/project.pbxproj | grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')
    NEW_VERSION=$(echo ${OLD_VERSION} | awk -F. -v OFS=. '{$NF += 1 ; print}')
    VERSION_NUMBER="${NEW_VERSION}-beta.${CI_BUILD_NUMBER}"
fi


echo "new version: ${VERSION_NUMBER} ---- build number: ${BUILD_NUMBER}"

# Update the MARKETING_VERSION and CURRENT_PROJECT_VERSION values in the project file
sed -i "" "s/CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $BUILD_NUMBER;/g" "$PROJECT_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER}" "$INFOPLIST_FILE"

sed -i "" "s/MARKETING_VERSION = .*/MARKETING_VERSION = $VERSION_NUMBER;/g" "$PROJECT_FILE"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${VERSION_NUMBER}" "$INFOPLIST_FILE"

