#import "CDVUXCam.h"

@import UXCam;

// Configuration Keys
static NSString* const Uxcam_AppKey = @"userAppKey";
static NSString* const Uxcam_MultiSession = @"enableMultiSessionRecord";
static NSString* const Uxcam_CrashHandling = @"enableCrashHandling";
static NSString* const Uxcam_ScreenTag = @"enableAutomaticScreenNameTagging";
static NSString* const Uxcam_AdvancedGestures = @"enableAdvancedGestureRecognition";
static NSString* const Uxcam_EnableNetworkLogs = @"enableNetworkLogging";

static NSString* const Uxcam_Occlusion = @"occlusions";
static NSString* const Uxcam_OccludeScreens = @"screens";
static NSString* const Uxcam_ExcludeScreens = @"excludeMentionedScreens";
static NSString* const Uxcam_OcclusionType = @"type";
static NSString* const Uxcam_BlurName = @"name";
static NSString* const Uxcam_BlurRadius = @"blurRadius";
static NSString* const Uxcam_HideGestures = @"hideGestures";
static NSString* const Uxcam_OverlayColor = @"color";

static NSString* const UXCAM_CORDOVA_PLUGIN_VERSION = @"3.6.2";

@implementation CDVUXCam

+ (void)load
{
    // Set this early in the startup process so we can do extra Cordova related processing before the session startWithKey is called.
    [UXCam pluginType:@"cordova" version: UXCAM_CORDOVA_PLUGIN_VERSION];
}

- (void)startWithConfiguration:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    NSDictionary *config = command.arguments[0];
    
    NSString *userAppKey = config[Uxcam_AppKey];
    if (!userAppKey || ![userAppKey isKindOfClass:NSString.class])
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid app key"];
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
        return;
    }
    UXCamConfiguration *configuration = [[UXCamConfiguration alloc] initWithAppKey:userAppKey];
    [self updateConfiguration:configuration fromDict:config];
    
    [UXCam startWithConfiguration:configuration completionBlock:^(BOOL started)
     {
        if (started) {
            NSString *url =  [UXCam urlForCurrentSession];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: url];
        }
        else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"failed to start uxcam session"];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    }
    ];
}

- (void)startWithKey:(CDVInvokedUrlCommand*)command
{
    NSString *userAppKey = command.arguments[0];
    NSDictionary *config = @{Uxcam_AppKey: userAppKey};
    CDVInvokedUrlCommand *configurationCommand = [[CDVInvokedUrlCommand alloc] initWithArguments: @[config] callbackId: command.callbackId className: command.className methodName: command.methodName];
    [self startWithConfiguration: configurationCommand];
}

- (void)updateConfiguration:(UXCamConfiguration *)configuration fromDict:(NSDictionary *)config
{
    NSNumber *enableMultiSessionRecord = config[Uxcam_MultiSession];
    if (enableMultiSessionRecord && [self isBoolNumber:enableMultiSessionRecord])
    {
        configuration.enableMultiSessionRecord = [enableMultiSessionRecord boolValue];
    }
    NSNumber *enableCrashHandling = config[Uxcam_CrashHandling];
    if (enableCrashHandling && [self isBoolNumber:enableCrashHandling])
    {
        configuration.enableCrashHandling = [enableCrashHandling boolValue];
    }
    NSNumber *enableAutomaticScreenNameTagging = config[Uxcam_ScreenTag];
    if (enableAutomaticScreenNameTagging && [self isBoolNumber:enableAutomaticScreenNameTagging])
    {
        configuration.enableAutomaticScreenNameTagging = [enableAutomaticScreenNameTagging boolValue];
    }
    NSNumber *enableAdvancedGestureRecognition = config[Uxcam_AdvancedGestures];
    if (enableAdvancedGestureRecognition && [self isBoolNumber:enableAdvancedGestureRecognition])
    {
        configuration.enableAdvancedGestureRecognition = [enableAdvancedGestureRecognition boolValue];
    }
    NSNumber *enableNetworkLogging = config[Uxcam_EnableNetworkLogs];
    if (enableNetworkLogging && [self isBoolNumber:enableNetworkLogging])
    {
        configuration.enableNetworkLogging = [enableNetworkLogging boolValue];
    }
    
    NSArray *occlusionList = config[Uxcam_Occlusion];
    if (occlusionList && ![occlusionList isKindOfClass:NSNull.class]) {
        UXCamOcclusion *occlusion = [[UXCamOcclusion alloc] init];
        for (NSDictionary *occlusionJson in occlusionList) {
            id <UXCamOcclusionSetting> setting = [self getOcclusionSettingFromJson:occlusionJson];
            if (setting)
            {
                NSArray *screens = occlusionJson[Uxcam_OccludeScreens];
                BOOL excludeMentionedScreens = [occlusionJson[Uxcam_ExcludeScreens] boolValue];
                [occlusion applySettings:@[setting] screens:screens excludeMentionedScreens: excludeMentionedScreens];
            }
        }
        configuration.occlusion = occlusion;
    }
}

