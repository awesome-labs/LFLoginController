Pod::Spec.new do |s|
  s.name         = "LFLoginController"
  s.version      = "0.1"
  s.summary      = "Creating Login screens is boring and repetitive. What about implementing and customizing them in less then 10 lines of code?"
  s.homepage     = "https://github.com/awesome-labs/LFLoginController/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Lucas Farah" => "lucas.farah@me.com" }
  s.social_media_url   = "https://twitter.com/7farah7"
  s.platform     = :ios
  s.dependency '1PasswordExtension', '1.8.2'
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/awesome-labs/LFLoginController.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
end