import type { UXCamPlugin, UXCamConfiguration, UXCamOcclusionConfig } from './definitions';

// Declare window.UXCam for TypeScript
declare global {
  interface Window {
    UXCam: typeof UXCam;
  }
}

declare const module: { exports?: any } | undefined;

// Legacy callback-style API wrapper for backward compatibility
// Two distinct callback types for proper type safety:
// - VoidCallback: for methods that don't return values
// - SuccessCallback<T>: for methods that return values (result is guaranteed)
type VoidCallback = () => void;
type SuccessCallback<T> = (result: T) => void;
type ErrorCallback = (error: string) => void;

type CordovaExec = (
  success: (result?: any) => void,
  error: (err?: any) => void,
  plugin: string,
  method: string,
  args?: any[]
) => void;

type GlobalScope = typeof globalThis & {
  Capacitor?: any;
  cordova?: { exec: CordovaExec };
};

const globalScope: GlobalScope = (typeof globalThis !== 'undefined'
  ? globalThis
  : typeof window !== 'undefined'
    ? window
    : {}) as GlobalScope;

function isCapacitorNative(capacitor: any): boolean {
  if (!capacitor) return false;
  if (typeof capacitor.isNativePlatform === 'function') {
    return capacitor.isNativePlatform();
  }
  const platform = typeof capacitor.getPlatform === 'function'
    ? capacitor.getPlatform()
    : capacitor.platform;
  if (typeof platform === 'string') {
    return platform !== 'web';
  }
  return true;
}

function getCapacitorPlugin(): UXCamPlugin | null {
  const capacitor = globalScope.Capacitor;
  if (!capacitor || !isCapacitorNative(capacitor)) {
    return null;
  }

  if (capacitor.Plugins?.UXCam) {
    return capacitor.Plugins.UXCam as UXCamPlugin;
  }

  if (typeof capacitor.registerPlugin === 'function') {
    const pluginAvailable = typeof capacitor.isPluginAvailable === 'function'
      ? capacitor.isPluginAvailable('UXCam')
      : true;
    if (!pluginAvailable && globalScope.cordova?.exec) {
      return null;
    }
    return capacitor.registerPlugin('UXCam') as UXCamPlugin;
  }

  return null;
}

