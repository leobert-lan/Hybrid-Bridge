//
//  mineVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/5/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "mineVC.h"
#import "SetVC.h"
@interface mineVC ()

@end

@implementation mineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"我的"];
    [self naviLeftButtonImage:[UIImage imageNamed:@"toux"] highlighted:[UIImage imageNamed:@"toux"] action:@selector(navLeftAction:)];
}

#pragma mark - action
- (IBAction)navLeftAction:(id)sender{
    //    DLog(@">>>menu list");
    [QGLOBAL.mainFrame showLeftView];
}

- (IBAction)btnSetAction:(id)sender {
    SetVC *vc=(SetVC *)[QGLOBAL viewControllerName:@"SetVC" storyboardName:@"Set"];
    //vc.hidesMenu=YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
