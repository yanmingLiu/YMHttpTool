//
//  NetworkTableViewController.m
//  Example
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "NetworkTableViewController.h"
#import "MBProgressHUD+YM.h"
#import "YMNetworkHelper.h"

static NSString* EmptyImage = @"nothing";

@interface NetworkTableViewController ()


@property (nonatomic, strong) NSMutableArray * dataArr; 


@end

@implementation NetworkTableViewController


- (void)load {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [kApiPrefix stringByAppendingString:url_home_keywords];
    
    [YMNetworkHelper requestMethod:YMKRequestMethodGET URL:url params:nil callback:^(NSDictionary *responseObject, NSString *msg, NSError *error, BOOL noNetwork) {
        
        // 隐藏hud
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        if (noNetwork) { // 没有网络处理空界面
            NSLog(@"没有网络");
            self.loading = NO;
            return ;
        }
        
        if (responseObject) {// 成功处理数据
            [MBProgressHUD showSuccessText:msg];
            
            self.dataArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            
            if (self.dataArr.count) {
                [self.tableView reloadData];
            }
            
            if (self.dataArr.count == 0) {
                self.loading = NO;
            }
        }
        else { // 失败
            [MBProgressHUD showFailureText:msg];
            if (self.dataArr.count == 0) {
                self.loading = NO;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加载数据" style:(UIBarButtonItemStylePlain) target:self action:@selector(load)];
            
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.loading = YES;
    
    [self load];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.dataArr.count) {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
