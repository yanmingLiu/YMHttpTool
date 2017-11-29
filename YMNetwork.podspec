

Pod::Spec.new do |s|

  s.name         = "YMHttpTool"

  s.version      = "0.0.2"

  s.summary      = "AFNetworking 3.x封装的网络工具"

  s.description  = "对PPNetwork(https://github.com/jkpang)修改-添加请求方式"

  s.homepage     = "https://github.com/yanmingLiu/YMHttpTool"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = { "LiuYanming" => "374402328@qq.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/yanmingLiu/YMHttpTool.git", :tag => s.version }

  s.source_files  = "YMHttpTool"

  # s.frameworks = "SomeFramework", "AnotherFramework"

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  
  s.dependency 'AFNetworking'

  s.dependency 'YYCache'

end
