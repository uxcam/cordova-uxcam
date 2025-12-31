export interface UXCamConfiguration {
  userAppKey: string;
  enableMultiSessionRecord?: boolean;
  enableCrashHandling?: boolean;
  enableAutomaticScreenNameTagging?: boolean;
  enableAdvancedGestureRecognition?: boolean;
  enableNetworkLogging?: boolean;
  enableIntegrationLogging?: boolean;
  occlusions?: UXCamOcclusionConfig[];
}

export interface UXCamOcclusionConfig {
  type: UXCamOcclusionType;
  screens?: string[];
  excludeMentionedScreens?: boolean;
  name?: string; // For blur type
  blurRadius?: number;
  hideGestures?: boolean;
  color?: number; // For overlay type
  recognitionLanguages?: string[]; // For AI occlusion
}

export enum UXCamOcclusionType {
  Blur = 1,
  Overlay = 2,
  OccludeAllTextFields = 3,
  AITextOcclusion = 4
}

export interface UXCamPlugin {
  /**
   * Start UXCam with full configuration
   */
  startWithConfiguration(options: { configuration: UXCamConfiguration }): Promise<{ sessionUrl: string }>;

  /**
   * Start UXCam with just an app key
   */
  startWithKey(options: { key: string }): Promise<{ sessionUrl: string }>;

  /**
   * Apply an occlusion setting
   */
  applyOcclusion(options: { occlusion: UXCamOcclusionConfig }): Promise<void>;

  /**
   * Remove an occlusion setting
   */
  removeOcclusion(options?: { occlusion?: UXCamOcclusionConfig }): Promise<void>;

  /**
   * Stop the current session and upload data
   */
  stopSessionAndUploadData(): Promise<void>;

  /**
   * Allow a short break for another app
   */
  allowShortBreakForAnotherApp(options: { continueSession: boolean }): Promise<void>;

  /**
   * Start a new session
   */
  startNewSession(): Promise<void>;

  /**
   * Cancel the current session
   */
  cancelCurrentSession(): Promise<void>;

  /**
   * Check if recording is in progress
   */
  isRecording(): Promise<{ isRecording: boolean }>;

  /**
   * Set multi-session recording
   */
  setMultiSessionRecord(options: { record: boolean }): Promise<void>;

  /**
   * Get multi-session record status
   */
  getMultiSessionRecord(): Promise<{ multiSessionRecord: boolean }>;

  /**
   * Pause screen recording
   */
  pauseScreenRecording(): Promise<void>;

  /**
   * Resume screen recording
   */
  resumeScreenRecording(): Promise<void>;

  /**
   * Disable crash handling
   */
  disableCrashHandling(options: { disable: boolean }): Promise<void>;

  /**
   * Get pending uploads count
   */
  pendingUploads(): Promise<{ count: number }>;

  /**
   * Delete pending uploads
   */
  deletePendingUploads(): Promise<void>;

  /**
   * Get pending session count
   */
  pendingSessionCount(): Promise<{ count: number }>;

  /**
   * Upload pending sessions
   */
  uploadPendingSession(): Promise<{ success: boolean }>;

  /**
   * Occlude sensitive screen
   */
  occludeSensitiveScreen(options: { occlude: boolean }): Promise<void>;

  /**
   * Occlude all text fields
   */
  occludeAllTextFields(options: { occlude: boolean }): Promise<void>;

  /**
   * Set automatic screen name tagging
   */
  setAutomaticScreenNameTagging(options: { enable: boolean }): Promise<void>;

  /**
   * Tag the current screen with a name
   */
  tagScreenName(options: { screenName: string }): Promise<void>;

  /**
   * Set user identity
   */
  setUserIdentity(options: { identity: string }): Promise<void>;

  /**
   * Set a user property
   */
  setUserProperty(options: { key: string; value: string }): Promise<void>;

  /**
   * Log an event
   */
  logEvent(options: { eventName: string }): Promise<void>;

  /**
   * Log an event with properties
   */
  logEventWithProperties(options: { eventName: string; properties: Record<string, any> }): Promise<void>;

  /**
   * Get URL for current user
   */
  urlForCurrentUser(): Promise<{ url: string }>;

  /**
   * Get URL for current session
   */
  urlForCurrentSession(): Promise<{ url: string }>;

  /**
   * Opt out overall
   */
  optOutOverall(): Promise<void>;

  /**
   * Opt out of schematic recordings
   */
  optOutOfSchematicRecordings(): Promise<void>;

  /**
   * Opt in overall
   */
  optInOverall(): Promise<void>;

  /**
   * Opt into schematic recordings
   */
  optIntoSchematicRecordings(): Promise<void>;

  /**
   * Get opt-in overall status
   */
  optInOverallStatus(): Promise<{ status: boolean }>;

  /**
   * Get opt-in schematic recording status
   */
  optInSchematicRecordingStatus(): Promise<{ status: boolean }>;

  /**
   * Get opt-in status (deprecated, use optInOverallStatus)
   */
  optInStatus(): Promise<{ status: boolean }>;

  /**
   * Opt in (deprecated, use optInOverall)
   */
  optIn(): Promise<void>;

  /**
   * Opt out (deprecated, use optOutOverall)
   */
  optOut(): Promise<void>;

  /**
   * Occlude rects on next frame
   */
  occludeRectsOnNextFrame(options: { rects: number[][] }): Promise<void>;

  /**
   * Set push notification token
   */
  setPushNotificationToken(options: { token: string }): Promise<void>;

  /**
   * Report a bug event
   */
  reportBugEvent(options: { eventName: string; properties?: Record<string, any> }): Promise<void>;
}
