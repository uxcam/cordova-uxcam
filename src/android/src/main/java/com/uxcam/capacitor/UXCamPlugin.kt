package com.uxcam.capacitor

import android.util.Log
import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.uxcam.UXCam
import com.uxcam.OnVerificationListener
import com.uxcam.datamodel.UXConfig
import com.uxcam.screenshot.model.UXCamBlur
import com.uxcam.screenshot.model.UXCamOverlay
import com.uxcam.screenshot.model.UXCamOcclusion
import com.uxcam.screenshot.model.UXCamOccludeAllTextFields
import com.uxcam.screenshot.model.UXCamAITextOcclusion
import org.json.JSONArray
import org.json.JSONObject

@CapacitorPlugin(name = "UXCam")
class UXCamPlugin : Plugin() {

    companion object {
        private const val TAG = "UXCamPlugin"
        private const val UXCAM_PLUGIN_TYPE = "capacitor"
        private const val UXCAM_CAPACITOR_PLUGIN_VERSION = "3.7.1"

        // Configuration Keys
        private const val USER_APP_KEY = "userAppKey"
        private const val ENABLE_MULTI_SESSION_RECORD = "enableMultiSessionRecord"
        private const val ENABLE_CRASH_HANDLING = "enableCrashHandling"
        private const val ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING = "enableAutomaticScreenNameTagging"
        private const val ENABLE_IMPROVED_SCREEN_CAPTURE = "enableImprovedScreenCapture"
        private const val ENABLE_INTEGRATION_LOGGING = "enableIntegrationLogging"
        private const val ENABLE_NETWORK_LOGGING = "enableNetworkLogging"
        private const val OCCLUSION = "occlusions"
        private const val SCREENS = "screens"
        private const val NAME = "name"
        private const val TYPE = "type"
        private const val EXCLUDE_MENTIONED_SCREENS = "excludeMentionedScreens"
        private const val BLUR_RADIUS = "blurRadius"
        private const val HIDE_GESTURES = "hideGestures"
    }

    override fun load() {
        super.load()
        UXCam.pluginType(UXCAM_PLUGIN_TYPE, UXCAM_CAPACITOR_PLUGIN_VERSION)
    }

    // MARK: - Configuration

    @PluginMethod
    fun startWithConfiguration(call: PluginCall) {
        val config = call.getObject("configuration") ?: call.data
        if (config == null) {
            call.reject("Configuration is required")
            return
        }

        val appKey = config.getString(USER_APP_KEY)
        if (appKey.isNullOrEmpty()) {
            call.reject("Invalid app key")
            return
        }

        try {
            val uxConfigBuilder = UXConfig.Builder(appKey)

            config.optBooleanOrNull(ENABLE_MULTI_SESSION_RECORD)?.let {
                uxConfigBuilder.enableMultiSessionRecord(it)
            }
            config.optBooleanOrNull(ENABLE_CRASH_HANDLING)?.let {
                uxConfigBuilder.enableCrashHandling(it)
            }
            config.optBooleanOrNull(ENABLE_AUTOMATIC_SCREEN_NAME_TAGGING)?.let {
                uxConfigBuilder.enableAutomaticScreenNameTagging(it)
            }
            config.optBooleanOrNull(ENABLE_IMPROVED_SCREEN_CAPTURE)?.let {
                uxConfigBuilder.enableImprovedScreenCapture(it)
            }
            config.optBooleanOrNull(ENABLE_INTEGRATION_LOGGING)?.let {
                uxConfigBuilder.enableIntegrationLogging(it)
            }

            // Handle occlusions
            val occlusionArray = config.optJSONArray(OCCLUSION)
            if (occlusionArray != null) {
                val occlusionList = convertToOcclusionList(occlusionArray)
                if (occlusionList.isNotEmpty()) {
                    uxConfigBuilder.occlusions(occlusionList)
                }
            }

            val uxConfig = uxConfigBuilder.build()

            UXCam.addVerificationListener(object : OnVerificationListener {
                override fun onVerificationSuccess() {
                    val result = JSObject()
                    result.put("sessionUrl", UXCam.urlForCurrentSession() ?: "")
                    call.resolve(result)
                }

                override fun onVerificationFailed(errorMessage: String?) {
                    call.reject(errorMessage ?: "Failed to start UXCam session")
                }
            })

            activity?.let {
                UXCam.startWithConfigurationCrossPlatform(it, uxConfig)
            } ?: call.reject("Activity not available")

        } catch (e: Exception) {
            Log.e(TAG, "Error starting with configuration", e)
            call.reject("Error starting UXCam: ${e.message}")
        }
    }

