//
//  sideMenuVC.h
//  cyy_task
//
//  Created by Qingyang on 16/7/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(int, SideMenuCell) {
    SideMenuCellInfo = 0,
    SideMenuCellFavo,
    SideMenuCellPerso ,
    SideMenuCellComp ,
    SideMenuCellSet ,
    SideMenuCellProp,
};

//typedef NS_ENUM(int, SideMenuType) {
//    SideMenuTypeDisenabled = 0,
//    SideMenuType,
//    SideMenuCellPerso ,
//    SideMenuCellComp ,
//    SideMenuCellSet ,
//    SideMenuCellProp,
//};
@interface sideMenuVC : BaseViewController
{
//    IBOutlet
}
- (void)setUserInfo:(id)model;
- (void)updateAvatar:(UIImage*)avatar;
@end
