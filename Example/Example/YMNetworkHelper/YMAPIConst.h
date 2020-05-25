//
//  YMAPIConst.h
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAPIConst : NSObject

#define ProductSever 0
#define DevelopSever 0
#define TestSever    1


/** 接口前缀 */
extern NSString *const kApiPrefix;

/** 高德地图key */ 
extern NSString *const AMapAPIKey;

/** IMkey */ 
extern NSString *const IMAPPKey;


@end



#pragma mark - 业务接口地址

// banner轮播
static NSString * const api_banners = @"/banners";
