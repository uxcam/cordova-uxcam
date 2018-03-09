//
//  UXCam.h
//
//  Copyright (c) 2013-2018 UXCam Ltd. All rights reserved.
//
//  UXCam SDK VERSION: 2.5.17
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
*	UXCam SDK captures User experience data when a user uses an app, analyses this data on the cloud and provides insights to improve usability of the app.
*/
@interface UXCam : NSObject

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariant			This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
	@param multiSession			If YES (the default for other methods) then a new session is recorded each time the app comes to the foreground. If NO then a single session is recorded, when stopped (either programmatically with @b stopApplicationAndUploadData or by the app going to the background) then no more sessions are recorded until @b startWithKey is called again)
	@param sessionStartedBlock	This block will be called once the app settings have been checked against the UXCam server - the parameter will be TRUE if recording has started. @b NOTE @b: This block is captured and called each time a new session starts.
 */
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(nullable NSString*)appVariant
	 multipleSessions:(BOOL)multiSession
	  completionBlock:(nullable void (^)(BOOL started))sessionStartedBlock;

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariant			This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
	@param sessionStartedBlock	This block will be called once the app settings have been checked against the UXCam server - the parameter will be TRUE if recording has started.  @b NOTE @b: This block is captured and called each time a new session starts.
*/
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(NSString* _Nullable)appVariant
	  completionBlock:(nullable void (^)(BOOL started))sessionStartedBlock;

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariant			This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
*/
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(nullable NSString*)appVariant;

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
*/
+ (void) startWithKey:(NSString*)userAPIKey;

/**
	Stops the UXCam application and sends captured data to the server.
	Use this to start sending the data on UXCam server without the app going into the background.
 
	@brief Stop the UXCam session and send data to the server
	@note This starts an asynchronous process and returns immediately.
*/
+ (void) stopApplicationAndUploadData;

/**
	Stops the UXCam application and sends captured data to the server.
	Use this to start sending the data on UXCam server without the app going into the background.

	@brief Stop the UXCam session and send data to the server

	@param block Code block to call once upload process completes - will be run on the main thread. There might still be sessions waiting for upload if there was a problem with uploading any of them

	@note This starts an asynchronous process and returns immediately.
 */
+ (void) stopApplicationAndUploadData:(nullable void (^)(void))block;

/**
	By default UXCam will end a session immediately when your app goes into the background. But if you are switching over to another app for authorisation, or some other short action, and want the session to continue when the user comes back to your app then call this method with a value of TRUE before switching away to the other app.
	UXCam will pause the current session as your app goes into the background and then continue the session when your app resumes. If your app doesn't resume within a couple of minutes the original session will be closed as normal and a new session will start when your app eventually is resumed.

	@brief Prevent a short trip to another app causing a break in a session
	@param continueSession Set to TRUE to continue the current session after a short trip out to another app. Default is FALSE - stop the session as soon as the app enters the background.
	@note The flag is reset after a trip to another app - so the next time the user leaves your app the session will be closed unless you call this method again with TRUE
 */
+ (void) allowShortBreakForAnotherApp:(BOOL)continueSession;

/**
	Starts a new session after the @link stopApplicationAndUploadData @/link method has been called.
	This happens automatically when the app returns from background.
 
	@note Any completion block registered during startWithKey: will be called as the session starts
*/
+ (void) restartSession;

/**
	Cancels the recording of the current session and discards the data
 
	@note A new session will start as normal when the app nexts come out of the background (depending on the state of the MultiSessionRecord flag), or if you call @link restartSession @/link
*/
+ (void) cancelCurrentSession;

/**
	Set whether to record multiple sessions or not
 
	@param recordMultipleSessions YES to record a new session automatically when the device comes out of the background. If NO then a single session is recorded, when stopped (either programmatically with @b stopApplicationAndUploadData or by the app going to the background) then no more sessions are recorded until @b startWithKey is called again).
	@note The default setting is to record a new session each time a device comes out of the background. This flag can be set to NO to stop that. You can also set this with the appropriate startWithKey: variant. (This will be reset each time startWithKey is called)
*/
+ (void) SetMultiSessionRecord:(BOOL)recordMultipleSessions;

/**
	Get whether UXCam is set to automatically record a new session when the app resumes from the background
*/
+ (BOOL) GetMultiSessionRecord;


/**
	When called the NSLog output (stderr) will be redirected to a file and uploaded with the session details
	@note There will be no console output while debugging after calling this
*/
+ (void) CaptureLogOutput;

/**
 *  @brief Call this before calling startWithKey to disable UXCam from capturing sessions that crash
 *
 *  @param disable YES to disable crash capture
 *  @note By default crashhandling is enabled
 */
+ (void) DisableCrashHandling:(BOOL)disable;

/**
 * @brief Returns how many sessions are waiting to be uploaded
 *
 * Sessions can be in the Pending state if UXCam was unable to upload them at the end of the last session. Normally they will be sent at the end of the next session.
 */
+ (NSUInteger) PendingUploads;

/**
 * @brief Begins upload of any pending sessions
 *
 * @param block Code block to call once upload process completes - will be run on the main thread. There might still be sessions waiting for upload if there was a problem with uploading any of them
 *
 * @note Advanced use only. This is not needed for most developers. This can't be called until UXCam startWithKey: has completed
 */
+ (void) UploadingPendingSessions:(nullable void (^)(void))block;

/**
	Returns the current recording status

	@return YES if the session is being recorded
*/
+ (BOOL) isRecording;

/**
	Hide a view that contains sensitive information or that you do not want recording on the screen video.

	@param sensitiveView The view to occlude in the screen recording
*/
+ (void) occludeSensitiveView:(UIView*)sensitiveView;

