//
//  baseView.m
//  Show
//
//  Created by YAN Qingyang on 15-2-7.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseVC.h"
//#import "GlobalManager.h"




@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self UIGlobal];
    [self addObserverGlobal];
}

- (void)dealloc{
    [self removeObserverGlobal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 视图展示的时候优先展示为 home键在右边的 横屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

//statusbar 用白色字体
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)UIGlobal{
    
}

#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{

    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([self object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

- (BOOL)object:(id)obj isClass:(Class)aClass {
    if (![self isNULL:obj] && [obj isKindOfClass:aClass]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNULL:(id)obj{
    if (obj==nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

