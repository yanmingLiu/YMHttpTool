//
//  HUDTableViewController.m
//  Example
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "HUDTableViewController.h"
#import "MBProgressHUD+YM.h"

@interface HUDTableViewController ()

@end

@implementation HUDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏HUD" style:(UIBarButtonItemStylePlain) target:self action:@selector(hiddenHUD)];
}

- (void)hiddenHUD {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [MBProgressHUD showHUDAddedTo:self.view animated:YES text:@"正在加载"];
            break;
        case 1:
            [MBProgressHUD showSuccessText:@"操作成功"];
            break;
        case 2:
            [MBProgressHUD showFailureText:@"操作失败!"];
            break;
        case 3:
            [MBProgressHUD showToastText:@"提示信息"];
            break;
        case 4:
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            break;
        case 5:
        {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeDeterminate;
            HUD.progress = 0.5;
            HUD.contentColor = [UIColor blueColor];
            HUD.animationType = MBProgressHUDAnimationZoom;
            HUD.detailsLabel.text = @"自定义";
            
            
        }
            break;
            
        default:
            break;
    }
}

@end
