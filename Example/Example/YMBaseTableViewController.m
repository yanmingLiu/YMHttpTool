//
//  YMBaseTableViewController.m
//  Example
//
//  Created by lym on 2017/11/29.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMBaseTableViewController.h"

@interface YMBaseTableViewController ()

@end

@implementation YMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


#pragma mark - DZNEmptyDataSetSource

- (void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    
    _loading = loading;
    // 每次 loading 状态被修改，就刷新空白页面。
    [self.tableView reloadEmptyDataSet];
}

/// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    else {
        return [UIImage imageNamed:@"notNet"];
    }
}

/// 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"加载失败";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    if (self.loading) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/// 空白页按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"网络不给力，请点击重试哦~";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置所有字体大小为 #15
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:15.0]
                   range:NSMakeRange(0, text.length)];
    // 设置所有字体颜色为浅灰色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor lightGrayColor]
                   range:NSMakeRange(0, text.length)];
    // 设置指定4个字体为蓝色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor purpleColor]
                   range:NSMakeRange(7, 4)];
    
    if (self.loading) {
        return nil;
    }
    return attStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70.0f;
}


/// 图片动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

//// 设置空白页面的背景色
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    UIColor *appleGreenColor = [UIColor lightGrayColor];
//    return appleGreenColor;
//}

/// 返回自定义视图
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityView startAnimating];
//    return activityView;
//}
    

#pragma mark - DZNEmptyDataSetDelegate

/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.loading = YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.tableView.contentOffset = CGPointZero;
}

// 向代理请求图像视图动画权限。 默认值为NO。
// 确保从 imageAnimationForEmptyDataSet 返回有效的CAAnimation对象：
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}



@end
