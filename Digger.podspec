Pod::Spec.new do |s|
  s.name         = "Digger"
  s.version      = "0.0.6"
  s.summary      = "A lightweight download framework that requires only one line of code to complete the file download task"
  s.homepage     = "https://github.com/cornerAnt/Digger"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.ios.deployment_target = "8.0"
  s.author             = { "cornerant" => "kemeng0211@gmail.com" }
  s.source       = { :git => "https://github.com/cornerAnt/Digger.git", :tag =>  s.version  }
  s.source_files  = "Sources/*.swift"
end
