//
//  ViewController.m
//  H5
//
//  Created by Qingyang on 16/2/3.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "ViewController.h"
#import "H5VC.h"
//#import "ViewController2.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)H5Action:(id)sender{
    H5VC *vc=[[H5VC alloc] initWithNibName:@"H5VC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
