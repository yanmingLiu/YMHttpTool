# YMNetwork


对[PPNetwork](https://github.com/jkpang/PPNetworkHelper)修改添加请求方式；[PPNetwork](https://github.com/jkpang/PPNetworkHelper)是对AFNetworking 3.x 与YYCache的二次封装，支持GET、POST、文件上传/下载、网络状态监测的功能、络数据的缓存。

1.添加请求方式 : HEAD、PUT、DELETE、PATCH。

```
///  HTTP Request method.
typedef NS_ENUM(NSInteger, YMNetworkMethod) {
    YMKRequestMethodGET = 0,
    YMKRequestMethodPOST,
    YMKRequestMethodHEAD,
    YMKRequestMethodPUT,
    YMKRequestMethodDELETE,
    YMKRequestMethodPATCH,
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


### 根据需求修改YMNetworkHelper
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

@param responseObject 返回数据
@param msg 提示
@param noNetwork 是否有网络
*/

typedef void(^requestCallblock)(NSDictionary *responseObject, NSString *msg, NSError *erro, BOOL noNetwork);

/// 缓存
typedef void(^requestCacheBlock)(NSDictionary *responseCache);

@interface YMNetworkHelper : NSObject


#pragma mark - 请求的公共方法

/// 无缓存
+ (NSURLSessionTask *)requestMethod:(YMNetworkMethod)method URL:(NSString *)urlStr params:(NSDictionary *)params callback:(requestCallblock)callback;

/// 有缓存
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method  URL:(NSString *)urlStr params:(NSDictionary *)params cacheBlock:(requestCacheBlock)cacheBlock callback:(requestCallblock)callback;

```








