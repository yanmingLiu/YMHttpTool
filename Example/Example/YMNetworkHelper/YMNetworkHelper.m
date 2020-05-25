//
//  YMNetworkHelper.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetworkHelper.h"
#import "AFNetworking.h"



@implementation YMNetworkHelper

+ (void)initialize {
    [YMNetwork openLog];
}

/// 配置公用headers
+ (NSDictionary *)headers {
    return nil;
}

/// 获取url
+ (NSString *)getUrl:(NSString *)api {
    return [kApiPrefix stringByAppendingString:api];
}

+ (void)get:(NSString *)api
 parameters:(nullable id)parameters
    headers:(nullable NSDictionary <NSString *, NSString *> *)headers
    success:(nullable void (^)(id _Nullable responseObject))success
    failure:(nullable void (^)(NSError *error))failure
{
    return [self request:(YMHTTPMethodGET) api:api parameters:parameters headers:headers progress:nil success:success failure:failure];
}

+ (void)post:(NSString *)api
  parameters:(nullable id)parameters
     headers:(nullable NSDictionary <NSString *, NSString *> *)headers
     success:(nullable void (^)(id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *error))failure
{
    return [self request:(YMHTTPMethodPOST) api:api parameters:parameters headers:headers progress:nil success:success failure:failure];
}

+ (void)request:(YMHTTPMethod)method
            api:(NSString *)api
     parameters:(nullable id)parameters
        headers:(nullable NSDictionary <NSString *, NSString *> *)headers
       progress:(nullable void (^)(NSProgress *progress))progress
        success:(nullable void (^)(id _Nullable responseObject))success
        failure:(nullable void (^)(NSError *error))failure
{
    [YMNetwork requestWithMethod:method URLString:[self getUrl:api] parameters:parameters headers:[self headers] progress:progress success:^(id  _Nullable responseObject) {
        
        NSMutableDictionary *info = [responseObject mutableCopy];
        NSInteger code = [info[kServerCode] integerValue];
        if (code == kSuccesCode) {
            success(responseObject);
        }
        else if (code == kTokenOver) {
            // token失效
            
            // 清空缓存
            // 跳转登录界面
            
        }
        else {
            NSString *result = info[kServerMsg]?:kLoadError;
            NSError *e = [NSError errorWithDomain:api code:code userInfo:@{NSLocalizedDescriptionKey : result}];
            failure(e);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 解析结果
+ (id)parseResponse:(id)responseObject domain:(NSErrorDomain)domain error:(NSError **)error
{
    NSMutableDictionary *info = [responseObject mutableCopy];
    // 解析内容
    if ([info[kServerCode] integerValue] != kSuccesCode) // failed
    {
        NSString *domainUrl = [[domain componentsSeparatedByString:@"?"] firstObject];
        *error = [NSError errorWithDomain:domainUrl code:0 userInfo:@{NSLocalizedDescriptionKey : info[kServerMsg]?:kNetError}];
        return nil;
    }
    //返回结果
    return info;
}

/// post的方式 但是使用get的地址方式传参使用
+ (NSString *)createUrlWithApiName:(NSString *)api parameter:(NSDictionary *)par {
    if (!api.length) {
        return nil;
    }
    NSString *url = api;
    if (par.count)
    {
        // 参数拼接
        NSMutableArray *keyValues = [[NSMutableArray alloc] init];
        for (NSString *key in par.allKeys)
        {
            id anyObject = [par objectForKey:key];
            NSString *value = anyObject;
            if ([anyObject isMemberOfClass:[NSArray class]])
            {
                // 如果是数组,值按","拼接
                value = [((NSArray *)anyObject) componentsJoinedByString:@","];
            }
            [keyValues addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        // 拼接keyValue
        url = [url stringByAppendingString:[keyValues componentsJoinedByString:@"&"]];
    }
    return url;
}



@end








