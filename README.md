# YMNetwork


对[PPNetwork](https://github.com/jkpang/PPNetworkHelper)修改添加请求方式；[PPNetwork](https://github.com/jkpang/PPNetworkHelper)是对AFNetworking 3.x 与YYCache的二次封装，支持GET、POST、文件上传/下载、网络状态监测的功能、络数据的缓存。

1.添加请求方式 : HEAD、PUT、DELETE、PATCH。

```
///  HTTP Request method.
typedef NS_ENUM(NSInteger, YMNetworkMethod) {
    YMNetworkMethodGET,
    YMNetworkMethodPOST,
    YMNetworkMethodHEAD,
    YMNetworkMethodPUT,
    YMNetworkMethodDELETE,
    YMNetworkMethodPATCH,
};

```
2.返回添加网络监测回调，用来处理没有网络情况下页面。这里需要在请求之前就开启网络监测，我放在appDelegate。
   如果请求时才开启，第一次监测并不准，需要走AFNetworkReachabilityManager回调。

```
// 开启网络监听
[[AFNetworkReachabilityManager sharedManager] startMonitoring];
```
```
/**
网络请求回调
@param responseObject 返回数据
@param msg 提示
@param noNetwork 是否有网络
*/
typedef void(^requestCallblock)(NSDictionary *responseObject, NSString *msg, NSError *erro, BOOL noNetwork);
```

## Usage 使用方法

依赖AFNetworking YYCache 。

```
pod 'YMHttpTool'
```
### Import
```objc
#import "YMNetwork.h"
```

具体使用请查看demo YMNetworkHelper
demo另外添加了MBProgressHUD 分类，更容易添加HUD。
添加DZNEmptyDataSet（空页面的处理）。


### 根据业务需求修改YMNetworkHelper
```
#import "YMNetwork.h"
#import "YMAPIConst.h"

#define kServer_code_200   200
#define kServer_code_4001  4001 //权限发生改变
#define kServer_code_401   401 //被其它人员登录挤出去

extern NSString * const kLoading ;
extern NSString * const kLoadError;
extern NSString * const kNetError;
extern NSString * const kSuccessful;
extern NSString * const kNoMoreData;

/**
网络请求回调 - 可根据具体自己的需求修改返回值
*/
typedef void(^APICallback)(id responseObject, NSString *msg, NSError *error);


@interface YMNetworkHelper : NSObject

#pragma mark - 请求的公共方法

/// 无缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback;

/// 有缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params cacheBlock:(YMRequestCache)cacheBlock callback:(APICallback)callback;

/// post的方式请求get的地址
+ (NSURLSessionTask *)postWithGetApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback;

/// 使用body传数据
+ (NSURLSessionTask *)postBodyWithApi:(NSString *)api json:(id)json callback:(APICallback)callback;

```








