#import "CDVUXCam.h"

#import <UXCam/UXCam.h>

@implementation CDVUXCam

+ (void)load
{
	// Set this early in the startup process so we can do extra Cordova related processing before the session startWithKey is called.
	[UXCam pluginType:@"cordova" version:@"3.4.3-beta.1"];
}

- (void)startWithKey:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    NSString* apiKey = command.arguments[0];

    if (apiKey.length > 0)
    {
        NSString* buildIdentifier = nil;
        if (command.arguments.count>1)
        {
            buildIdentifier = command.arguments[1];
            buildIdentifier = buildIdentifier.length>0 ? buildIdentifier : nil;
        }

        [UXCam startWithKey:apiKey buildIdentifier:buildIdentifier completionBlock:^(BOOL started) {
            if (started){
                NSString *url =  [UXCam urlForCurrentSession];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: url];
            }
            else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed to start uxcam session"];
            }

            [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
        }];

        return;
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid app key"];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)stopSessionAndUploadData:(CDVInvokedUrlCommand*)command
{
	[UXCam stopSessionAndUploadData];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)allowShortBreakForAnotherApp:(CDVInvokedUrlCommand*)command
{
	BOOL continueSession = [command.arguments[0] boolValue];
	[UXCam allowShortBreakForAnotherApp:continueSession];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)startNewSession:(CDVInvokedUrlCommand*)command
{
	[UXCam startNewSession];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)cancelCurrentSession:(CDVInvokedUrlCommand*)command
{
	[UXCam cancelCurrentSession];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)isRecording:(CDVInvokedUrlCommand*)command
{
	BOOL recordingStatus =  [UXCam isRecording];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:recordingStatus]
								callbackId:command.callbackId];
}


- (void)setMultiSessionRecord:(CDVInvokedUrlCommand*)command
{
	BOOL recordMultipleSessions = [command.arguments[0] boolValue];

	[UXCam setAutomaticScreenNameTagging:recordMultipleSessions];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)getMultiSessionRecord:(CDVInvokedUrlCommand*)command
{
	BOOL status =  [UXCam getMultiSessionRecord];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status]
								callbackId:command.callbackId];
}

- (void)pauseScreenRecording:(CDVInvokedUrlCommand*)command
{
	[UXCam pauseScreenRecording];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)resumeScreenRecording:(CDVInvokedUrlCommand*)command
{
	[UXCam resumeScreenRecording];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}


- (void)disableCrashHandling:(CDVInvokedUrlCommand*)command
{
	BOOL disable = [command.arguments[0] boolValue];
	[UXCam disableCrashHandling:disable];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)pendingUploads:(CDVInvokedUrlCommand*)command
{
	NSUInteger pendingCount =  [UXCam pendingUploads];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSUInteger:pendingCount]
								callbackId:command.callbackId];

}

- (void)deletePendingUploads:(CDVInvokedUrlCommand*)command
{
	[UXCam deletePendingUploads];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)pendingSessionCount:(CDVInvokedUrlCommand*)command
{
    NSUInteger count =  [UXCam pendingUploads];

    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSUInteger:count]
                                callbackId:command.callbackId];
}

- (void)uploadPendingSession:(CDVInvokedUrlCommand*)command
{
    [UXCam uploadingPendingSessions:^{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES]
        callbackId:command.callbackId];
    }];
}

- (void)occludeSensitiveScreen:(CDVInvokedUrlCommand*)command
{
	BOOL hideScreen = [command.arguments[0] boolValue];

	[UXCam occludeSensitiveScreen:hideScreen];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)occludeAllTextView:(CDVInvokedUrlCommand*)command
{
	BOOL hideScreen = [command.arguments[0] boolValue];

	[UXCam occludeAllTextFields:hideScreen];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)setAutomaticScreenNameTagging:(CDVInvokedUrlCommand*)command
{
	BOOL enable = [command.arguments[0] boolValue];

	[UXCam setAutomaticScreenNameTagging:enable];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)tagScreenName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* screenName = command.arguments[0];
	if (screenName.length>0)
	{
		[UXCam tagScreenName:screenName];

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserIdentity:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* userIdentity = command.arguments[0];
	if (userIdentity.length>0)
	{
		[UXCam setUserIdentity:userIdentity];

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)setUserProperty:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* userPropertyKey = command.arguments[0];
	NSString* userPropertyValue = command.arguments[1];
	if (userPropertyKey.length>0 && userPropertyValue.length>0)
	{
		[UXCam setUserProperty:userPropertyKey value:userPropertyValue];

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)logEvent:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* eventName = command.arguments[0];
	if (eventName.length>0)
	{
		[UXCam logEvent:eventName];

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logEventWithProperties:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* tag = command.arguments[0];
	NSDictionary* properties = command.arguments[1];

	if (tag.length>0 && [properties isKindOfClass:NSDictionary.class])
	{
		[UXCam logEvent:tag withProperties:properties];

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
	{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)urlForCurrentUser:(CDVInvokedUrlCommand*)command
{
	NSString *url =  [UXCam urlForCurrentUser];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url]
								callbackId:command.callbackId];

}

- (void)urlForCurrentSession:(CDVInvokedUrlCommand*)command
{
	NSString *url =  [UXCam urlForCurrentSession];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url]
								callbackId:command.callbackId];
}

- (void)optOutOverall:(CDVInvokedUrlCommand*)command
{
	[UXCam optOutOverall];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)optOutOfSchematicRecordings:(CDVInvokedUrlCommand*)command
{
	[UXCam optOutOfSchematicRecordings];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)optInOverall:(CDVInvokedUrlCommand*)command
{
	[UXCam optInOverall];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)optIntoSchematicRecordings:(CDVInvokedUrlCommand*)command
{
	[UXCam optIntoSchematicRecordings];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)optInOverallStatus:(CDVInvokedUrlCommand*)command
{
	BOOL status =  [UXCam optInOverallStatus];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status]
								callbackId:command.callbackId];
}

- (void)optInSchematicRecordingStatus:(CDVInvokedUrlCommand*)command
{
	BOOL status =  [UXCam optInSchematicRecordingStatus];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status]
								callbackId:command.callbackId];
}

- (void)optInStatus:(CDVInvokedUrlCommand*)command
{
	BOOL status =  [UXCam isRecording];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status]
								callbackId:command.callbackId];
}

- (void)optIn:(CDVInvokedUrlCommand*)command
{
	[UXCam optInOverall];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)optOut:(CDVInvokedUrlCommand*)command
{
    [UXCam optOutOverall];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                callbackId:command.callbackId];
}

- (void)occludeRectsOnNextFrame:(CDVInvokedUrlCommand*)command
{
	NSArray<NSArray<NSNumber*>*>* rectList = command.arguments[0];
	[UXCam occludeRectsOnNextFrame:rectList];

	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
								callbackId:command.callbackId];
}

- (void)setPushNotificationToken:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* token = command.arguments[0];
    if (token.length>0)
    {
        [UXCam setPushNotificationToken:token];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)reportBugEvent:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventName = command.arguments[0];
    NSDictionary* properties = command.arguments[1];

    if (eventName.length>0 && properties && [properties isKindOfClass:NSDictionary.class])
    {
        [UXCam reportBugEvent:eventName properties:properties];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else if (eventName.length>0){
        [UXCam reportBugEvent:eventName properties:nil];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
