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

#pragma mark - 公共接口地址

/** 注册 */ 
extern NSString * const url_register;

/** 登录 */ 
extern NSString * const url_login;

#pragma mark - 业务接口地址

//关键词
extern NSString * const url_home_keywords;




@end