function createCordovaAdapter(exec: CordovaExec): UXCamPlugin {
  const execPromise = <T>(method: string, args: any[] = []): Promise<T> =>
    new Promise((resolve, reject) => {
      exec(
        (result) => resolve(result as T),
        (error) => {
          const message = typeof error === 'string' ? error : error?.message || `${method} failed`;
          reject(new Error(message));
        },
        'UXCam',
        method,
        args
      );
    });

  return {
    async startWithConfiguration(options: { configuration: UXCamConfiguration }) {
      const result = await execPromise<string>('startWithConfiguration', [options.configuration]);
      return { sessionUrl: result || '' };
    },
    async applyOcclusion(options: { occlusion: UXCamOcclusionConfig }) {
      await execPromise<void>('applyOcclusion', [options.occlusion]);
    },
    async removeOcclusion(options?: { occlusion?: UXCamOcclusionConfig }) {
      await execPromise<void>('removeOcclusion', [options?.occlusion]);
    },
    async stopSessionAndUploadData() {
      await execPromise<void>('stopSessionAndUploadData', []);
    },
    async allowShortBreakForAnotherApp(options: { continueSession: boolean }) {
      await execPromise<void>('allowShortBreakForAnotherApp', [options.continueSession]);
    },
    async startNewSession() {
      await execPromise<void>('startNewSession', []);
    },
    async cancelCurrentSession() {
      await execPromise<void>('cancelCurrentSession', []);
    },
    async isRecording() {
      const result = await execPromise<boolean>('isRecording', []);
      return { isRecording: result };
    },
    async pauseScreenRecording() {
      await execPromise<void>('pauseScreenRecording', []);
    },
    async resumeScreenRecording() {
      await execPromise<void>('resumeScreenRecording', []);
    },
    async pendingUploads() {
      const result = await execPromise<number>('pendingUploads', []);
      return { count: result };
    },
    async deletePendingUploads() {
      await execPromise<void>('deletePendingUploads', []);
    },
    async pendingSessionCount() {
      const result = await execPromise<number>('pendingSessionCount', []);
      return { count: result };
    },
    async uploadPendingSession() {
      const result = await execPromise<boolean>('uploadPendingSession', []);
      return { success: result };
    },
    async occludeAllTextFields(options: { occlude: boolean }) {
      await execPromise<void>('occludeAllTextFields', [options.occlude]);
    },
    async tagScreenName(options: { screenName: string }) {
      await execPromise<void>('tagScreenName', [options.screenName]);
    },
    async setUserIdentity(options: { identity: string }) {
      await execPromise<void>('setUserIdentity', [options.identity]);
    },
    async setUserProperty(options: { key: string; value: string }) {
      await execPromise<void>('setUserProperty', [options.key, options.value]);
    },
    async logEvent(options: { eventName: string }) {
      await execPromise<void>('logEvent', [options.eventName]);
    },
    async logEventWithProperties(options: { eventName: string; properties: Record<string, any> }) {
      await execPromise<void>('logEventWithProperties', [options.eventName, options.properties]);
    },
    async urlForCurrentUser() {
      const result = await execPromise<string>('urlForCurrentUser', []);
      return { url: result || '' };
    },
    async urlForCurrentSession() {
      const result = await execPromise<string>('urlForCurrentSession', []);
      return { url: result || '' };
    },
    async optOutOverall() {
      await execPromise<void>('optOutOverall', []);
    },
    async optOutOfSchematicRecordings() {
      await execPromise<void>('optOutOfSchematicRecordings', []);
    },
    async optInOverall() {
      await execPromise<void>('optInOverall', []);
    },
    async optIntoSchematicRecordings() {
      await execPromise<void>('optIntoSchematicRecordings', []);
    },
    async optInOverallStatus() {
      const result = await execPromise<boolean>('optInOverallStatus', []);
      return { status: result };
    },
    async optInSchematicRecordingStatus() {
      const result = await execPromise<boolean>('optInSchematicRecordingStatus', []);
      return { status: result };
    }
  };
}

function createWebAdapter(): UXCamPlugin {
  const warn = (method: string) => {
    console.warn(`[UXCam] ${method} is not supported on web`);
  };

  return {
    async startWithConfiguration() {
      warn('startWithConfiguration');
      return { sessionUrl: '' };
    },
    async applyOcclusion() {
      warn('applyOcclusion');
    },
    async removeOcclusion() {
      warn('removeOcclusion');
    },
    async stopSessionAndUploadData() {
      warn('stopSessionAndUploadData');
    },
    async allowShortBreakForAnotherApp() {
      warn('allowShortBreakForAnotherApp');
    },
    async startNewSession() {
      warn('startNewSession');
    },
    async cancelCurrentSession() {
      warn('cancelCurrentSession');
    },
    async isRecording() {
      warn('isRecording');
      return { isRecording: false };
    },
    async pauseScreenRecording() {
      warn('pauseScreenRecording');
    },
    async resumeScreenRecording() {
      warn('resumeScreenRecording');
    },
    async pendingUploads() {
      warn('pendingUploads');
      return { count: 0 };
    },
    async deletePendingUploads() {
      warn('deletePendingUploads');
    },
    async pendingSessionCount() {
      warn('pendingSessionCount');
      return { count: 0 };
    },
    async uploadPendingSession() {
      warn('uploadPendingSession');
      return { success: false };
    },
    async occludeAllTextFields() {
      warn('occludeAllTextFields');
    },
    async tagScreenName() {
      warn('tagScreenName');
    },
    async setUserIdentity() {
      warn('setUserIdentity');
    },
    async setUserProperty() {
      warn('setUserProperty');
    },
    async logEvent() {
      warn('logEvent');
    },
    async logEventWithProperties() {
      warn('logEventWithProperties');
    },
    async urlForCurrentUser() {
      warn('urlForCurrentUser');
      return { url: '' };
    },
    async urlForCurrentSession() {
      warn('urlForCurrentSession');
      return { url: '' };
    },
    async optOutOverall() {
      warn('optOutOverall');
    },
    async optOutOfSchematicRecordings() {
      warn('optOutOfSchematicRecordings');
    },
    async optInOverall() {
      warn('optInOverall');
    },
    async optIntoSchematicRecordings() {
      warn('optIntoSchematicRecordings');
    },
    async optInOverallStatus() {
      warn('optInOverallStatus');
      return { status: false };
    },
    async optInSchematicRecordingStatus() {
      warn('optInSchematicRecordingStatus');
      return { status: false };
    }
  };
}

