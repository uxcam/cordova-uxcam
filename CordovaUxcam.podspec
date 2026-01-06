require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'CordovaUxcam'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['homepage']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'src/ios/UXCamPlugin.swift', 'src/ios/UXCamPlugin.m'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.dependency 'Capacitor', '>= 2.0.0'
  s.static_framework = true # UXCam is a static framework
  s.dependency 'UXCam', '~> 3.7.6'
end
