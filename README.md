# Cordova UXCam plugin

## Release Notes ##

See [CHANGELOG.md](CHANGELOG.md) for the full version history.

## Add UXCam plugin

STEP 1: INTEGRATE THE SDK WITH YOUR APP

    cordova plugin add cordova-uxcam

or

    phonegap plugin add cordova-uxcam

To remove the plugin:

    cordova/phonegap plugin remove cordova-uxcam

UXCam android SDK requires AndroidX; add this to your **config.xml** file

    <preference name="AndroidXEnabled" value="true" />

Supported platforms: android, ios

---

## iOS dependency installation (CocoaPods / SPM)

On iOS the plugin pulls in the native UXCam SDK. The dependency can be installed
with either **CocoaPods** (the default) or **Swift Package Manager (SPM)**. Pick the
one that matches how your iOS project manages native dependencies — you do **not**
need both.

### CocoaPods (default)

This is the default for both Cordova and Capacitor and requires no extra steps.

- **Cordova:** `cordova plugin add cordova-uxcam` reads [plugin.xml](plugin.xml) and
  installs the `UXCam` pod automatically when you build the iOS platform.
- **Capacitor:** after `npm install cordova-uxcam`, run `npx cap sync ios`. Capacitor
  uses [CordovaUxcam.podspec](CordovaUxcam.podspec) and runs `pod install` for you.

No manual `Podfile` editing is needed — the pod is declared by the plugin.

### Swift Package Manager (Capacitor only, opt-in)

SPM is supported for **Capacitor 6 and above** when the iOS project uses Swift Package
Manager instead of CocoaPods (i.e. it has no `Podfile` and an `ios/App/CapApp-SPM`
package). Cordova apps must use CocoaPods.

The plugin is described by [Package.swift](Package.swift), which depends on the
[`uxcam-ios-sdk`](https://github.com/uxcam/uxcam-ios-sdk) Swift package and accepts
`capacitor-swift-pm` `6.0.0 ..< 9.0.0`, so it works on Capacitor 6, 7 and 8.

Requirements:

- An SPM-based Capacitor app (Capacitor decides "SPM" by the presence of
  `ios/App/CapApp-SPM/`).
- iOS deployment target **13.0 or higher**.

Once your app is SPM-based, installation is the same on every version — there are
**no manual Xcode steps**. `npx cap sync ios` regenerates the CLI-managed
`ios/App/CapApp-SPM/Package.swift`, adds the `CordovaUxcam` package (resolved from
`node_modules/cordova-uxcam`) and pulls in the UXCam SDK automatically:

    npm install cordova-uxcam
    npx cap sync ios

The only difference between Capacitor versions is **how you get an SPM-based iOS
project** in the first place:

#### Capacitor 7 and above

SPM is fully supported. To convert an existing CocoaPods app, use the migration
assistant:

    npx cap spm-migration-assistant
    npx cap open ios

To start a brand-new iOS project on SPM instead:

    npx cap add ios --packagemanager SPM

Then install and sync as shown above.

#### Capacitor 6

SPM support is **experimental** (the CLI prints a "SPM Support is still experimental"
warning on every sync). There is **no** `spm-migration-assistant` in Capacitor 6, so
you cannot convert an existing CocoaPods project in place. Create the iOS project on
SPM instead:

    npx cap add ios --packagemanager SPM

(If you already have a CocoaPods `ios/` folder with no custom native changes, remove it
first with `rm -rf ios`, then run the command above and restore any customizations.)
Then install and sync as shown above.

> The Capacitor plugin self-registers under SPM via `CAPBridgedPlugin`
> (see the `#if SWIFT_PACKAGE` block in
> [src/ios/UXCamPlugin.swift](src/ios/UXCamPlugin.swift)), so no Objective-C
> registration file is required for SPM builds.

> **Note (non-Capacitor / native iOS only):** if you are integrating this package into
> a plain native iOS app — *not* a Capacitor app — you can add it through Xcode
> (File ▸ Add Package Dependencies…) using `https://github.com/uxcam/cordova-uxcam.git`
> and the `CordovaUxcam` product. Do **not** do this in a Capacitor app: `npx cap sync`
> already adds the package from `node_modules`, and a second (remote) reference creates
> a duplicate `CordovaUxcam` package that fails to build.

---

STEP 2: START UXCAM

Call the `startWithConfiguration` method when `deviceready` has fired to start the UXCam session:

#### `startWithConfiguration`

Starts the UXCam session
const configuration = {
    userAppKey: 'YOUR API KEY'
}
UXCam.startWithConfiguration(configuration);

Get your app key from the dashboard at www.uxcam.com

---

### Documentation

For other API calls see https://help.uxcam.com/hc/en-us/articles/360022226651-Tailor-For-Success

---

## Notes on Building a Plugin

To publish the project when you are happy with it: npm publish 'DIRECTORY NAME'

See also the helpful information
at: https://cordova.apache.org/announcements/2015/04/21/plugins-release-and-move-to-npm.html

