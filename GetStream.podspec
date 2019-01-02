Pod::Spec.new do |s|
  s.name = "GetStream"
  s.version = "1.0.0"
  s.summary = "Swift Client - Build Activity Feeds & Streams with GetStream.io https://getstream.io"
  s.homepage = "https://github.com/GetStream/stream-swift"
  s.license = { :type => "BSD-3", :file => "LICENSE" }
  s.author = { "Alexey Bukhtin" => "alexey@getstream.io" }
  s.social_media_url = "https://getstream.io"
  s.swift_version = "4.2"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "9.0"
  s.source = { :git => "https://github.com/GetStream/stream-swift.git", :tag => s.version.to_s }
  s.default_subspecs = "Core", "Faye"
  
  s.subspec "Core" do |ss|
    ss.source_files = "Sources/Core/**/*"
    ss.framework = "Foundation"
    ss.dependency "Moya", "~> 12.0"
    ss.dependency "Result", "~> 4.1"
    ss.dependency "Swime", "~> 3.0"
    ss.dependency "JSONWebToken", "~> 2.2"
  end
  
  s.subspec "Faye" do |ss|
      ss.source_files = "Sources/Faye/*"
      ss.dependency "GetStream/Core"
      ss.dependency "Faye"
  end
  
  s.subspec "Token" do |ss|
    ss.source_files = "Sources/Token/"
    ss.dependency "GetStream/Core"
  end
end
