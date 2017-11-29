//
//  YMNetworkHelper.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

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
 网络请求回调

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


#pragma mark - 七牛上传

/*
/// 上传1张图片
+ (void)uploadWithImage:(UIImage*)image updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* key))callback;

/// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* keys))callback;

/// 七牛上传token
+ (NSURLSessionTask *)getQNTokenWithType:(QNUpdateImageType)type Success:(void (^)(NSString *publicToken))success;
*/
 





@end






