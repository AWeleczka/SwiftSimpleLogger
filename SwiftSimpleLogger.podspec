Pod::Spec.new do |s|
  s.name = "SwiftSimpleLogger"
  s.version = "0.0.2"
  s.summary = "Simple single-file logging for Swift 3"
  s.homepage = "https://github.com/AWeleczka/SwiftSimpleLogger/"
  s.license = {
    :type => "MIT",
    :file => "LICENSE"
  }

  s.author = "Alexander Weleczka"
  s.social_media_url = "http://twitter.com/AWeleczka/"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "3.1"
  s.tvos.deployment_target = "10.1"

  s.source = {
    :git => "https://github.com/AWeleczka/SwiftSimpleLogger.git",
    :tag => "#{s.version}"
  }
  s.source_files = "SwiftSimpleLogger/*.swift"
  s.exclude_files = "docs"
end