type PluginKind = 'capacitor' | 'cordova' | 'web';

let cordovaAdapter: UXCamPlugin | null = null;
let cachedPlugin: UXCamPlugin | null = null;
let cachedKind: PluginKind | null = null;
export let UXCamCapacitor: UXCamPlugin | null = getCapacitorPlugin();

async function getPlugin(): Promise<UXCamPlugin> {
  if (cachedPlugin && cachedKind !== 'web') {
    return cachedPlugin;
  }

  if (!UXCamCapacitor) {
    UXCamCapacitor = getCapacitorPlugin();
  }

  if (UXCamCapacitor) {
    cachedPlugin = UXCamCapacitor;
    cachedKind = 'capacitor';
    return cachedPlugin;
  }

  if (globalScope.cordova?.exec) {
    if (!cordovaAdapter) {
      cordovaAdapter = createCordovaAdapter(globalScope.cordova.exec);
    }
    cachedPlugin = cordovaAdapter;
    cachedKind = 'cordova';
    return cachedPlugin;
  }

  if (!cachedPlugin || cachedKind !== 'web') {
    cachedPlugin = createWebAdapter();
    cachedKind = 'web';
  }

  return cachedPlugin;
}

function handlePromise<T, R = T>(
  promise: Promise<T>,
  successCallback?: SuccessCallback<R>,
  errorCallback?: ErrorCallback,
  mapResult?: (value: T) => R
): Promise<T> | void {
  if (successCallback || errorCallback) {
    promise
      .then(result => successCallback?.(mapResult ? mapResult(result) : (result as unknown as R)))
      .catch(error => errorCallback?.(error?.message || error));
    return;
  }
  return promise;
}

// Export types
export * from './definitions';

/**
 * UXCam wrapper that provides both Capacitor (Promise-based) and
 * legacy Cordova (callback-based) APIs
 */
