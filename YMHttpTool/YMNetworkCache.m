//
//  YMNetworkCache.m
//  RACDemo
//
//  Created by lym on 2017/7/18.
//
//

#import "YMNetworkCache.h"
#import "YYCache.h"

static NSString *const kNetworkResponseCache = @"kNetworkResponseCache";

@implementation YMNetworkCache


+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [[self dataCache] setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [[self dataCache] objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [[self dataCache].diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [[self dataCache].diskCache removeAllObjects];
}

+ (YYCache *)dataCache {
    return [YYCache cacheWithName:kNetworkResponseCache];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];    
    return [NSString stringWithFormat:@"%@%@",URL,paraString];
}

@end
