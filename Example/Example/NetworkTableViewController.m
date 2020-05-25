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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    
    self.loading = YES;
    [self loadData];
}
- (IBAction)clear:(id)sender {
    
    self.dataArr = @[];
    
    [self.tableView reloadData];
}

- (void)loadData {
    
    [YMNetworkHelper get:api_banners parameters:nil headers:nil success:^(id  _Nullable responseObject) {
        self.loading = NO;
        
        self.dataArr = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        self.loading = NO;
        self.dataArr = @[];
        
        [self.tableView reloadData];
    }];
}



/// 按钮点击
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.loading = YES;
    
    [self loadData];
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
