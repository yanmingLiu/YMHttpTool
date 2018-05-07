//
//  YMNetworkHelper.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetwork.h"
#import "YMNetworkCache.h"
#import "YMAPIConst.h"

extern NSString * const kLoading ;
extern NSString * const kLoadError;
extern NSString * const kNetError;
extern NSString * const kSuccessful;
extern NSString * const kNoMoreData;
extern NSString * const kURLError;
extern NSString * const kLoadSuccess;

/*
 ERROR_SERVER_BUSY(19999, "系统繁忙，请稍后再试"),
 ERROR_PARAM_WRONG(10400, "参数错误"),
 ERROR_REQUEST_WRONG(10405, "请求方式不允许"),
 ERROR_NOT_EXIST(10404, "数据不存在或已被删除"),
 ERROR_NO_AUTHORITY(10403, "无权进行此操作"),
 ERROR_SERVER_ERROR(10500, "服务器异常，请稍后再试"),
 ERROR_OPTION_FAIL(10415, "请求流格式错误，注意Content-type"),
 ERROR_NOT_LOGIN(10401, "用户未登录");
 */
extern NSInteger  const kSuccesCode;
extern NSInteger  const kTokenOver;


#define kServerMsg    @"msg"
#define kServerData   @"result"
#define kServerCode   @"code"

@interface YMNetworkHelper : NSObject

typedef void(^APICallback)(id responseObject, NSString *msg, NSError *error);

#pragma mark - 请求的公共方法

/// 无缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback;

/// 有缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params cacheBlock:(YMRequestCache)cacheBlock callback:(APICallback)callback;

/// post的方式请求get的地址
+ (NSURLSessionTask *)postWithGetApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback;

/// 使用body传数据
+ (NSURLSessionTask *)postBodyWithApi:(NSString *)api json:(id)json callback:(APICallback)callback;

#pragma mark - 业务公共方法
//+ (NSURLSessionTask *)rereshTokenCallback:(APICallback)callback;
//
//+ (NSString *)createUrlWithApiName:(NSString *)api parameter:(NSDictionary *)par ;

@end






