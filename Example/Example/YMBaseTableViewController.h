//
//  YMBaseTableViewController.h
//  Example
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface YMBaseTableViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 是否加载处理空页面 */
@property (nonatomic, getter=isLoading) BOOL loading;

@end
