
Pod::Spec.new do |s|

  s.name         = "LCPageView"
  s.version      = "0.0.1"

  s.homepage     = "http://EXAMPLE/LCPageView"

  s.license      = "MIT"

  s.author             = { "lianchen" => "lianchen551@163.com" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "http://EXAMPLE/LCPageView.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"


end
