import Foundation
import Capacitor
import UXCam

private let UXCAM_CAPACITOR_PLUGIN_VERSION = "3.7.1"

// Configuration Keys
private let Uxcam_AppKey = "userAppKey"
private let Uxcam_MultiSession = "enableMultiSessionRecord"
private let Uxcam_CrashHandling = "enableCrashHandling"
private let Uxcam_ScreenTag = "enableAutomaticScreenNameTagging"
private let Uxcam_AdvancedGestures = "enableAdvancedGestureRecognition"
private let Uxcam_EnableNetworkLogs = "enableNetworkLogging"
private let Uxcam_EnableIntegrationLogs = "enableIntegrationLogging"

private let Uxcam_Occlusion = "occlusions"
private let Uxcam_OccludeScreens = "screens"
private let Uxcam_ExcludeScreens = "excludeMentionedScreens"
private let Uxcam_OcclusionType = "type"
private let Uxcam_BlurName = "name"
private let Uxcam_BlurRadius = "blurRadius"
private let Uxcam_HideGestures = "hideGestures"
private let Uxcam_OverlayColor = "color"
private let Uxcam_RecognitionLanguages = "recognitionLanguages"

@objc(UXCamPlugin)
public class UXCamPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "UXCamPlugin"
    public let jsName = "UXCam"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startWithConfiguration", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startWithKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "applyOcclusion", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "removeOcclusion", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopSessionAndUploadData", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "allowShortBreakForAnotherApp", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startNewSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "cancelCurrentSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "isRecording", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setMultiSessionRecord", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getMultiSessionRecord", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "pauseScreenRecording", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "resumeScreenRecording", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "disableCrashHandling", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "pendingUploads", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "deletePendingUploads", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "pendingSessionCount", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "uploadPendingSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "occludeSensitiveScreen", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "occludeAllTextFields", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setAutomaticScreenNameTagging", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "tagScreenName", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setUserIdentity", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setUserProperty", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "logEvent", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "logEventWithProperties", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "urlForCurrentUser", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "urlForCurrentSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optOutOverall", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optOutOfSchematicRecordings", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optInOverall", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optIntoSchematicRecordings", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optInOverallStatus", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optInSchematicRecordingStatus", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optInStatus", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optIn", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "optOut", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "occludeRectsOnNextFrame", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setPushNotificationToken", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "reportBugEvent", returnType: CAPPluginReturnPromise)
    ]

    public override func load() {
        UXCam.pluginType("capacitor", version: UXCAM_CAPACITOR_PLUGIN_VERSION)
    }

    // MARK: - Configuration

    @objc func startWithConfiguration(_ call: CAPPluginCall) {
        guard let config = call.getObject("configuration") ?? call.options as? [String: Any] else {
            call.reject("Configuration is required")
            return
        }

        guard let appKey = config[Uxcam_AppKey] as? String, !appKey.isEmpty else {
            call.reject("Invalid app key")
            return
        }

        let configuration = UXCamConfiguration(appKey: appKey)
        updateConfiguration(configuration, from: config)

        DispatchQueue.main.async {
            UXCam.start(with: configuration) { started in
                if started {
                    let url = UXCam.urlForCurrentSession() ?? ""
                    call.resolve(["sessionUrl": url])
                } else {
                    call.reject("Failed to start UXCam session")
                }
            }
        }
    }

    @objc func startWithKey(_ call: CAPPluginCall) {
        guard let key = call.getString("key"), !key.isEmpty else {
            call.reject("App key is required")
            return
        }

        let configuration = UXCamConfiguration(appKey: key)

        DispatchQueue.main.async {
            UXCam.start(with: configuration) { started in
                if started {
                    let url = UXCam.urlForCurrentSession() ?? ""
                    call.resolve(["sessionUrl": url])
                } else {
                    call.reject("Failed to start UXCam session")
                }
            }
        }
    }

    private func updateConfiguration(_ configuration: UXCamConfiguration, from config: [String: Any]) {
        if let enableMultiSessionRecord = config[Uxcam_MultiSession] as? Bool {
            configuration.enableMultiSessionRecord = enableMultiSessionRecord
        }

        if let enableCrashHandling = config[Uxcam_CrashHandling] as? Bool {
            configuration.enableCrashHandling = enableCrashHandling
        }

        if let enableAutomaticScreenNameTagging = config[Uxcam_ScreenTag] as? Bool {
            configuration.enableAutomaticScreenNameTagging = enableAutomaticScreenNameTagging
        }

        if let enableAdvancedGestureRecognition = config[Uxcam_AdvancedGestures] as? Bool {
            configuration.enableAdvancedGestureRecognition = enableAdvancedGestureRecognition
        }

        if let enableNetworkLogging = config[Uxcam_EnableNetworkLogs] as? Bool {
            configuration.enableNetworkLogging = enableNetworkLogging
        }

        if let enableIntegrationLogging = config[Uxcam_EnableIntegrationLogs] as? Bool {
            configuration.enableIntegrationLogging = enableIntegrationLogging
        }

        if let occlusionList = config[Uxcam_Occlusion] as? [[String: Any]] {
            let occlusion = UXCamOcclusion()
            for occlusionJson in occlusionList {
                if let setting = getOcclusionSetting(from: occlusionJson) {
                    let screens = occlusionJson[Uxcam_OccludeScreens] as? [String] ?? []
                    let excludeMentionedScreens = occlusionJson[Uxcam_ExcludeScreens] as? Bool ?? false
                    occlusion.apply([setting], screens: screens, excludeMentionedScreens: excludeMentionedScreens)
                }
            }
            configuration.occlusion = occlusion
        }
    }

    private func getOcclusionSetting(from json: [String: Any]) -> UXCamOcclusionSetting? {
        let typeValue = json[Uxcam_OcclusionType] as? Int ?? 1
        let occlusionType = UXOcclusionType(rawValue: typeValue) ?? .blur

        switch occlusionType {
        case .blur:
            let name = json[Uxcam_BlurName] as? String ?? ""
            let blurType = UXCamOcclusion.getBlurType(fromName: name)
            let radius = json[Uxcam_BlurRadius] as? Int ?? 10
            let blur = UXCamBlurSetting(blurType: blurType, radius: Int32(radius))
            if let hideGestures = json[Uxcam_HideGestures] as? Bool {
                blur.hideGestures = hideGestures
            }
            return blur

        case .overlay:
            let overlay = UXCamOverlaySetting()
            if let colorCode = json[Uxcam_OverlayColor] as? Int {
                let red = CGFloat((colorCode >> 16) & 0xff) / 255.0
                let green = CGFloat((colorCode >> 8) & 0xff) / 255.0
                let blue = CGFloat(colorCode & 0xff) / 255.0
                overlay.color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
            if let hideGestures = json[Uxcam_HideGestures] as? Bool {
                overlay.hideGestures = hideGestures
            }
            return overlay

        case .occludeAllTextFields:
            return UXCamOccludeAllTextFields()

        case .aiTextOcclusion:
            let languages = json[Uxcam_RecognitionLanguages] as? [String] ?? []
            let ai = UXCamAITextOcclusionSetting(language: languages)
            if let hideGestures = json[Uxcam_HideGestures] as? Bool {
                ai.hideGestures = hideGestures
            }
            return ai

        @unknown default:
            return nil
        }
    }

    // MARK: - Occlusion

    @objc func applyOcclusion(_ call: CAPPluginCall) {
        guard let occlusion = call.getObject("occlusion") else {
            call.reject("Occlusion setting is required")
            return
        }

        if let setting = getOcclusionSetting(from: occlusion) {
            DispatchQueue.main.async {
                UXCam.applyOcclusion(setting)
                call.resolve()
            }
        } else {
            call.reject("Invalid occlusion setting")
        }
    }

    @objc func removeOcclusion(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            if let occlusion = call.getObject("occlusion"),
               let setting = self.getOcclusionSetting(from: occlusion) {
                UXCam.removeOcclusion(of: setting.type)
            } else {
                UXCam.removeOcclusion()
            }
            call.resolve()
        }
    }

    // MARK: - Session Control

    @objc func stopSessionAndUploadData(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.stopSessionAndUploadData()
            call.resolve()
        }
    }

    @objc func allowShortBreakForAnotherApp(_ call: CAPPluginCall) {
        let continueSession = call.getBool("continueSession") ?? false
        DispatchQueue.main.async {
            UXCam.allowShortBreak(forAnotherApp: continueSession)
            call.resolve()
        }
    }

    @objc func startNewSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.startNewSession()
            call.resolve()
        }
    }

    @objc func cancelCurrentSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.cancelCurrentSession()
            call.resolve()
        }
    }

    @objc func isRecording(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let recording = UXCam.isRecording()
            call.resolve(["isRecording": recording])
        }
    }

    // MARK: - Multi-session

    @objc func setMultiSessionRecord(_ call: CAPPluginCall) {
        let record = call.getBool("record") ?? true
        DispatchQueue.main.async {
            UXCam.setAutomaticScreenNameTagging(record)
            call.resolve()
        }
    }

    @objc func getMultiSessionRecord(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let status = UXCam.getMultiSessionRecord()
            call.resolve(["multiSessionRecord": status])
        }
    }

    // MARK: - Recording Control

    @objc func pauseScreenRecording(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.pauseScreenRecording()
            call.resolve()
        }
    }

    @objc func resumeScreenRecording(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.resumeScreenRecording()
            call.resolve()
        }
    }

    @objc func disableCrashHandling(_ call: CAPPluginCall) {
        let disable = call.getBool("disable") ?? true
        DispatchQueue.main.async {
            UXCam.disableCrashHandling(disable)
            call.resolve()
        }
    }

    // MARK: - Uploads

    @objc func pendingUploads(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let count = UXCam.pendingUploads()
            call.resolve(["count": count])
        }
    }

    @objc func deletePendingUploads(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.deletePendingUploads()
            call.resolve()
        }
    }

    @objc func pendingSessionCount(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let count = UXCam.pendingUploads()
            call.resolve(["count": count])
        }
    }

    @objc func uploadPendingSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.uploadingPendingSessions {
                call.resolve(["success": true])
            }
        }
    }

    // MARK: - Screen Occlusion

    @objc func occludeSensitiveScreen(_ call: CAPPluginCall) {
        let occlude = call.getBool("occlude") ?? true
        DispatchQueue.main.async {
            UXCam.occludeSensitiveScreen(occlude)
            call.resolve()
        }
    }

    @objc func occludeAllTextFields(_ call: CAPPluginCall) {
        let occlude = call.getBool("occlude") ?? true
        DispatchQueue.main.async {
            UXCam.occludeAllTextFields(occlude)
            call.resolve()
        }
    }

    // MARK: - Screen Tagging

    @objc func setAutomaticScreenNameTagging(_ call: CAPPluginCall) {
        let enable = call.getBool("enable") ?? true
        DispatchQueue.main.async {
            UXCam.setAutomaticScreenNameTagging(enable)
            call.resolve()
        }
    }

    @objc func tagScreenName(_ call: CAPPluginCall) {
        guard let screenName = call.getString("screenName"), !screenName.isEmpty else {
            call.reject("Screen name is required")
            return
        }
        DispatchQueue.main.async {
            UXCam.tagScreenName(screenName)
            call.resolve()
        }
    }

    // MARK: - User Identity

    @objc func setUserIdentity(_ call: CAPPluginCall) {
        guard let identity = call.getString("identity"), !identity.isEmpty else {
            call.reject("User identity is required")
            return
        }
        DispatchQueue.main.async {
            UXCam.setUserIdentity(identity)
            call.resolve()
        }
    }

    @objc func setUserProperty(_ call: CAPPluginCall) {
        guard let key = call.getString("key"), !key.isEmpty,
              let value = call.getString("value"), !value.isEmpty else {
            call.reject("Key and value are required")
            return
        }
        DispatchQueue.main.async {
            UXCam.setUserProperty(key, value: value)
            call.resolve()
        }
    }

    // MARK: - Events

    @objc func logEvent(_ call: CAPPluginCall) {
        guard let eventName = call.getString("eventName"), !eventName.isEmpty else {
            call.reject("Event name is required")
            return
        }
        DispatchQueue.main.async {
            UXCam.logEvent(eventName)
            call.resolve()
        }
    }

    @objc func logEventWithProperties(_ call: CAPPluginCall) {
        guard let eventName = call.getString("eventName"), !eventName.isEmpty else {
            call.reject("Event name is required")
            return
        }
        let properties = call.getObject("properties") ?? [:]
        DispatchQueue.main.async {
            UXCam.logEvent(eventName, withProperties: properties)
            call.resolve()
        }
    }

    // MARK: - URLs

    @objc func urlForCurrentUser(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let url = UXCam.urlForCurrentUser() ?? ""
            call.resolve(["url": url])
        }
    }

    @objc func urlForCurrentSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let url = UXCam.urlForCurrentSession() ?? ""
            call.resolve(["url": url])
        }
    }

    // MARK: - Opt In/Out

    @objc func optOutOverall(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optOutOverall()
            call.resolve()
        }
    }

    @objc func optOutOfSchematicRecordings(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optOutOfSchematicRecordings()
            call.resolve()
        }
    }

    @objc func optInOverall(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optInOverall()
            call.resolve()
        }
    }

    @objc func optIntoSchematicRecordings(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optIntoSchematicRecordings()
            call.resolve()
        }
    }

    @objc func optInOverallStatus(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let status = UXCam.optInOverallStatus()
            call.resolve(["status": status])
        }
    }

    @objc func optInSchematicRecordingStatus(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let status = UXCam.optInSchematicRecordingStatus()
            call.resolve(["status": status])
        }
    }

    @objc func optInStatus(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let status = UXCam.isRecording()
            call.resolve(["status": status])
        }
    }

    @objc func optIn(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optInOverall()
            call.resolve()
        }
    }

    @objc func optOut(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UXCam.optOutOverall()
            call.resolve()
        }
    }

    // MARK: - Miscellaneous

    @objc func occludeRectsOnNextFrame(_ call: CAPPluginCall) {
        guard let rects = call.getArray("rects") as? [[NSNumber]] else {
            call.reject("Rects array is required")
            return
        }
        DispatchQueue.main.async {
            UXCam.occludeRects(onNextFrame: rects)
            call.resolve()
        }
    }

    @objc func setPushNotificationToken(_ call: CAPPluginCall) {
        guard let token = call.getString("token"), !token.isEmpty else {
            call.reject("Token is required")
            return
        }
        DispatchQueue.main.async {
            UXCam.setPushNotificationToken(token)
            call.resolve()
        }
    }

    @objc func reportBugEvent(_ call: CAPPluginCall) {
        guard let eventName = call.getString("eventName"), !eventName.isEmpty else {
            call.reject("Event name is required")
            return
        }
        let properties = call.getObject("properties")
        DispatchQueue.main.async {
            UXCam.reportBugEvent(eventName, properties: properties)
            call.resolve()
        }
    }
}
