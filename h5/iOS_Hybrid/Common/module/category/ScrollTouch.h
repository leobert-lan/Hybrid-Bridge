//
//  ScrollTouch.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/8.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollTouchesDelegate;

@interface ScrollTouch : UIScrollView
@property (nonatomic,assign) id<ScrollTouchesDelegate> delegateTouch;
@end

@protocol ScrollTouchesDelegate <NSObject>
@optional
-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(id)scrollView;
@end