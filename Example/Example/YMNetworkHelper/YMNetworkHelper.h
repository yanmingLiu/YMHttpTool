//
//  YMNetworkHelper.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

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


NS_ASSUME_NONNULL_END




