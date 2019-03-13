//
//  YMNetworkHelper.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetworkHelper.h"
#import "AFNetworking.h"

NSString * const kLoading          = @"正在加载...";
NSString * const kLoadError        = @"加载失败";
NSString * const kNetError         = @"没有网络！";
NSString * const kSuccessful       = @"加载成功";
NSString * const kNoMoreData       = @"没有更多数据了";
NSString * const kURLError         = @"链接错误";
NSString * const kTransformError   = @"解析错误";
NSString * const kLoadSuccess      = @"获取数据成功";


NSInteger  const kSuccesCode = 0;
NSInteger  const kTokenOver = 10401; // token过期;

@implementation YMNetworkHelper

/// 有缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params cacheBlock:(YMRequestCache)cacheBlock callback:(APICallback)callback {
    
    /*
    if (![YMNetwork isNetwork]) {
        NSError *error = [NSError errorWithDomain:@"xx.com" code:0 userInfo:@{NSLocalizedDescriptionKey:kNetError}];
        if (callback) callback(nil,kNetError,error);
        return nil;
    }
     */
    NSString *urlStr = [kApiPrefix stringByAppendingString:api];
    if (urlStr.length == 0) {
        NSError *error = [NSError errorWithDomain:@"xx.com" code:0 userInfo:@{NSLocalizedDescriptionKey:kURLError}];
        if (callback) callback(nil,kURLError,error);
        return nil;
    }
    
    // 设置header
//    XKTokenModel  *tokenModel = [YMCacheHelper sharedCacheHelper].tokenModel;
//    NSString *header = [NSString stringWithFormat:@"%@ %@",tokenModel.token_type, tokenModel.access_token];
//    [YMNetwork setValue:header forHTTPHeaderField:@"Authorization"];
    
//    @weakify(self);
    return [YMNetwork requestMethod:YMNetworkMethodPOST url:urlStr params:params responseCache:cacheBlock success:^(id responseObject) {
//        @strongify(self);
        
        NSMutableDictionary *info = [responseObject mutableCopy];
        NSInteger code = [info[kServerCode] integerValue];

        if (code == kSuccesCode) // 成功
        {
            NSError *error = nil;
            id data = [self parseResponse:responseObject domain:urlStr error:&error];    
            if (callback) callback(data, info[kServerMsg] ? : kSuccessful, nil); 
        }
        else {
            switch (code) {
                    
//                case kTokenOver: // token失效
//                {
//                    [self rereshTokenCallback:^(id responseObject, NSString *msg, NSError *error) { 
//                        if (error) { 
//                            // 清空缓存
//                            [YMNetworkCache removeAllHttpCache];
//                            [YMCacheHelper removeAllCache];
//                            // 跳转登录界面
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                LoginVC *loginVC = [[LoginVC alloc] init];
//                                YMNavigationController *loginNavc = [[YMNavigationController alloc] initWithRootViewController:loginVC];
//                                [UIApplication sharedApplication].keyWindow.rootViewController = loginNavc;  
//                            });
//                        }else { // 重新开始这个请求
//                            [self postWithApi:api params:params cacheBlock:cacheBlock callback:callback];
//                        }
//                    }];
//                    break;
//                }
                default:
                {
                    if (callback) {
                        NSString *result = info[kServerMsg]?:kNetError;
                        NSError *error = [NSError errorWithDomain:urlStr code:code userInfo:@{NSLocalizedDescriptionKey : result}];
                        callback(nil, result, error);
                    }  
                    break;
                }
            }
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(nil,kLoadError,error);
        }
    }];
}

/// 使用body传数据
+ (NSURLSessionTask *)postBodyWithApi:(NSString *)api json:(id)json callback:(APICallback)callback {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置header
//    XKTokenModel  *tokenModel = [YMCacheHelper sharedCacheHelper].tokenModel;
//    NSString *header = [NSString stringWithFormat:@"%@ %@",tokenModel.token_type, tokenModel.access_token];
//    [manager.requestSerializer setValue:header forHTTPHeaderField:@"Authorization"];

    // data
    // jsonStr
    NSData *postData = [json dataUsingEncoding:NSUTF8StringEncoding]; 
    // dic
    //NSData *postData= [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    
    // url
    NSString *urlstr = [kApiPrefix stringByAppendingString:api];
    // body
    NSError *requestError = nil; 
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlstr parameters:nil error:&requestError];
    [request setHTTPBody:postData];
    
    NSLog(@"\n请求地址: %@ \n请求头:%@", urlstr,manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"请求参数:%@ \n",  json);
    
    NSURLSessionDataTask *dataTask = [manager.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) { 
        
        if (error) { // failed
            NSLog("\n请求失败：%@", error);
            if (callback) callback(nil,kLoadError,error);
        }
        else 
        { // succese
            NSError * error = nil;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSInteger code = [responseObject[kServerCode] integerValue];
            NSString *msg = responseObject[kServerMsg];
            
            if (error) {
                NSLog("\n解析数据失败：%@", responseObject);
                if (callback) callback(nil,kTransformError,error);
            }
            else if ( code!= kSuccesCode) {
                error = [NSError errorWithDomain:urlstr code:code userInfo:nil];
                if (callback) callback(nil,msg,error);
            }
            else {
                NSError *error = nil;
                id data = [self parseResponse:responseObject domain:urlstr error:&error];   
                NSLog("\n请求成功 数据：\n%@", responseObject);
                if ([NSThread isMainThread]) {
                    if (code == 10400) {
                        if (callback) callback(nil,data[kServerMsg],error);
                    }else {
                        if (callback) callback(data,data[kServerMsg],nil);
                    }
                    
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callback) callback(data,data[kServerMsg],nil);
                    });
                }
                
            }
        }
        
    }];
    [dataTask resume];
    return dataTask;
}

/// 无缓存
+ (NSURLSessionTask *)postWithApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback {
    return [self postWithApi:api params:params cacheBlock:nil callback:callback];
}

/// post的方式请求get的地址
+ (NSURLSessionTask *)postWithGetApi:(NSString *)api params:(NSDictionary *)params callback:(APICallback)callback {
    NSString *apiStr = [self createUrlWithApiName:api parameter:params];
    return [self postWithApi:apiStr params:nil callback:callback];
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
    return [info copy];
}

///  get的地址
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

#pragma mark - 业务公共方法
///// 重新获取token
//+ (NSURLSessionTask *)rereshTokenCallback:(APICallback)callback {
//    // 设置header
//    [YMNetwork setValue:@"Basic eGtzOnhrcw==" forHTTPHeaderField:@"Authorization"];
//    
//    NSString *urlStr = [kApiPrefix stringByAppendingString:url_refreshtoken];
//    
//    XKTokenModel  *tokenModel = [YMCacheHelper sharedCacheHelper].tokenModel;
//    NSDictionary *params = @{@"grant_type" : @"refresh_token"
//                             ,@"refresh_token" : tokenModel.refresh_token ? : @""
//                             };
//    
//    return [YMNetwork requestMethod:YMNetworkMethodPOST url:urlStr params:params success:^(id responseObject) {
//        
//        XKTokenModel *tokenModel = [XKTokenModel yy_modelWithJSON:responseObject];
//        [YMCacheHelper sharedCacheHelper].tokenModel = tokenModel;
//        if (callback) {
//            callback(nil,nil,nil);
//        }
//    } failure:^(NSError *error) {
//        if (callback) {
//            callback(nil,nil,error);
//        }
//    }];
//}

@end








