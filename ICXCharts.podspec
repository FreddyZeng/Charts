Pod::Spec.new do |s|
  s.name = "ICXCharts"
  s.version = "0.1.1"
  s.summary = "Charts is a powerful & easy to use chart library for iOS, tvOS and OSX (and Android)"
  s.homepage = "https://git.icarbonx.com/ICX-iOS/ICXCharts"
  s.license = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.authors = "Daniel Cohen Gindi", "Philipp Jahoda"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source = { :git => "https://git.icarbonx.com/ICX-iOS/ICXCharts.git", :tag => "ICX#{s.version}", :branch => 'curVersion' }
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/Charts/**/*.swift"
  end
end