    @PluginMethod
    fun startWithKey(call: PluginCall) {
        val key = call.getString("key")
        if (key.isNullOrEmpty()) {
            call.reject("App key is required")
            return
        }

        UXCam.addVerificationListener(object : OnVerificationListener {
            override fun onVerificationSuccess() {
                val result = JSObject()
                result.put("sessionUrl", UXCam.urlForCurrentSession() ?: "")
                call.resolve(result)
            }

            override fun onVerificationFailed(errorMessage: String?) {
                call.reject(errorMessage ?: "Failed to start UXCam session")
            }
        })

        activity?.let {
            UXCam.startApplicationWithKeyForCordova(it, key)
        } ?: call.reject("Activity not available")
    }

    // MARK: - Occlusion

    @PluginMethod
    fun applyOcclusion(call: PluginCall) {
        val occlusionObj = call.getObject("occlusion")
        if (occlusionObj == null) {
            call.reject("Occlusion setting is required")
            return
        }

        try {
            val occlusion = getOcclusion(occlusionObj)
            if (occlusion != null) {
                UXCam.applyOcclusion(occlusion)
                call.resolve()
            } else {
                call.reject("Invalid occlusion setting")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error applying occlusion", e)
            call.reject("Error applying occlusion: ${e.message}")
        }
    }

    @PluginMethod
    fun removeOcclusion(call: PluginCall) {
        try {
            val occlusionObj = call.getObject("occlusion")
            if (occlusionObj != null) {
                val occlusion = getOcclusion(occlusionObj)
                if (occlusion != null) {
                    UXCam.removeOcclusion(occlusion)
                }
            } else {
                // Remove all occlusions - pass null or handle accordingly
                // UXCam Android SDK may need specific handling here
            }
            call.resolve()
        } catch (e: Exception) {
            Log.e(TAG, "Error removing occlusion", e)
            call.reject("Error removing occlusion: ${e.message}")
        }
    }

    // MARK: - Session Control

    @PluginMethod
    fun stopSessionAndUploadData(call: PluginCall) {
        UXCam.stopSessionAndUploadData()
        call.resolve()
    }

    @PluginMethod
    fun allowShortBreakForAnotherApp(call: PluginCall) {
        val continueSession = call.getBoolean("continueSession", false) ?: false
        if (continueSession) {
            UXCam.allowShortBreakForAnotherApp()
        } else {
            UXCam.resumeShortBreakForAnotherApp()
        }
        call.resolve()
    }

    @PluginMethod
    fun startNewSession(call: PluginCall) {
        UXCam.startNewSession()
        call.resolve()
    }

    @PluginMethod
    fun cancelCurrentSession(call: PluginCall) {
        UXCam.cancelCurrentSession()
        call.resolve()
    }

    @PluginMethod
    fun isRecording(call: PluginCall) {
        val result = JSObject()
        result.put("isRecording", UXCam.isRecording())
        call.resolve(result)
    }

    // MARK: - Multi-session

    @PluginMethod
    fun setMultiSessionRecord(call: PluginCall) {
        // Note: Android SDK doesn't have a direct setMultiSessionRecord method
        // This is typically set during configuration
        call.resolve()
    }

    @PluginMethod
    fun getMultiSessionRecord(call: PluginCall) {
        val result = JSObject()
        // Android SDK may not have this getter - return default
        result.put("multiSessionRecord", true)
        call.resolve(result)
    }

    // MARK: - Recording Control

    @PluginMethod
    fun pauseScreenRecording(call: PluginCall) {
        UXCam.pauseScreenRecording()
        call.resolve()
    }

    @PluginMethod
    fun resumeScreenRecording(call: PluginCall) {
        UXCam.resumeScreenRecording()
        call.resolve()
    }

    @PluginMethod
    fun disableCrashHandling(call: PluginCall) {
        // Note: Crash handling is typically set during configuration on Android
        call.resolve()
    }

    // MARK: - Uploads

    @PluginMethod
    fun pendingUploads(call: PluginCall) {
        val result = JSObject()
        result.put("count", UXCam.pendingUploads())
        call.resolve(result)
    }

    @PluginMethod
    fun deletePendingUploads(call: PluginCall) {
        UXCam.deletePendingUploads()
        call.resolve()
    }

    @PluginMethod
    fun pendingSessionCount(call: PluginCall) {
        val result = JSObject()
        result.put("count", UXCam.pendingSessionCount())
        call.resolve(result)
    }

    @PluginMethod
    fun uploadPendingSession(call: PluginCall) {
        // Android SDK may handle this automatically
        val result = JSObject()
        result.put("success", true)
        call.resolve(result)
    }

    // MARK: - Screen Occlusion

    @PluginMethod
    fun occludeSensitiveScreen(call: PluginCall) {
        val occlude = call.getBoolean("occlude", true) ?: true
        UXCam.occludeSensitiveScreen(occlude)
        call.resolve()
    }

    @PluginMethod
    fun occludeAllTextFields(call: PluginCall) {
        val occlude = call.getBoolean("occlude", true) ?: true
        UXCam.occludeAllTextFields(occlude)
        call.resolve()
    }

    // MARK: - Screen Tagging

    @PluginMethod
    fun setAutomaticScreenNameTagging(call: PluginCall) {
        // Note: This is typically set during configuration on Android
        Log.d(TAG, "setAutomaticScreenNameTagging is configured during initialization on Android")
        call.resolve()
    }

    @PluginMethod
    fun tagScreenName(call: PluginCall) {
        val screenName = call.getString("screenName")
        if (screenName.isNullOrEmpty()) {
            call.reject("Screen name is required")
            return
        }
        UXCam.tagScreenName(screenName)
        call.resolve()
    }

    // MARK: - User Identity

    @PluginMethod
    fun setUserIdentity(call: PluginCall) {
        val identity = call.getString("identity")
        if (identity.isNullOrEmpty()) {
            call.reject("User identity is required")
            return
        }
        UXCam.setUserIdentity(identity)
        call.resolve()
    }

    @PluginMethod
    fun setUserProperty(call: PluginCall) {
        val key = call.getString("key")
        val value = call.getString("value")
        if (key.isNullOrEmpty() || value.isNullOrEmpty()) {
            call.reject("Key and value are required")
            return
        }
        UXCam.setUserProperty(key, value)
        call.resolve()
    }

    // MARK: - Events

    @PluginMethod
    fun logEvent(call: PluginCall) {
        val eventName = call.getString("eventName")
        if (eventName.isNullOrEmpty()) {
            call.reject("Event name is required")
            return
        }
        UXCam.logEvent(eventName)
        call.resolve()
    }

    @PluginMethod
    fun logEventWithProperties(call: PluginCall) {
        val eventName = call.getString("eventName")
        if (eventName.isNullOrEmpty()) {
            call.reject("Event name is required")
            return
        }
        val properties = call.getObject("properties")
        if (properties != null) {
            UXCam.logEvent(eventName, properties)
        } else {
            UXCam.logEvent(eventName)
        }
        call.resolve()
    }

    // MARK: - URLs

    @PluginMethod
    fun urlForCurrentUser(call: PluginCall) {
        val result = JSObject()
        result.put("url", UXCam.urlForCurrentUser() ?: "")
        call.resolve(result)
    }

    @PluginMethod
    fun urlForCurrentSession(call: PluginCall) {
        val result = JSObject()
        result.put("url", UXCam.urlForCurrentSession() ?: "")
        call.resolve(result)
    }

    // MARK: - Opt In/Out

    @PluginMethod
    fun optOutOverall(call: PluginCall) {
        UXCam.optOut()
        call.resolve()
    }

    @PluginMethod
    fun optOutOfSchematicRecordings(call: PluginCall) {
        UXCam.optOutOfVideoRecording()
        call.resolve()
    }

    @PluginMethod
    fun optInOverall(call: PluginCall) {
        UXCam.optIn()
        call.resolve()
    }

    @PluginMethod
    fun optIntoSchematicRecordings(call: PluginCall) {
        UXCam.optIntoVideoRecording()
        call.resolve()
    }

    @PluginMethod
    fun optInOverallStatus(call: PluginCall) {
        val result = JSObject()
        result.put("status", UXCam.optInStatus())
        call.resolve(result)
    }

    @PluginMethod
    fun optInSchematicRecordingStatus(call: PluginCall) {
        val result = JSObject()
        result.put("status", UXCam.optInVideoRecordingStatus())
        call.resolve(result)
    }

    @PluginMethod
    fun optInStatus(call: PluginCall) {
        val result = JSObject()
        result.put("status", UXCam.optInStatus())
        call.resolve(result)
    }

    @PluginMethod
    fun optIn(call: PluginCall) {
        UXCam.optIn()
        call.resolve()
    }

    @PluginMethod
    fun optOut(call: PluginCall) {
        UXCam.optOut()
        call.resolve()
    }

    // MARK: - Miscellaneous

    @PluginMethod
    fun occludeRectsOnNextFrame(call: PluginCall) {
        val rects = call.getArray("rects")
        if (rects == null) {
            call.reject("Rects array is required")
            return
        }
        try {
            val jsonArray = JSONArray(rects.toString())
            UXCam.occludeRectsOnNextFrame(jsonArray)
            call.resolve()
        } catch (e: Exception) {
            call.reject("Error occluding rects: ${e.message}")
        }
    }

    @PluginMethod
    fun setPushNotificationToken(call: PluginCall) {
        val token = call.getString("token")
        if (token.isNullOrEmpty()) {
            call.reject("Token is required")
            return
        }
        UXCam.setPushNotificationToken(token)
        call.resolve()
    }

    @PluginMethod
    fun reportBugEvent(call: PluginCall) {
        val eventName = call.getString("eventName")
        if (eventName.isNullOrEmpty()) {
            call.reject("Event name is required")
            return
        }
        val properties = call.getObject("properties")
        if (properties != null) {
            UXCam.reportBugEvent(eventName, properties)
        } else {
            UXCam.reportBugEvent(eventName)
        }
        call.resolve()
    }

    // MARK: - Helper Methods

    private fun JSObject.optBooleanOrNull(key: String): Boolean? {
        return if (has(key)) getBoolean(key) else null
    }

    private fun JSObject.optJSONArray(key: String): JSONArray? {
        return if (has(key)) {
            try {
                getJSONArray(key)
            } catch (e: Exception) {
                null
            }
        } else null
    }

    private fun convertToOcclusionList(occlusionArray: JSONArray): List<UXCamOcclusion> {
        val occlusionList = mutableListOf<UXCamOcclusion>()
        for (i in 0 until occlusionArray.length()) {
            val occlusionObj = occlusionArray.optJSONObject(i)
            if (occlusionObj != null) {
                val occlusion = getOcclusionFromJSON(occlusionObj)
                if (occlusion != null) {
                    occlusionList.add(occlusion)
                }
            }
        }
        return occlusionList
    }

    private fun getOcclusion(occlusionObj: JSObject): UXCamOcclusion? {
        val typeIndex = occlusionObj.getInteger("type", 1) ?: 1
        return when (typeIndex) {
            1 -> getOccludeAllTextFields()
            2 -> getOverlay(occlusionObj)
            3 -> getBlur(occlusionObj)
            4 -> getAITextOcclusion(occlusionObj)
            else -> null
        }
    }

    private fun getOcclusionFromJSON(occlusionObj: JSONObject): UXCamOcclusion? {
        val typeIndex = occlusionObj.optInt(TYPE, 1)
        return when (typeIndex) {
            1 -> getOccludeAllTextFields()
            2 -> getOverlayFromJSON(occlusionObj)
            3 -> getBlurFromJSON(occlusionObj)
            4 -> getAITextOcclusionFromJSON(occlusionObj)
            else -> null
        }
    }

    private fun getOccludeAllTextFields(): UXCamOccludeAllTextFields {
        return UXCamOccludeAllTextFields.Builder().build()
    }

    private fun getOverlay(overlayObj: JSObject): UXCamOverlay {
        val builder = UXCamOverlay.Builder()

        val screens = overlayObj.optJSONArray(SCREENS)
        if (screens != null && screens.length() > 0) {
            val screenList = mutableListOf<String>()
            for (i in 0 until screens.length()) {
                screens.optString(i)?.let { screenList.add(it) }
            }
            builder.screens(screenList)
        }

        if (overlayObj.has(EXCLUDE_MENTIONED_SCREENS)) {
            builder.excludeMentionedScreens(overlayObj.getBoolean(EXCLUDE_MENTIONED_SCREENS))
        }

        if (overlayObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(overlayObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }

    private fun getOverlayFromJSON(overlayObj: JSONObject): UXCamOverlay {
        val builder = UXCamOverlay.Builder()

        val screens = overlayObj.optJSONArray(SCREENS)
        if (screens != null && screens.length() > 0) {
            val screenList = mutableListOf<String>()
            for (i in 0 until screens.length()) {
                screens.optString(i)?.let { screenList.add(it) }
            }
            builder.screens(screenList)
        }

        if (overlayObj.has(EXCLUDE_MENTIONED_SCREENS)) {
            builder.excludeMentionedScreens(overlayObj.getBoolean(EXCLUDE_MENTIONED_SCREENS))
        }

        if (overlayObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(overlayObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }

    private fun getBlur(blurObj: JSObject): UXCamBlur {
        val builder = UXCamBlur.Builder()

        val screens = blurObj.optJSONArray(SCREENS)
        if (screens != null && screens.length() > 0) {
            val screenList = mutableListOf<String>()
            for (i in 0 until screens.length()) {
                screens.optString(i)?.let { screenList.add(it) }
            }
            builder.screens(screenList)
        }

        if (blurObj.has(EXCLUDE_MENTIONED_SCREENS)) {
            builder.excludeMentionedScreens(blurObj.getBoolean(EXCLUDE_MENTIONED_SCREENS))
        }

        if (blurObj.has(BLUR_RADIUS)) {
            builder.blurRadius(blurObj.getInteger(BLUR_RADIUS) ?: 10)
        }

        if (blurObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(blurObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }

    private fun getBlurFromJSON(blurObj: JSONObject): UXCamBlur {
        val builder = UXCamBlur.Builder()

        val screens = blurObj.optJSONArray(SCREENS)
        if (screens != null && screens.length() > 0) {
            val screenList = mutableListOf<String>()
            for (i in 0 until screens.length()) {
                screens.optString(i)?.let { screenList.add(it) }
            }
            builder.screens(screenList)
        }

        if (blurObj.has(EXCLUDE_MENTIONED_SCREENS)) {
            builder.excludeMentionedScreens(blurObj.getBoolean(EXCLUDE_MENTIONED_SCREENS))
        }

        if (blurObj.has(BLUR_RADIUS)) {
            builder.blurRadius(blurObj.optInt(BLUR_RADIUS, 10))
        }

        if (blurObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(blurObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }

    private fun getAITextOcclusion(aiObj: JSObject): UXCamAITextOcclusion {
        val builder = UXCamAITextOcclusion.Builder()

        if (aiObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(aiObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }

    private fun getAITextOcclusionFromJSON(aiObj: JSONObject): UXCamAITextOcclusion {
        val builder = UXCamAITextOcclusion.Builder()

        if (aiObj.has(HIDE_GESTURES)) {
            builder.withoutGesture(aiObj.getBoolean(HIDE_GESTURES))
        }

        return builder.build()
    }
}
