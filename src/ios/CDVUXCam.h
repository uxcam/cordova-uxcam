#import <Cordova/CDVPlugin.h>

@interface CDVUXCam : CDVPlugin

- (void)startWithKey:(CDVInvokedUrlCommand*)command;

- (void)stopSessionAndUploadData:(CDVInvokedUrlCommand*)command;

- (void)allowShortBreakForAnotherApp:(CDVInvokedUrlCommand*)command;

- (void)startNewSession:(CDVInvokedUrlCommand*)command;

- (void)cancelCurrentSession:(CDVInvokedUrlCommand*)command;

- (void)isRecording:(CDVInvokedUrlCommand*)command;

- (void)setMultiSessionRecord:(CDVInvokedUrlCommand*)command;

- (void)getMultiSessionRecord:(CDVInvokedUrlCommand*)command;

- (void)pauseScreenRecording:(CDVInvokedUrlCommand*)command;

- (void)resumeScreenRecording:(CDVInvokedUrlCommand*)command;

- (void)disableCrashHandling:(CDVInvokedUrlCommand*)command;

- (void)pendingUploads:(CDVInvokedUrlCommand*)command;

- (void)deletePendingUploads:(CDVInvokedUrlCommand*)command;

- (void)occludeSensitiveScreen:(CDVInvokedUrlCommand*)command;

- (void)occludeAllTextFields:(CDVInvokedUrlCommand*)command;

- (void)setAutomaticScreenNameTagging:(CDVInvokedUrlCommand*)command;

- (void)tagScreenName:(CDVInvokedUrlCommand*)command;

- (void)setUserIdentity:(CDVInvokedUrlCommand*)command;

- (void)setUserProperty:(CDVInvokedUrlCommand*)command;

- (void)logEvent:(CDVInvokedUrlCommand*)command;

- (void)logEventWithProperties:(CDVInvokedUrlCommand*)command;

- (void)urlForCurrentUser:(CDVInvokedUrlCommand*)command;

- (void)urlForCurrentSession:(CDVInvokedUrlCommand*)command;

- (void)optOutOverall:(CDVInvokedUrlCommand*)command;

- (void)optOutOfSchematicRecordings:(CDVInvokedUrlCommand*)command;

- (void)optInOverall:(CDVInvokedUrlCommand*)command;

- (void)optIntoSchematicRecordings:(CDVInvokedUrlCommand*)command;

- (void)optInOverallStatus:(CDVInvokedUrlCommand*)command;

- (void)optInSchematicRecordingStatus:(CDVInvokedUrlCommand*)command;

- (void)optInStatus:(CDVInvokedUrlCommand*)command;

- (void)optIn:(CDVInvokedUrlCommand*)command;

- (void)optOut:(CDVInvokedUrlCommand*)command;

- (void)occludeRectsOnNextFrame:(CDVInvokedUrlCommand*)command;

@end
