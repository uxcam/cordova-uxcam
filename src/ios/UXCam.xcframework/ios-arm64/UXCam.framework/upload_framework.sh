#!/bin/sh

#  upload_framework.sh
#  UXCamFramework
#
#  Created by Ankit Karna on 07/08/2023.
#  Copyright © 2023 UXCam. All rights reserved.

set -e

echo "Moving to project file path"
cd $CI_WORKSPACE

FRAMEWORK_NAME="UXCam"
FMK_RAW="${FRAMEWORK_NAME}.xcframework"
FMK_ZIP="${FMK_RAW}.zip"

FWK_RAW_LOCATION="${CI_WORKSPACE}/UXCam/Products/${FMK_RAW}"
FWK_LOCATION="${CI_WORKSPACE}/UXCam/Products/${FMK_ZIP}"

VERSION=$(cat UXCam/UXCamFramework.xcodeproj/project.pbxproj | grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')
BUILD_NUMBER=$(cat UXCam/UXCamFramework.xcodeproj/project.pbxproj | grep -m1 'CURRENT_PROJECT_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')

echo "current version: ${VERSION} ---- build number: ${BUILD_NUMBER}"

cd UXCam/UXCam/External
package_content=`cat Package.swift`
podspec_content=`cat UXCam.podspec`

#upload repo with new artifact configuration
cred="${GITHUB_USERNAME}:${GITHUB_TOKEN}"

# first argument - REPO_NAME
# second argument - SDK_LOCATION
upload_framework()
{
    REPO="https://${cred}@github.com/uxcam/$1.git"

    git config --global user.email "mobile@uxcam.com"
    git config --global user.name "UXCam"
    git config --global --add --bool push.autoSetupRemote true

    git clone --depth 1 --branch develop $REPO
    # Switch to other branch as Xcode cloud fails to push without checking out.
    # However it only pushes to develop branch
    git checkout -b main
    cd $2

    # Copy .xcframework and zip to appropriate location
    cp $FWK_LOCATION $FMK_RAW
    cp $FWK_LOCATION $FMK_ZIP

    CHECKSUM=$(./make_checksum.sh)
    FRAMEWORK_URL="https://raw.githubusercontent.com/uxcam/$1/${VERSION}/${FMK_ZIP}"

    echo "$package_content" | sed -e "s/__UXCAM_VERSION__/${VERSION}/" -e "s/__UXCAM_CHECKSUM__/${CHECKSUM}/" -e "s/__UXCAM_REPO_NAME__/$1/"  > Package.swift

    echo "$podspec_content" | sed -e "s/__UXCAM_VERSION__/${VERSION}/"  > UXCam.podspec

    # push to git
    git add .
    git commit -m "Release ${VERSION} @ ${BUILD_NUMBER}"
    git push origin develop
}

REPO_NAME='uxcam-demo-ios'

# Upload framework to demo app
upload_framework $REPO_NAME "./${REPO_NAME}/UXCamSDK"

# Upload framework to sdk if merged to main branch
if [[ $CI_BRANCH = 'master' ]];
then
    REPO_NAME='ios-objc-internal'

    upload_framework $REPO_NAME "./${REPO_NAME}"
fi
