
Pod::Spec.new do |s|

  s.name         = "LCPageView"
  s.version      = "0.0.1"
  s.summary      = "LCPageView"

  s.homepage     = "http://EXAMPLE/LCPageView"

  s.license      = "MIT"

  s.author             = { "lianchen" => "lianchen551@163.com" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/CoderLineChan/LCPageView.git", :tag => "#{s.version}" }

  s.source_files  = "Source/**/*.{h,m}"


end
