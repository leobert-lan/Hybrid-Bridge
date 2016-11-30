//
//  QWBaseTabBar.m
//  APP
//
//  Created by Yan Qingyang on 15/3/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QYBaseTabBar.h"


@implementation QYTabbarItem

@end


@interface QYBaseTabBar()
{
    NSMutableArray * arrBadges;
    UIButton *btnCenter;
}
@end

@implementation QYBaseTabBar
@synthesize arrTabItems;


- (void)viewDidLoad{
    [super viewDidLoad];
//    [self addCenterButtonWithImage:[UIImage imageNamed:@"shangc"] highlightImage:[UIImage imageNamed:@"shangc"]];
}

- (void)addTabBarItem:(QYTabbarItem*)firstObject, ... {
    
    arrTabItems=nil;
    arrTabItems = [NSMutableArray array];
    
    NSMutableArray * arrTags = [NSMutableArray array];
    
    UINavigationController * nav = nil;
    
    if (firstObject)
    {
        
        va_list args;
        va_start(args, firstObject);
        for (QYTabbarItem *obj = firstObject; obj != nil; obj = va_arg(args,QYTabbarItem*)) {
            id vc=nil;
            if (obj.storyboard) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:obj.storyboard bundle:nil];
                vc = [sb instantiateViewControllerWithIdentifier:obj.clazz];
            }
            else if (obj.clazz) {
                vc=[[NSClassFromString(obj.clazz) alloc] initWithNibName:obj.clazz bundle:nil];
            }
            
            if (vc)
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
            else nav=[[UINavigationController alloc] init];
            
            UITabBarItem *item = [self createTabBarItem:obj.title normalImage:obj.picNormal selectedImage:obj.picSelected itemTag:obj.tag.integerValue];
            nav.tabBarItem = item;
            [arrTabItems addObject:nav];
            [arrTags addObject:obj.tag];
        }
        va_end(args);
        
        [self addBadge:arrTags];
        self.viewControllers = arrTabItems;
    }
}

- (UITabBarItem *)createTabBarItem:(NSString *)strTitle normalImage:(NSString *)strNormalImg selectedImage:(NSString *)strSelectedImg itemTag:(NSInteger)intTag
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strTitle image:nil tag:intTag];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBHex(kColorGray202), NSForegroundColorAttributeName,fontSystem(kFontS22), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBHex(kColorMain001), NSForegroundColorAttributeName,fontSystem(kFontS22), NSFontAttributeName,  nil] forState:UIControlStateSelected];
    
    if (iOSv7) {
        if (strNormalImg)
            [item setImage:[[UIImage imageNamed:strNormalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        if (strSelectedImg)
            [item setSelectedImage:[[UIImage imageNamed:strSelectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        [item setFinishedSelectedImage:[UIImage imageNamed:strSelectedImg] withFinishedUnselectedImage:[UIImage imageNamed:strNormalImg]];
#endif
    }
    return item;
}

#pragma mark - 中间按钮
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    CGFloat ww=buttonImage.size.width;
    CGFloat hh=buttonImage.size.height;
    
    //
    ww=60;hh=60;
    
    btnCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCenter setBackgroundColor:[UIColor clearColor]];
    
    btnCenter.frame = CGRectMake(0.0, 0.0, ww,hh);//buttonImage.size.width, buttonImage.size.height);
    [btnCenter setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnCenter setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = hh - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        btnCenter.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0 - 8/2;
        btnCenter.center = center;
    }
    [btnCenter addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnCenter];
}
#pragma mark - hide
-(void)hideTabBar:(BOOL)hidden{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
                
            }else{
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
                
            }
        }
        else if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                
            }else{
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                
            }
        }
    }
    btnCenter.hidden=hidden;
    [UIView commitAnimations];
    
    [self.view bringSubviewToFront:btnCenter];
//    btnCenter.alpha=0;
//    [UIView animateWithDuration:0.15 animations:^{
//        btnCenter.alpha=1;
//    } completion:^(BOOL finished) {
//        [self.view bringSubviewToFront:btnCenter];
//    }];
}
/**
 *  按钮添加红点
 *
 *  @param tags 所有按钮的tag
 */
- (void)addBadge:(NSArray*)tags{
    arrBadges = nil;
    arrBadges = [NSMutableArray array];
    
    CGFloat ww = APP_W/tags.count;
    CGRect frm=(CGRect){0,7,10,10};
    
    int i = 0;
    
    for (NSString *obj in tags) {
        frm.origin.x=ww*i+45.f;//AutoValue(45.f);
        
        UIImageView *imgIcon;
        imgIcon = [[UIImageView alloc] initWithFrame:frm];
        imgIcon.tag=obj.integerValue;
        imgIcon.layer.cornerRadius = 4.2;
        imgIcon.layer.masksToBounds = YES;
        imgIcon.backgroundColor = RGBHex(kColorGray205);
        imgIcon.hidden = YES;
        [self.tabBar addSubview:imgIcon];
        [arrBadges addObject:imgIcon];
        
        i++;
    }
    
}

- (void)showBadgePoint:(BOOL)enabled itemTag:(NSInteger)intTag
{
    for (UIImageView *obj in arrBadges) {
        if (obj.tag==intTag) {
            [self.tabBar bringSubviewToFront:obj];
            obj.hidden=!enabled;
        }
    }
}

- (void)showBadgeNum:(NSInteger)num itemTag:(NSInteger)intTag{
    int i = 0;
    for (UINavigationController *obj in arrTabItems) {
        if (obj.tabBarItem.tag==intTag) {
            if (num<=0)
                obj.tabBarItem.badgeValue=nil;
            else if(num>999)
                obj.tabBarItem.badgeValue=@"...";
            else
                obj.tabBarItem.badgeValue=[NSString stringWithFormat:@"%li",(long)num];
        }
        i++;
    }
}

#pragma mark - didSelect
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    DLog(@"didSelectItem:%@",item);
}

- (IBAction)btnClickAction:(id)sender{
//    DLog(@"+++");
}

#pragma mark - 屏幕方向 禁止旋转
// 允许自动旋转，在支持的屏幕中设置了允许旋转的屏幕方向。
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//// 支持的屏幕方向，这个方法返回 UIInterfaceOrientationMask 类型的值。
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//// 视图展示的时候优先展示为 home键在右边的 横屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//#pragma mark - 禁止旋转
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//-(BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
@end
