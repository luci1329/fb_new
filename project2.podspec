Pod::Spec.new do |s|
  s.name         = "fbnew"
  s.version      = "1.0.0"
  s.summary      = "Testing purpose"
  s.homepage	 = ""
  s.license      = { :type => 'MWG license', :text => <<-LICENSE
   This code is property of www.mywebgrocer.com
    LICENSE
  }
  s.author       = { "Marius Ghita" => "marius.ghita@fortech.ro" }
  s.source       = { :git => 'https://github.com/luci1329/fb_new.git', :tag => s.version}
  s.platform     = :ios, "6.0"
  s.requires_arc = true

  s.source_files  = "fb_new/**/*.{h,m}"
end
