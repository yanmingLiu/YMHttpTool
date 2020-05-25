# YMNetwork


```

///  HTTP Request method.
typedef NS_ENUM(NSInteger, YMHTTPMethod) {
    YMHTTPMethodGET,
    YMHTTPMethodPOST,
    YMHTTPMethodHEAD,
    YMHTTPMethodPUT,
    YMHTTPMethodDELETE,
    YMHTTPMethodPATCH,
};

typedef NS_ENUM(NSUInteger, YMRequestSerializer) {
    /// 设置请求数据为JSON格式
    YMRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    YMRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, YMResponseSerializer) {
    /// 设置响应数据为JSON格式
    YMResponseSerializerJSON,
    /// 设置响应数据为二进制格式
    YMResponseSerializerHTTP,
};

@class AFHTTPSessionManager;

@interface YMNetwork : NSObject

/// 网络监听
+ (void)reachabilityStatusChangeBlock:(nullable void (^)(AFNetworkReachabilityStatus status))block;

/// 取消所有HTTP请求
+ (void)cancelAllRequest;

/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

/// 开启日志打印 (Debug级别)
+ (void)openLog;

/// 关闭日志打印,默认关闭
+ (void)closeLog;


/// 发起网络请求
/// @param method 请求方式
/// @param URLString 地址
/// @param parameters 参数
/// @param headers 请求头
/// @param progress 进度
/// @param success 成功回调
/// @param failure 失败回调
+ (nullable NSURLSessionDataTask *)requestWithMethod:(YMHTTPMethod)method
                                           URLString:(NSString *)URLString
                                          parameters:(nullable id)parameters
                                             headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                            progress:(nullable void (^)(NSProgress *progress))progress
                                             success:(nullable void (^)(id _Nullable responseObject))success
                                             failure:(nullable void (^)(NSError *error))failure;


/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(nullable void (^)(NSProgress *progress))progress
                              success:(void(^)(NSString *filePath))success
                              failure:(nullable void (^)(NSError *error))failure;



/*
 *******************************  AFHTTPSessionManager相关属性  *************************************
 */

#pragma mark 注意: 因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效

/// 设置网络请求参数的格式:默认为JSON格式
+ (void)setRequestSerializer:(YMRequestSerializer)requestSerializer;

/// 设置服务器响应数据格式:默认为JSON格式
+ (void)setResponseSerializer:(YMResponseSerializer)responseSerializer;

/// 设置服务器响应时间 默认30s
+ (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

/// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;


```

## Usage 使用方法

依赖AFNetworking  。

```
pod 'YMHttpTool'
```
### Import

```objc
#import "YMNetwork.h"
```

具体使用请查看demo YMNetworkHelper

### 根据业务需求修改YMNetworkHelper


```


#import "YMNetwork.h"
#import "YMAPIConst.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kLoading          = @"正在加载...";
static NSString * const kLoadError        = @"加载失败";
static NSString * const kNetError         = @"没有网络！";
static NSString * const kSuccessful       = @"加载成功";
static NSString * const kNoMoreData       = @"没有更多数据了";
static NSString * const kURLError         = @"链接错误";
static NSString * const kTransformError   = @"解析错误";
static NSString * const kLoadSuccess      = @"获取数据成功";

static NSInteger  const kSuccesCode  = 100;
static NSInteger  const kTokenOver   = 10401; // token过期;

static NSString * const kServerMsg   = @"msg";
static NSString * const kServerData  = @"data";
static NSString * const kServerCode  = @"status";


@interface YMNetworkHelper : NSObject

#pragma mark - 请求的公共方法


+ (void)get:(NSString *)api
 parameters:(nullable id)parameters
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(nullable void (^)(id _Nullable responseObject))success
    failure:(nullable void (^)(NSError *error))failure;


+ (void)post:(NSString *)api
  parameters:(nullable id)parameters
     headers:(nullable NSDictionary <NSString *, NSString *> *)headers
     success:(nullable void (^)(id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *error))failure;

+ (void)request:(YMHTTPMethod)method
            api:(NSString *)api
     parameters:(nullable id)parameters
        headers:(nullable NSDictionary <NSString *, NSString *> *)headers
       progress:(nullable void (^)(NSProgress *progress))progress
        success:(nullable void (^)(id _Nullable responseObject))success
        failure:(nullable void (^)(NSError *error))failure;



@end

```








