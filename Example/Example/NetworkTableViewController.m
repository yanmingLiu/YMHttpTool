//
//  NetworkTableViewController.m
//  Example
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "NetworkTableViewController.h"
#import "YMNetworkHelper.h"

static NSString* EmptyImage = @"nothing";

@interface NetworkTableViewController ()


@property (nonatomic, strong) NSArray * dataArr; 


@end

@implementation NetworkTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loading = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

/// 使用最原始YMNetworkHelper
- (void)load {
    NSString *url = [kApiPrefix stringByAppendingString:url_login];
    [YMNetworkHelper requestMethod:YMKRequestMethodGET URL:url params:nil callback:^(NSDictionary *responseObject, NSString *msg, NSError *erro, BOOL noNetwork) {
        if (noNetwork) {
            NSLog("没有网络");
        }
    }];
}

/// 使用最原始YMNetwork
- (void)loadData {
    NSString *url = @"https://www.baidu.com";
    
    [YMNetwork requestMethod:YMKRequestMethodGET URL:url params:nil success:^(id responseObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    }];
     
     self.dataArr = @[@1,@1,@1,@1,@1];
     [self.tableView reloadData];
}



/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.loading = YES;
    
//    [self load];
    [self loadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArr.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
