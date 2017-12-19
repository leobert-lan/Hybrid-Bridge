//
//  QWBaseTabBar.h
//  APP
//
//  Created by Yan Qingyang on 15/3/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

/**
  *  clazz          页面类名字
  *  picNormal      默认图片名字
  *  picSelected    选择图片名字
  *  title          标题
  *  tag            编号
 */
@interface QYTabbarItem : BaseModel
@property (nonatomic,strong) NSString *clazz;
@property (nonatomic,strong) NSString *storyboard;
//@property (nonatomic,strong) NSString *nib;
@property (nonatomic,strong) NSString *picNormal;
@property (nonatomic,strong) NSString *picSelected;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *tag;

@end

@interface QYBaseTabBar : UITabBarController
@property (nonatomic,strong) NSMutableArray * arrTabItems;

/**
 *  添加tababr 按钮，加nil结尾
 *
 *  @param firstObject QWTabbarItem对象格式
 */
- (void)addTabBarItem:(QYTabbarItem*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  按钮上的红点
 *
 *  @param enabled 显示/关闭红点
 *  @param intTag  按钮tag值
 */
- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)intTag;

/**
 *  显示按钮badge数字
 *
 *  @param num    要显示的数字，<=0不显示，大于99显示"..."
 *  @param intTag 按钮tag值
 */
- (void)showBadgeNum:(NSInteger)num itemTag:(NSInteger)intTag;

- (void)hideTabBar:(BOOL)hidden;
@end
