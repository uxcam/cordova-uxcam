
# Cordova UXCam plugin

## Release Notes ##

Version	   | Changes
-----------|--------
2.3.6	| Updating Android SDK to latest versions (JAN 2016). setAutomaticScreenNameTagging API typo bug fixed
2.3.4	| Updating Android and iOS SDKs to latest versions (Nov 2016). Adds setAutomaticScreenNameTagging(bool enable) for iOS (does nothing on Android so far). Default is enabled.
2.3.3	| Updating Android and iOS SDKs to latest versions (Sep 2016)
2.3.2	| Updating Android and iOS SDKs to latest versions (Jul 2016)
2.3.1	| Updating README to reflect change in name with the new plugin registry
2.3.0	| Updated to iOS SDK 2.5.0 and Android SDK 2.1.9
2.2.1	| Moving to the new 'npm' plugin publishing system
2.2.0	| Updating to iOS SDK 2.1.0 - adds occludeSensitiveScreen and startWithKeyAndAppVariant methods
2.1.6	| Updating to Android SDK 2.0.4 fixing an issue on Android OS 5.0+
2.1.5	| Updating to iOS SDK 2.0.4 which fixes a bug with uploading icon images
2.1.4	| Updating to iOS SDK 2.0.2 which improves version reporting to the server
2.1.3	| Fixing some publishing problems with both SDKs
2.1.0	| Changes the startup call from startApplicationWithKey to startWithKey for consistency with native SDKs
2.0.1	| Native SDKs updated to versions 2.0.1 to fix some problems
2.0.0	| First full release


## Add UXCam plugin

STEP 1: INTEGRATE  WITH PHONEGAP

    cordova plugin add cordova-uxcam

or

    phonegap plugin add cordova-uxcam
  

To remove the plugin: 

    cordova/phonegap plugin remove cordova-uxcam


Supported platforms: android, ios

---

STEP 2: START UXCAM

Call the startWithKey method on deviceready to start the UXCam session:

#### startWithKey
Starts the UXCam session

UXCam.startWithKey("API-key from https://www.uxcam.com to be placed here - this is your user account API key and is the same for all projects");

---

### OPTIONAL METHODS

#### startWithKeyAndAppVariant
Starts the UXCam session and sets a variant identifier for the app to differentiate builds of the same app on the dashboard.

UXCam.startWithKeyAndAppVariant("API-Key", "App variant identifier: appended to the bundle ID and app name in the dashboard");


#### stopApplicationAndUploadData 
Stops the UXCam application and sends captured data to the server. Use this to start sending the data on UXCam server without waiting for the app going into the background.

UXCam.stopApplicationAndUploadData();


#### stopUXCamCameraVideo
Stops the faceCamera video recording if your application uses camera 

UXCam.stopUXCamCameraVideo ();


#### tagScreenName
UXCam captures the view controller name automatically but in case where it doesn’t (such as in OpenGL) or you would like to set a different unique name, use this function.

UXCam.tagScreenName(“Screen Name”)
Parameters 
screenName: The name of the screen as required.


#### tagUsersName
UXCam uses a unique number to tag a device. You can tag a device allowing you to search for it on the dashboard and review their session further.

UXCam.tagUsersName(“User name”);
Parameters 
userName: The name of the tag of device


#### markUserAsFavorite
You can mark a user specifically if certain condition are met making them a good user for further testing. You can then filter these users and perform further test.

UXCam.markUserAsFavorite();


#### addTag
Insert a general tag into the timeline - stores the tag with the timestamp when it was added. 

UXCam.addTag(“Tag”);
Parameters 
Tag: The name of the tag

#### addTagWithProperties

Insert a general tag into the timeline - stores the tag with the timestamp when it was added, along with the properties to associate with this instance of the tag. 

UXCam.addTag(“Tag”, properties);
Parameters 
Tag: The name of the tag
Properties: The properties: key/value data where the value is a number or a string 

#### occludeSensitiveScreen
Hide / un-hide the screen from being recorded. Call once with 'true' to start hiding the screen and later with 'false' to record normal contents again.
Useful to hide sensitive entry fields that you would not want to record the contents of.

UXCam.occludeSensitiveScreen(bool hideScreen);

---

## Notes on Building a Plugin ##

If making a plugin like this, or trying to update the framework note that there are currently problems publishing cordova plugins that have iOS custom frameworks in them.

See the bug report: https://issues.apache.org/jira/browse/CB-6092 for details.

Work around: Pull your custom framework apart and put the library file directly in the Name.framework folder and have the headers in a 'Headers' sub-folder: you can't publish the symbolic links that are normal in frameworks.
Symptom: Project builds fine when testing plugin installed from a local folder or from a git URL - fails when installed by name from the plugin registry.

To publish the project when you are happy with it: npm publish 'DIRECTORY NAME'
See also the helpful information at: https://cordova.apache.org/announcements/2015/04/21/plugins-release-and-move-to-npm.html
-- 
