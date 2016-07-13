# UXCam iOS framwork

## Release Notes ##

v2.5.5	- Fixing a bug that caused video problems on iOS8

v2.5.4  - Improvements in gesture timeline
		- Improved capture of screen name at app start
		- Better handling of sensitive views after app comes out of background
		- Improved capture of crashed sessions

v2.5.3	- Don't occlude sensitive views that are hidden
		- Fixing the SessionURL path

v2.5.2	- Fixing a 3G/wifi upload issue
v2.5.1	- Improving upload code
v2.5.0	- Refactoring of sending multiple sessions in one upload

v2.4.2	- Fixing user session URL
v2.4.1	- Change in how user country is captured
v2.4.0	- First version working as a Swift module
		- Requires XCode7
		- iOS7 is no longer tested against/supported, but should continue working

v2.3.4	- Changing timer resets
v2.3.3	- Adding verbose internal logging to SDK
v2.3.1	- Internal improvements
v2.3.0	- Ability to record just one session per run


v2.2.2	- Trapping some crash handler errors
v2.2.1	- Fixing log capture when more than one session in a run
v2.2.0	- Adding log output capture and upload

v2.1.1	- Fixing documenation links
v2.1.0	- Adding app variant support to startUXCam methods
		- Exposing the occulde screen method to Cordova
		- Fixing session and user URLs

v2.0.3	- Handle the case of an app having no icon file
v2.0.2	- Fixing some version number values in the uploaded data
v2.0.1	- Removed unused data fields from uploaded data
v2.0.0	- Major re-engineering of the SDK in terms of backend used

