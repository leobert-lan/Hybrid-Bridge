//
//  LaunchVC.m
//  cyy_task
//
//  Created by Qingyang on 16/10/10.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

#pragma mark - UI
- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
@end
