//
//  menuTab.m
//  CloudBox
//
//  Created by qyyan on 15/12/2.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "menuTab.h"
@interface menuTab ()
{
    NSString *path;
    id curSel;
//    NSString *
}
@end

@implementation menuTab

- (id)initWithDelegate:(id)dlg{
    self = [super init];
    if (self) {
        self.delegate=dlg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
    self.selectedIndex = Enum_TabBar_Items_Home;
//    [self getCurVC:Enum_TabBar_Items_Search];
    [[UITabBar appearance] setBackgroundColor:RGBHex(kColorGray207)];

}



/**
 *  初始化tab标签样式
 */
- (void)initTabBar
{
    QYTabbarItem *bar1=[QYTabbarItem new];
    bar1.title=@"首页";
    bar1.clazz=@"TaskHomeVC";
    bar1.storyboard=nil;//@"cloudBox";
    bar1.picNormal=@"Home";
    bar1.picSelected=@"Home_Select";
    bar1.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Home];
    
    QYTabbarItem *bar2=[QYTabbarItem new];
    bar2.title=@"需求管理";
    bar2.clazz=@"TaskMgrVC";
    bar2.storyboard=nil;
    bar2.picNormal=@"demand";
    bar2.picSelected=@"demand_Select";
    bar2.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Search];
    
    QYTabbarItem *bar3=[QYTabbarItem new];
    bar3.title=@"消息";
    bar3.clazz=@"MsgHomeVC";
    bar3.storyboard=nil;
    bar3.picNormal=@"news";
    bar3.picSelected=@"news_Select";
    bar3.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Msg];
    
   
    [self addTabBarItem:bar1,bar2,bar3,nil];//
}

- (void)getCurVC:(int)tag{
    if (tag<0||tag>=self.viewControllers.count) {
        return;
    }
    curSel=self.viewControllers[tag];
    
}
#pragma mark - didSelect
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    DLog(@"didSelectItem:%@",item);
//    if (item.tag!=Enum_TabBar_Items_Add) {
//        [self getCurVC:item.tag];
//    }
 
    //    [self showBadgePoint:YES itemTag:tabBarController.selectedIndex];
    //    [self showBadgeNum:99 itemTag:tabBarController.selectedIndex];
    //    UINavigationController *nav = self.arrTabItems[item.tag];
    //    if([nav.topViewController isKindOfClass:[UserCenterPageViewController class]]){
    //        UserCenterPageViewController *VC = (UserCenterPageViewController *)nav.topViewController;
    //        VC.tabBarItemSelected = YES;
    //    }
    
}


@end
