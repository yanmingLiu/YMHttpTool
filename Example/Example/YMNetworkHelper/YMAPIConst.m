//
//  YMAPIConst.m
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMAPIConst.h"

@implementation YMAPIConst

#if ProductSever

NSString *const kApiPrefix =  @"https://gank.io/api/v2";

#elif DevelopSever

NSString *const kApiPrefix =  @"https://gank.io/api/v2";


#elif TestSever

NSString * const kApiPrefix = @"https://gank.io/api/v2";

#endif





@end