/**
	Hide / un-hide the whole screen from the recording
 
	@note Call this when you want to hide the whole screen from being recorded - useful in situations where you don't have access to the exact view to occlude
	Once turned on with a TRUE parameter it will continue to hide the screen until called with FALSE
 
	@param hideScreen Set TRUE to hide the screen from the recording, FALSE to start recording the screen contents again
*/
+ (void) occludeSensitiveScreen:(BOOL)hideScreen;

/***
	Hide / un-hide all UITextField views on the screen
 
	@note Call this when you want to hide the contents of all UITextFields from the screen capture. Default is NO.
 
	@param occludeAll Set YES to hide all UITextField views on the screen in the recording, NO to stop occluding them from the screen recording.
 */
+ (void) occludeAllTextFields:(BOOL)occludeAll;

/**
	Enable / disable the automatic tagging of screen names
	
	@note By default UXCam will tag new screen names automatically. You can override this using the tagScreenName: method or use this method to disable the automatic tagging.
 
	@param enable Set to TRUE to enable automatic screen name tagging (the default) or FALSE to disable it
 
 */
+ (void) SetAutomaticScreenNameTagging:(BOOL)enable;

/**
	UXCam normally captures the view controller name automatically but in cases where it this is not sufficient (such as in OpenGL applications)
	or where you would like to set a different unique name, use this function to set the name.
 
	@note call this in [UIViewController viewDidAppear:] after the call to [super ...] or automatic screen name tagging will override your value

	@param screenName Name to apply to the current screen in the session video
*/
+ (void) tagScreenName:(NSString*)screenName;

/**
	UXCam uses a unique number to tag a device.
	You can tag a device allowing you to search for it on the dashboard and review their sessions further.

	@param userName Name to apply to this user in this recording session
	@note Starting with SDK v2.5.11 there is no default for this value - to have the previous behaviour call [UXCam tagUsersName:UIDevice.currentDevice.name];
*/
+(void) tagUsersName:(NSString*)userName;

/**
	Insert a general tag into the timeline - stores the tag with the timestamp when it was added.

	@param tag A tag to attach to the session recording at the current time
*/
+ (void) addTag:(NSString*)tag;

/**
	Insert a general tag, with associated properties, into the timeline - stores the tag with the timestamp when it was added.
 
	@param tag A tag to attach to the session recording at the current time
	@param properties An NSDictionary of properties to associate with this tag 
 
	@note Only NSNumber and NSString property types are supported to a maxiumum count of 100 and maximum size per entry of 1KiB
 */
+ (void) addTag:(NSString*)tag withProperties:(nullable NSDictionary<NSString*, id>*)properties;

/**
	You can mark a session specifically if certain condition are met making them a good user for further testing.
	You can filter these sessions from the dashboard and perform further tests.

	@note This flag is cleared after each upload of data (ie. the close of the session)
 */
+ (void) markSessionAsFavorite;

/**
 *  Returns a URL path for showing all the current users sessions
 *
 *	@note This can be used for tying in the current user with other analytics systems
 *
 *  @return url path for user session or nil if no verified session is active
 */
+ (NSString*) urlForCurrentUser;

/**
 *  Returns a URL path that shows the current session when it compeletes
 *
 *	@note This can be used for tying in the current session with other analytics systems
 *
 *  @return url path for current session or nil if no verified session is active
 */
+ (NSString*) urlForCurrentSession;

/**
 *	Pauses the screen recording of the current session for the specified amount of time - specify 0 to pause indefinitely
 *
 *	@param pauseDuration Time (in seconds) to pause the screen, 0 for an indefinite pause
 *	@note If the current session completes while paused the remaining pause time will be cancelled
 */
+ (void) PauseScreenRecording:(NSTimeInterval)pauseDuration;

/**
 *	Resumes a paused session - will cancel any remaining pause time and resume screen recording
 */
+ (void) ResumeScreenRecording;


/**
 * [BETA] This is a workaround if you are having problems with stuttering scroll views in iOS11.2+
 * Default is FALSE, but set TRUE to stop UXCam screen recording scrolling views
 */
+ (void) StopRecordingScrollingOnStutterOS:(BOOL)stopScrollRecording;

#pragma mark - Deprecated methods - these will be removed on the next major version number update

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam application, ping the server, get the settings configurations and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param applicationKey The key to identify this application - find it in the UXCam dashboard for your application
 */
+ (void) startApplicationWithKey:(NSString*)applicationKey __attribute__((deprecated("from SDK 2.0.0 - use startWithKey: from now")));

/**
	You can mark a user specifically if certain condition are met making them a good user for further testing.
	You can then filter these users from the dashboard and perform further tests.
 
	@note This flag is cleared after each upload of data, so if you wish to mark a user as a favorite across multiple sesssions you will need to call this once in each session
 */
+ (void) markUserAsFavorite __attribute__((deprecated("from SDK 2.4.0 - use markSessionAsFavorite: from now functionality same, name is better")));

+ (void) tagUsersName:(NSString*)userName additionalData:(NSString*)additionalData __attribute__((deprecated("from SDK 2.4.0 - use tagUsersName: without the additionalData: paramater (which was never used)")));

/**
	Overrides any attempt to record the camera video that the application settings ask for.
 
	@note You should call this if you application makes use of either device camera and might have the camera video settings enabled.
	Otherwise the UXCam video recordings can become corrupted as UXCam and your application contest the use of the camera data.
 */
+ (void) ignoreCameraVideoRecording __attribute__((deprecated("from SDK 2.5.6 - camera video recording hasn't been available for a long time so this has no use")));

@end

NS_ASSUME_NONNULL_END