- (id<UXCamOcclusionSetting>)getOcclusionSettingFromJson:(NSDictionary *)json
{
    NSNumber *type = json[Uxcam_OcclusionType];
    UXOcclusionType occlusionType = type.integerValue ?: UXOcclusionTypeBlur;
    
    switch (occlusionType) {
        case UXOcclusionTypeBlur:
        {
            NSString *name = json[Uxcam_BlurName];
            UXBlurType blurType = [UXCamOcclusion getBlurTypeFromName:name];
            NSNumber *radiusValue = json[Uxcam_BlurRadius];
            int radius = radiusValue.intValue ?: 10;
            UXCamBlurSetting *blur = [[UXCamBlurSetting alloc] initWithBlurType:blurType radius:radius];
            NSNumber *hideGestures = json[Uxcam_HideGestures];
            if (hideGestures) {
                blur.hideGestures = hideGestures.boolValue;
            }
            
            return blur;
        }
        case UXOcclusionTypeOverlay:
        {
            UXCamOverlaySetting *overlay = [[UXCamOverlaySetting alloc] init];
            NSNumber *colorCode = json[Uxcam_OverlayColor];
            if (colorCode)
            {
                int colorValue = colorCode.intValue;
                float redValue = (colorValue >> 16 & 0xff) / 0xff;
                float greenValue = (colorValue >> 8 & 0xff) / 0xff;
                float blueValue = (colorValue & 0xff) / 0xff;
                
                UIColor *color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha: 1];
                overlay.color = color;
            }
            
            NSNumber *hideGestures = json[Uxcam_HideGestures];
            if (hideGestures) {
                overlay.hideGestures = hideGestures.boolValue;
            }
            return overlay;
        }
        case UXOcclusionTypeOccludeAllTextFields:
        {
            UXCamOccludeAllTextFields *occlude = [[UXCamOccludeAllTextFields alloc] init];
            return occlude;
        }
        default:
            return nil;
    }
}

- (void)applyOcclusion:(CDVInvokedUrlCommand*)command
{
    NSDictionary *occlusion = command.arguments[0];
    
    if (occlusion && ![occlusion isKindOfClass:NSNull.class]) {
        id <UXCamOcclusionSetting> setting = [self getOcclusionSettingFromJson:occlusion];
        if (setting)
        {
            [UXCam applyOcclusion:setting];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                        callbackId:command.callbackId];
            return;
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Occlusion setting not found"];
    [self.commandDelegate sendPluginResult: pluginResult callbackId: command.callbackId];
    
}

- (void)removeOcclusion:(CDVInvokedUrlCommand*)command
{
    NSDictionary *occlusion = command.arguments[0];
    if (occlusion && ![occlusion isKindOfClass:NSNull.class]) {
        id <UXCamOcclusionSetting> setting = [self getOcclusionSettingFromJson:occlusion];
        if (setting)
        {
            [UXCam removeOcclusionOfType:setting.type];
        }
        else
        {
            [UXCam removeOcclusion];
        }
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                    callbackId:command.callbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Occlusion setting not found"];
        [self.commandDelegate sendPluginResult: pluginResult callbackId: command.callbackId];
    }
}

- (BOOL)isBoolNumber:(NSNumber *)num
{
    CFTypeID boolID = CFBooleanGetTypeID(); // the type ID of CFBoolean
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(num)); // the type ID of num
    return numID == boolID;
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

- (void)occludeAllTextFields:(CDVInvokedUrlCommand*)command
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
