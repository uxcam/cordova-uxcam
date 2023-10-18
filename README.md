# Cordova UXCam plugin

## Release Notes ##

Version | Changes
--------|--------
3.6.2   | iOS SDK updated to v3.6.4 and Android SDK updated to v3.6.16
3.6.1   | iOS SDK updated to v3.6.4
3.6.0   | iOS SDK updated to v3.6.2 & Android SDK updated to v3.6.4
3.5.2   | <ul><li>UXCam session URL is returned after successful start on Android platform (Already available on iOS)</li><li>Fixed issue related to occlusion flickering on custom webview (iOS)</li><li>Fixed textfields not occluding properly (iOS)</li><li>Fixed memory level crash issue while recording video (iOS)</li><li>Updated Android SDK to 3.5.2 and iOS SDK to 3.5.1</li></ul> |
3.5.1   | iOS SDK updated to v3.4.3 & Android SDK updated to v3.4.4
3.4.3	| iOS SDK updated to v3.3.9 & Android SDK updated to v3.3.7
3.4.2	| iOS SDK updated to v3.3.3 & fix for ionic capacitor build issue.
3.4.1	| iOS SDK updated to v3.3.1 & Android SDK updated to v3.3.5
3.4.0	| iOS SDK updated to v3.3.0, android SDK updated to 3.3.4, added setPushNotificationToken, reportBugEvent API.
3.3.1	| iOS SDK updated to v3.2.6, fixed a problem with occludeAllTextViews call for iOS.
3.3.0	| iOS SDK updated to v3.2.4 and Android SDK to 3.3.0. Callback added in startWithKey after verfication complete, returns session url. Missing setUserProperty method added in ios wrapper
3.2.2	| Version bump to work around some publishing issues - same code as 3.2.1
3.2.1	| iOS SDK updated to v3.1.15 and Android SDK to 3.2.0. iOS occludeSensitiveViews functionality added for Cordova UIWebView & WKWebView (BETA)
3.1.2	| SDK updated to use Android v3.1.11 and iOS v3.1.9.
3.1.1	| SDK updated to use Android v3.1.8 and iOS v3.1.6. optIn, optOut, optStatus are deprecated and should be replaced with optInOverall, optOutOverall, optInOverallStatus.
3.1.0	| SDK updated to use Android v3.1.4 and iOS v3.1.3
3.0.0	| SDK updated to use Android v3.0.1 and iOS v3.0.3, SDK updated to use v3 beta version with all new APIs
2.3.7	| Updating Android and iOS SDKs to latest versions (MAR 2018)
2.3.6	| Updating Android SDK to latest versions (JAN 2017). setAutomaticScreenNameTagging API typo bug fixed
2.3.4	| Updating Android and iOS SDKs to latest versions (Nov 2016). Adds setAutomaticScreenNameTagging(bool enable) for iOS (does nothing on Android so far). Default is enabled.
2.3.3	| Updating Android and iOS SDKs to latest versions (Sep 2016)
2.3.2	| Updating Android and iOS SDKs to latest versions (Jul 2016)
2.3.1	| Updating README to reflect change in name with the new plugin registry
2.3.0	| Updated to iOS SDK 2.5.0 and Android SDK 2.1.9
2.2.1	| Moving to the new 'npm' plugin publishing system
2.2.0	| Updating to iOS SDK 2.1.0 - adds occludeSensitiveScreen and startWithKeyAndAppVariant methods
2.1.6	| Updating to Android SDK 2.0.4 fixing an issue on Android OS 5.0+
2.1.5	| Updating to iOS SDK 2.0.4 which fixes a bug with uploading icon images
2.1.4   | Updating to iOS SDK 2.0.2 which improves version reporting to the server
2.1.3   | Fixing some publishing problems with both SDKs
2.1.0   | Changes the startup call from startApplicationWithKey to startWithKey for consistency with native SDKs
2.0.1   | Native SDKs updated to versions 2.0.1 to fix some problems
2.0.0	| First full release

## Add UXCam plugin

STEP 1: INTEGRATE THE SDK WITH YOUR APP

    cordova plugin add cordova-uxcam

or

    phonegap plugin add cordova-uxcam

To remove the plugin:

    cordova/phonegap plugin remove cordova-uxcam

UXCam android SDK requires AndroidX; add this to your **config.xml** file

    <preference name="AndroidXEnabled" value="true" />

Supported platforms: android, ios

---

STEP 2: START UXCAM

Call the `startWithConfiguration` method when `deviceready` has fired to start the UXCam session:

#### `startWithConfiguration`

Starts the UXCam session
const configuration = {
    userAppKey: 'YOUR API KEY'
}
UXCam.startWithConfiguration(configuration);

Get your app key from the dashboard at www.uxcam.com

---

### Documentation

For other API calls see https://help.uxcam.com/hc/en-us/articles/360022226651-Tailor-For-Success

---

## Notes on Building a Plugin

To publish the project when you are happy with it: npm publish 'DIRECTORY NAME'

See also the helpful information
at: https://cordova.apache.org/announcements/2015/04/21/plugins-release-and-move-to-npm.html

