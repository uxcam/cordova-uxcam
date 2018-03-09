# UXCam iOS framework

## Release Notes ##

Version | Changes
------- | ----------
2.5.17	| Fixing a problem with tag collection from multiple threads
		| Fixing memory leaks when recording screens with video content
2.5.16	| Fixing a 2.5.15 introduced bug with network reachability
2.5.15	| Fixing some more iOS11 warnings about documentation in UXCam.h
		| Problems when recording iPad apps in split mode have been fixed
		| [BETA] `allowShortBreakForAnotherApp` method - will pause the recording while the user goes out to another.
		| [BETA] `StopRecordingScrollingOnStutterOS` method to work around iOS11.2 problems
2.5.14	| Fixing a warning in iOS11
2.5.13	| Adjusting the occlusion of views during animations
2.5.12	| Adjusting the occlusion of secure and/or UITextFields to be less sensitive to screen construction order
2.5.11	| Removed the default setting of `tagUsersName` from UIDevice.currentDevice.name - there is no default now
2.5.10	| Fixing a problem with screen names not being registered if no events occured on that screen
2.5.9	| Adding `occludeAllTextFields` method
		| Adding `SetMultiSessionRecord` and `GetMultiSessionRecord` methods
		| Adding `PauseScreenRecording` and `ResumeScreenRecording` methods
		| Adding `cancelCurrentSession` method
		| Restoring the `DisableCrashHandling` method
		| Adding method to access sessions awaiting upload. See `PendingUploads` for information
		| Adding method to upload any pending sessions. See `UploadingPendingSessions` for details
		| Improved occlusion of sensitive views in a moving scrollview
2.5.8	| Trapping nil value for screen name that would cause a crash 
		| Adding `SetAutomaticScreenNameTagging` to disable automatic screen name capture
2.5.7	| Capturing app version as well as build number for dashboard
2.5.6	| Fixing a problem with capturing Swift crashes
		| Fixing a problem with `NSCameraUsageDescription` when submitting apps from XCode8
		| Adding support for more quality settings
		| Optimising some code paths
2.5.5	| Fixing a bug that caused video problems on iOS8
2.5.4	| Improvements in gesture timeline
		| Improved capture of screen name at app start
		| Better handling of sensitive views after app comes out of background
		| Improved capture of crashed sessions
2.5.3	| Don't occlude sensitive views that are hidden
		| Fixing the `SessionURL` path
2.5.2	| Fixing a 3G/wifi upload issue
2.5.1	| Improving upload code
2.5.0	| Refactoring of sending multiple sessions in one upload
2.4.2	| Fixing user session URL
2.4.1	| Change in how user country is captured
2.4.0	| First version working as a Swift module
		| Requires XCode7
		| iOS7 is no longer tested against/supported, but should continue working
2.3.4	| Changing timer resets
2.3.3	| Adding verbose internal logging to SDK
2.3.1	| Internal improvements
2.3.0	| Ability to record just one session per run
2.2.2	| Trapping some crash handler errors
2.2.1	| Fixing log capture when more than one session in a run
2.2.0	| Adding log output capture and upload
2.1.1	| Fixing documenation links
2.1.0	| Adding app variant support to `startUXCam` methods
		| Exposing the occulde screen method to Cordova
		| Fixing session and user URLs
2.0.3	| Handle the case of an app having no icon file
2.0.2	| Fixing some version number values in the uploaded data
2.0.1	| Removed unused data fields from uploaded data
2.0.0	| Major re-engineering of the SDK in terms of backend used


