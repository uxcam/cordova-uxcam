#!/bin/sh

#  ci_post_xcodebuild.sh
#  UXCamFramework
#
#  Created by Ankit Karna on 31/07/2023.
#  Copyright © 2023 UXCam. All rights reserved.

# Set the -e flag to stop running the script in case a command returns
# a nonzero exit code.
set -e

# Upload to demo app if specified branch changes
if [[ ( -n $CI_GIT_REF ) && ( -z $CI_PULL_REQUEST_NUMBER ) ]];
then
    ./upload_framework.sh
fi

