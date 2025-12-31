import { registerPlugin } from '@capacitor/core';
import type { UXCamPlugin, UXCamConfiguration, UXCamOcclusionConfig } from './definitions';

// Register the Capacitor plugin
const UXCamCapacitor = registerPlugin<UXCamPlugin>('UXCam', {
  web: () => import('./web').then(m => new m.UXCamWeb()),
});

// Export the Capacitor plugin and types
export * from './definitions';
export { UXCamCapacitor };

// Declare window.UXCam for TypeScript
declare global {
  interface Window {
    UXCam: typeof UXCam;
  }
}

// Legacy callback-style API wrapper for backward compatibility
// Two distinct callback types for proper type safety:
// - VoidCallback: for methods that don't return values
// - SuccessCallback<T>: for methods that return values (result is guaranteed)
type VoidCallback = () => void;
type SuccessCallback<T> = (result: T) => void;
type ErrorCallback = (error: string) => void;

/**
 * UXCam wrapper that provides both Capacitor (Promise-based) and
 * legacy Cordova (callback-based) APIs
 */
export const UXCam = {
  // Capacitor-style Promise API
  ...UXCamCapacitor,

  // Legacy Cordova-style callback API
  startWithConfiguration: function(
    configuration: UXCamConfiguration,
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.startWithConfiguration({ configuration });
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.sessionUrl))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  startWithKey: function(
    key: string,
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.startWithKey({ key });
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.sessionUrl))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  applyOcclusion: function(
    occlusion: UXCamOcclusionConfig,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.applyOcclusion({ occlusion });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  removeOcclusion: function(
    occlusion?: UXCamOcclusionConfig,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.removeOcclusion(occlusion ? { occlusion } : undefined);
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  stopSessionAndUploadData: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.stopSessionAndUploadData();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  startNewSession: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.startNewSession();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  cancelCurrentSession: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.cancelCurrentSession();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  isRecording: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.isRecording();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.isRecording))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  pauseScreenRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.pauseScreenRecording();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  resumeScreenRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.resumeScreenRecording();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  allowShortBreakForAnotherApp: function(
    continueSession: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.allowShortBreakForAnotherApp({ continueSession });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  setMultiSessionRecord: function(
    record: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.setMultiSessionRecord({ record });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  getMultiSessionRecord: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.getMultiSessionRecord();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.multiSessionRecord))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  disableCrashHandling: function(
    disable: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.disableCrashHandling({ disable });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  pendingUploads: function(
    successCallback?: SuccessCallback<number>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.pendingUploads();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.count))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  deletePendingUploads: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.deletePendingUploads();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  pendingSessionCount: function(
    successCallback?: SuccessCallback<number>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.pendingSessionCount();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.count))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  uploadPendingSession: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.uploadPendingSession();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.success))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  occludeSensitiveScreen: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.occludeSensitiveScreen({ occlude });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  occludeAllTextFields: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.occludeAllTextFields({ occlude });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  // Alias for occludeAllTextFields
  occludeAllTextView: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.occludeAllTextFields(occlude, successCallback, errorCallback);
  },

  setAutomaticScreenNameTagging: function(
    enable: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.setAutomaticScreenNameTagging({ enable });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  tagScreenName: function(
    screenName: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.tagScreenName({ screenName });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  setUserIdentity: function(
    identity: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.setUserIdentity({ identity });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  setUserProperty: function(
    key: string,
    value: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.setUserProperty({ key, value });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  logEvent: function(
    eventName: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.logEvent({ eventName });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  logEventWithProperties: function(
    eventName: string,
    properties: Record<string, any>,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.logEventWithProperties({ eventName, properties });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  urlForCurrentUser: function(
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.urlForCurrentUser();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.url))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  urlForCurrentSession: function(
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.urlForCurrentSession();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.url))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optOutOverall: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optOutOverall();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optOutOfSchematicRecordings: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optOutOfSchematicRecordings();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optInOverall: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optInOverall();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optIntoSchematicRecordings: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optIntoSchematicRecordings();
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optInOverallStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optInOverallStatus();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.status))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  optInSchematicRecordingStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.optInSchematicRecordingStatus();
    if (successCallback || errorCallback) {
      promise
        .then(result => successCallback?.(result.status))
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  // Deprecated methods - kept for backward compatibility
  optIn: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optInOverall(successCallback, errorCallback);
  },

  optOut: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optOutOverall(successCallback, errorCallback);
  },

  optInStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    return this.optInOverallStatus(successCallback, errorCallback);
  },

  optStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    return this.optInOverallStatus(successCallback, errorCallback);
  },

  occludeRectsOnNextFrame: function(
    rects: number[][],
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.occludeRectsOnNextFrame({ rects });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  setPushNotificationToken: function(
    token: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.setPushNotificationToken({ token });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  reportBugEvent: function(
    eventName: string,
    properties?: Record<string, any>,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = UXCamCapacitor.reportBugEvent({ eventName, properties });
    if (successCallback || errorCallback) {
      promise
        .then(() => successCallback?.())
        .catch(error => errorCallback?.(error.message || error));
      return;
    }
    return promise;
  },

  // Legacy aliases
  startWithKeyAndAppVariant: function(
    key: string,
    _appVariant: string,
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    return this.startWithKey(key, successCallback, errorCallback);
  },

  stopApplicationAndUploadData: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.stopSessionAndUploadData(successCallback, errorCallback);
  },

  resumeShortBreakForAnotherApp: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.allowShortBreakForAnotherApp(false, successCallback, errorCallback);
  },

  setSessionProperty: function(
    key: string,
    value: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.setUserProperty(key, value, successCallback, errorCallback);
  },

  occludeSensitiveScreenWithoutGesture: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.occludeSensitiveScreen(occlude, successCallback, errorCallback);
  },

  optIntoVideoRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optInOverall(successCallback, errorCallback);
  },

  optOutOfVideoRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optOutOverall(successCallback, errorCallback);
  },

  optInVideoRecordingStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    return this.optInOverallStatus(successCallback, errorCallback);
  }
};

// Default export
export default UXCam;

// Set window.UXCam for backward compatibility with Cordova-style usage
if (typeof window !== 'undefined') {
  (window as any).UXCam = UXCam;
}
