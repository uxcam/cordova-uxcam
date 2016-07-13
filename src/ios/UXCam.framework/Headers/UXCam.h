//
//  UXCam.h
//
//  Copyright (c) 2013-2016 UXCam Ltd. All rights reserved.
//
//  UXCam SDK VERSION: 2.5.4
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
*	UXCam SDK captures User experience data when a user uses an app, analyses this data on the cloud and provides insights to improve usability of the app.
*/
@interface UXCam : NSObject

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariantIdentifier This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
	@param multiSession			If YES (the default for other methods) then a new session is recorded each time the app comes to the foreground. IF NO then a single session is recorded, when stopped (either programmatically with @b stopApplicationAndUploadData or by the app going to the background) then no more sessions are recorded until @b startWithKey is called again)
	@param completiongBlock		This block will be called once the app settings have been checked against the UXCam server - the parameter will be TRUE if recording has started
 */
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(NSString*)appVariant
	 multipleSessions:(BOOL)multiSession
	  completionBlock:(void (^)(BOOL started))block;

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariantIdentifier This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
	@param completiongBlock		This block will be called once the app settings have been checked against the UXCam server - the parameter will be TRUE if recording has started
*/
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(NSString*)appVariant
	  completionBlock:(void (^)(BOOL started))block;

/**
	Call this method from applicationDidFinishLaunching to start UXCam recording your application's session.
	This will start the UXCam system, get the settings configurations from our server and start capturing the data according to the configuration.
 
	@brief Start the UXCam session
	@param userAPIKey			The key to identify your UXCam account - find it in the UXCam dashboard for your account at https://dashboard.uxcam.com/user/settings
	@param appVariantIdentifier This string is added to the app bundle ID and name to differentiate builds of the same app on the UXCam dashboard - useful for seperating Debug and Release builds - pass nil for default values
*/
+ (void) startWithKey:(NSString*)userAPIKey
 appVariantIdentifier:(NSString*)appVariant;

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
	Starts a new session after the @link stopApplicationAndUploadData @/link method has been called.
	This happens automatically when the app returns from background.
*/
+ (void) restartSession;

/**
	When called the NSLog output (stderr) will be redirected to a file and uploaded with the session details
	@note There will be no console output while debugging after calling this
*/
+ (void) CaptureLogOutput;

/**
	Returns the current recording status

	@return YES if the session is being recorded
*/
+ (BOOL) isRecording;

/**
	Overrides any attempt to record the camera video that the application settings ask for.
 
	@note You should call this if you application makes use of either device camera and might have the camera video settings enabled.
	Otherwise the UXCam video recordings can become corrupted as UXCam and your application contest the use of the camera data.
*/
+ (void) ignoreCameraVideoRecording;

/**
	Hide a view that contains sensitive information or that you do not want recording on the screen video.

	@param sensitiveView The view to occlude in the screen recording
*/
+ (void) occludeSensitiveView:(UIView *)sensitiveView;

/**
	Hide / un-hide the whole screen from the recording
 
	@note Call this when you want to hide the whole screen from being recorded - useful in situations where you don't have access to the exact view to occlude
	Once turned on with a TRUE parameter it will continue to hide the screen until called with FALSE
 
	@param hideScreen Set TRUE to hide the screen from the recording, FALSE to start recording the screen contents again
*/
+ (void) occludeSensitiveScreen:(BOOL)hideScreen;

/**
	UXCam normally captures the view controller name automatically but in cases where it this is not sufficient (such as in OpenGL applications)
	or where you would like to set a different unique name, use this function to set the name.

	@param screenName Name to apply to the current screen in the session video
*/
+ (void) tagScreenName:(NSString*)screenName;

/**
	UXCam uses a unique number to tag a device.
	You can tag a device allowing you to search for it on the dashboard and review their sessions further.

	@param username Name to apply to this user in this recording session
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
+ (void) addTag:(NSString*)tag withProperties:(NSDictionary*)properties;

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

#pragma mark - Deprecated methods - these will be removed on the next major version number update

/**
	You can set the precise location of a user.
*/
+ (void) setPreciseLocationLatitude:(double)latitude longitude:(double)longitude __attribute__((deprecated("from SDK 1.0.9")));

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

@end
