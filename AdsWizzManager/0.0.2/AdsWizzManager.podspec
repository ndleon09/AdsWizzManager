Pod::Spec.new do |s|

  s.name         = "AdsWizzManager"
  s.version      = "0.0.2"
  s.summary      = "AdsWizz library for IOS"
  s.homepage     = "https://github.com/ndleon09/AdsWizzManager"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Nelson Domínguez" => "ndleon09@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ndleon09/AdsWizzManager.git", :tag => "0.0.2" }
  s.source_files = "AdsWizzManager/*.{h,m}"
  s.requires_arc = true
  
  s.dependency "AFNetworking"

end
