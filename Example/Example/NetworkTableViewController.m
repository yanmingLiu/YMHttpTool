//
//  NetworkTableViewController.m
//  Example
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "NetworkTableViewController.h"
#import "YMNetworkHelper.h"
#import "NSDictionary+Params.h"

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

/// get地址post请求
- (void)load2 {
    // username=13330955821&password=kkkkkk&grant_type=password&scope=server
    NSDictionary *dic = @{@"username" : @"13330955821", @"password" : @"kkkkkk", @"grant_type" : @"password", @"scope" : @"server"};
    
    [YMNetworkHelper postWithGetApi:url_login params:dic callback:^(id responseObject, NSString *msg, NSError *error) {
        if (error) {
            NSLog(@"error -- %@ \nmsg:%@", error, msg);
        }else {
            
        }
        self.loading = NO;
    }];
}

/// 使用最原始YMNetworkHelper
- (void)load {
    NSString *url = [kApiPrefix stringByAppendingString:url_login];
    
    [YMNetworkHelper postWithApi:url params:nil callback:^(id responseObject, NSString *msg, NSError *error) {
        
    }];

}

/// 使用最原始YMNetwork
- (void)loadData {
    NSString *url = @"https://www.baidu.com";
    
    [YMNetwork requestMethod:YMNetworkMethodGET url:url params:nil success:^(id responseObject) {
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
    
    [self load2];
//    [self loadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArr.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
