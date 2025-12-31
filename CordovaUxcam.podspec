Pod::Spec.new do |s|
  s.name             = 'CordovaUxcam'
  s.version          = '3.7.1'
  s.summary          = 'Cordova plugin for UXCam - enables the recording of your applications screen'
  s.description      = <<-DESC
    UXCam Cordova plugin that enables session recording and analytics for mobile apps.
    Works with Cordova and Capacitor (CocoaPods and SPM).
  DESC
  s.homepage         = 'https://github.com/uxcam/cordova-uxcam'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'UXCam Inc.' => 'support@uxcam.com' }
  s.source           = { :git => 'https://github.com/uxcam/cordova-uxcam.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.static_framework = true

  s.source_files = 'src/ios/*.{h,m}'

  s.dependency 'CapacitorCordova'
  s.dependency 'UXCam', '~> 3.7.5'
end
