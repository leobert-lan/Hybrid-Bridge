//
//  ScrollTouch.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/8.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "ScrollTouch.h"

@implementation ScrollTouch
@synthesize delegateTouch=_delegateTouch;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.dragging) {
        //run at ios5 ,no effect;
        [self.nextResponder touchesEnded: touches withEvent:event];
        if (self.delegateTouch && [self.delegateTouch respondsToSelector:@selector(scrollViewTouchesEnded:withEvent:inView:)]) {
            
            [self.delegateTouch scrollViewTouchesEnded:touches withEvent:event inView:self];
        }
    }
    [super touchesEnded:touches withEvent:event];
    
}

@end
