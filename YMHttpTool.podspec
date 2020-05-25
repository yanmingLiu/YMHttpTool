

Pod::Spec.new do |s|

  s.name         = "YMHttpTool"

  s.version      = "1.1.1"

  s.summary      = "AFNetworking 4.x封装的网络工具"

  s.description  = "AFNetworking 第一次封装，通常app需要封装2层，业务层需要再封装一层，示例YMNetworkHelper针对业务层封装"

  s.homepage     = "https://github.com/yanmingLiu/YMHttpTool"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "LiuYanming" => "374402328@qq.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/yanmingLiu/YMHttpTool.git", :tag => s.version }

  s.source_files  = "YMHttpTool/*.{h,m}"

  # s.frameworks = "SomeFramework", "AnotherFramework"

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  
 s.dependency 'AFNetworking'

end
