//
//  ViewController.m
//  Chuangyiyun
//
//  Created by Qingyang on 16/5/4.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ViewController.h"
#import "mineVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //test develop git
}
- (IBAction)btnMineAction:(id)sender {
    mineVC *vc=(mineVC *)[QGLOBAL viewControllerName:@"mineVC" storyboardName:@"mineVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