export const UXCam = {
  startWithConfiguration: function(
    configuration: UXCamConfiguration,
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.startWithConfiguration({ configuration }));
    return handlePromise(promise, successCallback, errorCallback, result => result.sessionUrl);
  },

  applyOcclusion: function(
    occlusion: UXCamOcclusionConfig,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.applyOcclusion({ occlusion }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  removeOcclusion: function(
    occlusion?: UXCamOcclusionConfig,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.removeOcclusion(occlusion ? { occlusion } : undefined));
    return handlePromise(promise, successCallback, errorCallback);
  },

  stopSessionAndUploadData: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.stopSessionAndUploadData());
    return handlePromise(promise, successCallback, errorCallback);
  },

  startNewSession: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.startNewSession());
    return handlePromise(promise, successCallback, errorCallback);
  },

  cancelCurrentSession: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.cancelCurrentSession());
    return handlePromise(promise, successCallback, errorCallback);
  },

  isRecording: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.isRecording());
    return handlePromise(promise, successCallback, errorCallback, result => result.isRecording);
  },

  pauseScreenRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.pauseScreenRecording());
    return handlePromise(promise, successCallback, errorCallback);
  },

  resumeScreenRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.resumeScreenRecording());
    return handlePromise(promise, successCallback, errorCallback);
  },

  allowShortBreakForAnotherApp: function(
    continueSession: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.allowShortBreakForAnotherApp({ continueSession }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  pendingUploads: function(
    successCallback?: SuccessCallback<number>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.pendingUploads());
    return handlePromise(promise, successCallback, errorCallback, result => result.count);
  },

  deletePendingUploads: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.deletePendingUploads());
    return handlePromise(promise, successCallback, errorCallback);
  },

  pendingSessionCount: function(
    successCallback?: SuccessCallback<number>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.pendingSessionCount());
    return handlePromise(promise, successCallback, errorCallback, result => result.count);
  },

  uploadPendingSession: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.uploadPendingSession());
    return handlePromise(promise, successCallback, errorCallback, result => result.success);
  },

  occludeAllTextFields: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.occludeAllTextFields({ occlude }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  // Alias for occludeAllTextFields
  occludeAllTextView: function(
    occlude: boolean,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.occludeAllTextFields(occlude, successCallback, errorCallback);
  },

  tagScreenName: function(
    screenName: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.tagScreenName({ screenName }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  setUserIdentity: function(
    identity: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.setUserIdentity({ identity }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  setUserProperty: function(
    key: string,
    value: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.setUserProperty({ key, value }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  logEvent: function(
    eventName: string,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.logEvent({ eventName }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  logEventWithProperties: function(
    eventName: string,
    properties: Record<string, any>,
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.logEventWithProperties({ eventName, properties }));
    return handlePromise(promise, successCallback, errorCallback);
  },

  urlForCurrentUser: function(
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.urlForCurrentUser());
    return handlePromise(promise, successCallback, errorCallback, result => result.url);
  },

  urlForCurrentSession: function(
    successCallback?: SuccessCallback<string>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.urlForCurrentSession());
    return handlePromise(promise, successCallback, errorCallback, result => result.url);
  },

  optOutOverall: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optOutOverall());
    return handlePromise(promise, successCallback, errorCallback);
  },

  optOutOfSchematicRecordings: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optOutOfSchematicRecordings());
    return handlePromise(promise, successCallback, errorCallback);
  },

  optInOverall: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optInOverall());
    return handlePromise(promise, successCallback, errorCallback);
  },

  optIntoSchematicRecordings: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optIntoSchematicRecordings());
    return handlePromise(promise, successCallback, errorCallback);
  },

  optInOverallStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optInOverallStatus());
    return handlePromise(promise, successCallback, errorCallback, result => result.status);
  },

  optInSchematicRecordingStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    const promise = getPlugin().then(plugin => plugin.optInSchematicRecordingStatus());
    return handlePromise(promise, successCallback, errorCallback, result => result.status);
  },

  // Legacy aliases
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

  optIntoVideoRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optIntoSchematicRecordings(successCallback, errorCallback);
  },

  optOutOfVideoRecording: function(
    successCallback?: VoidCallback,
    errorCallback?: ErrorCallback
  ) {
    return this.optOutOfSchematicRecordings(successCallback, errorCallback);
  },

  optInVideoRecordingStatus: function(
    successCallback?: SuccessCallback<boolean>,
    errorCallback?: ErrorCallback
  ) {
    return this.optInSchematicRecordingStatus(successCallback, errorCallback);
  }
};

// Default export
export default UXCam;

// Set window.UXCam for backward compatibility with Cordova-style usage
if (typeof globalScope !== 'undefined') {
  (globalScope as any).UXCam = UXCam;
}

// Ensure Cordova clobbers receive the UXCam object as the module export.
if (typeof module !== 'undefined' && module.exports) {
  module.exports = UXCam;
  module.exports.UXCam = UXCam;
  module.exports.UXCamCapacitor = UXCamCapacitor;
  module.exports.default = UXCam;
}
