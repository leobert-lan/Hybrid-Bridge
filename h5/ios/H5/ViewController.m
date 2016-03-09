//
//  ViewController.m
//  H5
//
//  Created by Qingyang on 16/2/3.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "ViewController.h"
#import "H5VC.h"
#import "H5newVC.h"
#import "H5PlayerVC.h"
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
- (IBAction)H5newAction:(id)sender {
    H5newVC *vc = [[H5newVC alloc] initWithNibName:@"H5newVC" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)H5PlayerVCAction:(id)sender {
    H5PlayerVC *vc = [[H5PlayerVC alloc] initWithNibName:@"H5PlayerVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
