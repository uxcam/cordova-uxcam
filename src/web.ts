import { WebPlugin } from '@capacitor/core';
import type { UXCamPlugin } from './definitions';

export class UXCamWeb extends WebPlugin implements UXCamPlugin {
  private notSupportedError() {
    console.warn('UXCam is not supported on web');
    return Promise.reject('UXCam is not supported on web');
  }

  async startWithConfiguration(): Promise<{ sessionUrl: string }> {
    console.warn('UXCam.startWithConfiguration is not supported on web');
    return { sessionUrl: '' };
  }

  async startWithKey(): Promise<{ sessionUrl: string }> {
    console.warn('UXCam.startWithKey is not supported on web');
    return { sessionUrl: '' };
  }

  async applyOcclusion(): Promise<void> {
    console.warn('UXCam.applyOcclusion is not supported on web');
  }

  async removeOcclusion(): Promise<void> {
    console.warn('UXCam.removeOcclusion is not supported on web');
  }

  async stopSessionAndUploadData(): Promise<void> {
    console.warn('UXCam.stopSessionAndUploadData is not supported on web');
  }

  async allowShortBreakForAnotherApp(): Promise<void> {
    console.warn('UXCam.allowShortBreakForAnotherApp is not supported on web');
  }

  async startNewSession(): Promise<void> {
    console.warn('UXCam.startNewSession is not supported on web');
  }

  async cancelCurrentSession(): Promise<void> {
    console.warn('UXCam.cancelCurrentSession is not supported on web');
  }

  async isRecording(): Promise<{ isRecording: boolean }> {
    console.warn('UXCam.isRecording is not supported on web');
    return { isRecording: false };
  }

  async setMultiSessionRecord(): Promise<void> {
    console.warn('UXCam.setMultiSessionRecord is not supported on web');
  }

  async getMultiSessionRecord(): Promise<{ multiSessionRecord: boolean }> {
    console.warn('UXCam.getMultiSessionRecord is not supported on web');
    return { multiSessionRecord: false };
  }

  async pauseScreenRecording(): Promise<void> {
    console.warn('UXCam.pauseScreenRecording is not supported on web');
  }

  async resumeScreenRecording(): Promise<void> {
    console.warn('UXCam.resumeScreenRecording is not supported on web');
  }

  async disableCrashHandling(): Promise<void> {
    console.warn('UXCam.disableCrashHandling is not supported on web');
  }

  async pendingUploads(): Promise<{ count: number }> {
    console.warn('UXCam.pendingUploads is not supported on web');
    return { count: 0 };
  }

  async deletePendingUploads(): Promise<void> {
    console.warn('UXCam.deletePendingUploads is not supported on web');
  }

  async pendingSessionCount(): Promise<{ count: number }> {
    console.warn('UXCam.pendingSessionCount is not supported on web');
    return { count: 0 };
  }

  async uploadPendingSession(): Promise<{ success: boolean }> {
    console.warn('UXCam.uploadPendingSession is not supported on web');
    return { success: false };
  }

  async occludeSensitiveScreen(): Promise<void> {
    console.warn('UXCam.occludeSensitiveScreen is not supported on web');
  }

  async occludeAllTextFields(): Promise<void> {
    console.warn('UXCam.occludeAllTextFields is not supported on web');
  }

  async setAutomaticScreenNameTagging(): Promise<void> {
    console.warn('UXCam.setAutomaticScreenNameTagging is not supported on web');
  }

  async tagScreenName(): Promise<void> {
    console.warn('UXCam.tagScreenName is not supported on web');
  }

  async setUserIdentity(): Promise<void> {
    console.warn('UXCam.setUserIdentity is not supported on web');
  }

  async setUserProperty(): Promise<void> {
    console.warn('UXCam.setUserProperty is not supported on web');
  }

  async logEvent(): Promise<void> {
    console.warn('UXCam.logEvent is not supported on web');
  }

  async logEventWithProperties(): Promise<void> {
    console.warn('UXCam.logEventWithProperties is not supported on web');
  }

  async urlForCurrentUser(): Promise<{ url: string }> {
    console.warn('UXCam.urlForCurrentUser is not supported on web');
    return { url: '' };
  }

  async urlForCurrentSession(): Promise<{ url: string }> {
    console.warn('UXCam.urlForCurrentSession is not supported on web');
    return { url: '' };
  }

  async optOutOverall(): Promise<void> {
    console.warn('UXCam.optOutOverall is not supported on web');
  }

  async optOutOfSchematicRecordings(): Promise<void> {
    console.warn('UXCam.optOutOfSchematicRecordings is not supported on web');
  }

  async optInOverall(): Promise<void> {
    console.warn('UXCam.optInOverall is not supported on web');
  }

  async optIntoSchematicRecordings(): Promise<void> {
    console.warn('UXCam.optIntoSchematicRecordings is not supported on web');
  }

  async optInOverallStatus(): Promise<{ status: boolean }> {
    console.warn('UXCam.optInOverallStatus is not supported on web');
    return { status: false };
  }

  async optInSchematicRecordingStatus(): Promise<{ status: boolean }> {
    console.warn('UXCam.optInSchematicRecordingStatus is not supported on web');
    return { status: false };
  }

  async optInStatus(): Promise<{ status: boolean }> {
    console.warn('UXCam.optInStatus is not supported on web');
    return { status: false };
  }

  async optIn(): Promise<void> {
    console.warn('UXCam.optIn is not supported on web');
  }

  async optOut(): Promise<void> {
    console.warn('UXCam.optOut is not supported on web');
  }

  async occludeRectsOnNextFrame(): Promise<void> {
    console.warn('UXCam.occludeRectsOnNextFrame is not supported on web');
  }

  async setPushNotificationToken(): Promise<void> {
    console.warn('UXCam.setPushNotificationToken is not supported on web');
  }

  async reportBugEvent(): Promise<void> {
    console.warn('UXCam.reportBugEvent is not supported on web');
  }
}
