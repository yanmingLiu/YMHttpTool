//
//  YMNetworkHelper.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetworkHelper.h"

NSString * const kLoading = @"正在加载...";
NSString * const kLoadError = @"加载失败";
NSString * const kNetError = @"没有网络！";
NSString * const kSuccessful = @"加载成功";
NSString * const kNoMoreData = @"没有更多数据了";


#define kServer_msg  @"msg"
#define kServer_ret  @"ret"
#define kServer_data  @"data"


@implementation YMNetworkHelper


#pragma mark - 公共方法

/// 无缓存
+ (NSURLSessionTask *)requestMethod:(YMNetworkMethod)method URL:(NSString *)urlStr params:(NSDictionary *)params callback:(requestCallblock)callback {

    if (![YMNetwork isNetwork]) {
        if (callback)  callback(nil,kNetError,nil, YES);
        return nil;
    }
    
    if (urlStr.length == 0) {
        NSError *error = [NSError errorWithDomain:@"xx.com" code:0 userInfo:@{NSLocalizedDescriptionKey:@"链接为空"}];
        if (callback) callback(nil, nil, error, NO);
        return nil;
    }
    
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    [YMNetwork setValue:@"510100" forHTTPHeaderField:@"X-ADCODE"];
    
    return [YMNetwork requestMethod:method URL:urlStr params:params success:^(id responseObject) {
        if (callback)
        {
            NSError *error = nil;
            NSDictionary *info = [self parseResponse:responseObject domain:urlStr error:&error];
            callback(info, info[kServer_msg], error, NO);
        }
    } failure:^(NSError *error) {
        if (callback)  callback(nil,kLoadError,error, NO);
    }];
}

/// 有缓存
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method URL:(NSString *)urlStr params:(NSDictionary *)params cacheBlock:(requestCacheBlock)cacheBlock callback:(requestCallblock)callback {

    if (![YMNetwork isNetwork]) {
        if (callback)  callback(nil,kNetError,nil, YES);
        return nil;
    }
    
    if (urlStr.length == 0) {
        NSError *error = [NSError errorWithDomain:@"xx.com" code:0 userInfo:@{NSLocalizedDescriptionKey:@"链接为空"}];
        if (callback) callback(nil, nil, error, NO);
        return nil;
    }
    
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // [YMNetwork setValue:@"" forHTTPHeaderField:@"X-AUTHTOKEN"];

    return [YMNetwork requestMethod:method URL:urlStr params:params responseCache:^(id responseCache) {
        if (cacheBlock) {
            NSError *error = nil;
            NSDictionary *info = [self parseResponse:responseCache domain:urlStr error:&error];
            callback(info, info[kServer_msg], error, NO);
        }
    } success:^(id responseObject) {
        if (callback)
        {
            NSError *error = nil;
            NSDictionary *info = [self parseResponse:responseObject domain:urlStr error:&error];
            callback(info, info[kServer_msg], error, NO);
        }
    } failure:^(NSError *error) {
        if (callback) callback(nil, kLoadError, error, YES);
    }];
    
}

+ (NSDictionary *)parseResponse:(id)responseObject domain:(NSErrorDomain)domain error:(NSError **)error
{
    NSMutableDictionary *info = [responseObject mutableCopy];
    // 解析内容
    if ([info[kServer_ret] integerValue] != kServer_code_200)   // 状态码 200 表示成功
    {
        NSString *domainUrl = [[domain componentsSeparatedByString:@"?"] firstObject];
        *error = [NSError errorWithDomain:domainUrl code:0 userInfo:@{NSLocalizedDescriptionKey : info[kServer_msg]?:kNetError}];
        
        return nil;
    }
    //返回结果
    return [info copy];
}



#pragma mark - 七牛上传
/*
/// 上传1张图片
+ (void)uploadWithImage:(UIImage*)image updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* key))callback
{
    if (image == nil || callback == nil)
        return;
    NSData* data = UIImageJPEGRepresentation(image, 1);
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[QNResolver systemResolver]];
        QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
        builder.dns = dns;
        //是否选择  https  上传
        builder.useHttps = YES;
        builder.zone = [[QNAutoZone alloc] initWithDns:dns];
        //设置断点续传
        NSError *error;
        builder.recorder =  [QNFileRecorder fileRecorderWithFolder:@"保存目录" error:&error];
    }];
    QNUploadManager* upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption* uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        NSLog(@"percent == %.2f", percent);
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    NSString *url =  [kApiPrefix stringByAppendingString:url_uptoken_qnPublic];
    
    if (updateType == QNUpdateImageTypePrivate) {
        url  = [kApiPrefix stringByAppendingString:url_uptoken_qnPrivate];
    }
    
    [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == kSuccess_code) {
            NSString *token = responseObject[@"data"][@"token"];
//            NSString *domain = responseObject[@"data"][@"domain"];
            
            [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.isOK) { NSLog(@"上传完成"); }
                key = [resp objectForKey:@"key"];
//                NSLog(@"info ===== %@", info);
//                NSLog(@"七牛返回信息resp ===== %@", resp);
//                NSLog(@"key===%@", key);
                
            }  option:uploadOption];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取七牛token失败");
    }];
}

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* keys))callback
{
    __block NSUInteger currentIndex = 0;
    __block NSMutableArray *keys = [NSMutableArray array];

    for (UIImage *img in imageArray) {
        [self uploadWithImage:img updateType:updateType withCallback:^(BOOL success, NSString *msg, NSString *key) {
            if (success) {
                currentIndex += 1;
                [keys addObject:key];
                NSLog(@"%@", key);
                if (currentIndex >= imageArray.count) {
                    callback(YES, @"上传成功",[keys componentsJoinedByString:@","]);
                    return ;
                }
            }else {
                callback(NO, @"上传图片失败", key);
                return ;
            }
        }];
    }
}

/// 七牛上传token
+ (NSURLSessionTask *)getQNTokenWithType:(QNUpdateImageType)type Success:(void (^)(NSString *publicToken))success {
    NSString *url;
    if (type == QNUpdateImageTypePrivate) {
        url  = [kApiPrefix stringByAppendingString:url_uptoken_qnPrivate];
    }else {
        url = [kApiPrefix stringByAppendingString:url_uptoken_qnPublic];
    }
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == kSuccess_code) {
            NSString *token = responseObject[@"data"][@"token"];
            NSString *domain = responseObject[@"data"][@"domain"];
            
            YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
            if (type == QNUpdateImageTypePublic) {
                loginModel.qiNiuPublicToken = token;
                loginModel.qiNiuPublicDomain = domain;
            }else {
                loginModel.qiNiuPrivateToken = token;
                loginModel.qiNiuPrivateDomain = domain;
            }
            [YMCacheHelper sharedCacheHelper].loginModel = loginModel;
            success(token);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取七牛token失败");
    }];    
}
 */
#pragma mark - 业务请求






@end








