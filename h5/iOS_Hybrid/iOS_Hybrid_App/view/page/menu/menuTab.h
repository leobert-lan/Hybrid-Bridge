//
//  menuTab.h
//  CloudBox
//
//  Created by qyyan on 15/12/2.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "QYBaseTabBar.h"
enum  Enum_TabBar_Items {
    Enum_TabBar_Items_Home   = 0,
    Enum_TabBar_Items_Search,
    Enum_TabBar_Items_Msg,
};

@interface menuTab : QYBaseTabBar
/**
 *  初始化
 *
 *  @param dlg 托管delegate
 *
 *  @return 返回self
 */
- (id)initWithDelegate:(id)dlg;

//- (IBAction)btnClickAction:(id)sender;
@end
