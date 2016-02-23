//
//  QWImageView.m
//  APP
//
//  Created by Yan Qingyang on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QYImageView.h"
#import "UIImageView+WebCache.h"
//#import "QWFileManager.h"
@implementation QYImageView
@synthesize  isEnable = isEnable_  ;

- (void)setCallbackRefForGesture:(int)ref key:(NSString *)key{
    
    if (refCallbackForGesture_ == nil) {
        refCallbackForGesture_ = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSNumber *numRef = [NSNumber numberWithInt:ref];
    [refCallbackForGesture_ setObject:numRef forKey:key];
    
}
- (int)getCallbackRefForGestureWithKey:(NSString *)key{
    NSNumber *refNum = [refCallbackForGesture_ objectForKey:key];
    if (refNum) {
        return [refNum intValue];
    }
    return 0;
}

- (void)setPlaceholderName:(NSString *)pname{
    if (self.image==nil && pname) {
        _placeholderName=pname;
        self.image=[UIImage imageNamed:pname];
    }
}

- (void)setImageURL:(NSString*)value  {
    if (self == nil) {
        return;
    }

//     NSString *imaPath =    [[NSBundle mainBundle] pathForResource:value ofType:nil];
// 
//    if ( [UIImage imageWithContentsOfFile:imaPath]||![value hasPrefix:@"http://"]) {
//      self.image = [UIImage imageNamed:value];
//        return ;
//    }

//    if ([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat: @"/Images/%@",value]]) {
//        self.image = [UIImage imageNamed:value];
//        return;
//    }
    NSString *pname=(self.placeholderName)?self.placeholderName:@"news_placeholder";

    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = self;
    [self setImageWithURL:[NSURL URLWithString:value]
        placeholderImage:[UIImage imageNamed:pname]
                 options:SDWebImageProgressiveDownload
                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    if (!activityIndicator) {
                        [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                        activityIndicator.center = weakImageView.center;
                        [activityIndicator startAnimating];
                    }
                }
               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                   [activityIndicator removeFromSuperview];
                   activityIndicator = nil;
               }];
}

#pragma mark -
#pragma mark gesture
- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
            if (gestureDelegate_ && [gestureDelegate_ respondsToSelector:@selector(getGestureRecognizer: )]) {
                [gestureDelegate_ performSelector:@selector(getGestureRecognizer: ) withObject:gestureRecognizer withObject:self];
            }
        }
    }else{
        if (gestureDelegate_ && [gestureDelegate_ respondsToSelector:@selector(getGestureRecognizer: )]) {
            [gestureDelegate_ performSelector:@selector(getGestureRecognizer: ) withObject:gestureRecognizer withObject:self];
        }
    }
}
- (void)addTapGesture{
    // 点击事件 1 ~ 5个手指 ， 1 ~ 3次点击
    [self setIsEnable:YES];
    UIGestureRecognizer *preGesture = nil;
    for (int i = 5; i >= 1; i--) {
        for (int j = 3; j>=1; j--) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            tapGestureRecognizer.delegate = self;
            tapGestureRecognizer.numberOfTouchesRequired = i;
            tapGestureRecognizer.numberOfTapsRequired = j;
            if (preGesture) {
                [tapGestureRecognizer requireGestureRecognizerToFail:preGesture];
            }
            [self addGestureRecognizer:tapGestureRecognizer];
            preGesture = tapGestureRecognizer;
            
        }
    }
}
- (void)addPinchGesture{
    [self setIsEnable:YES];
    if (pinchGesture_ == nil) {
        pinchGesture_ = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    }
    [self addGestureRecognizer:pinchGesture_];
}
- (void)addRotationGesture{
    [self setIsEnable:YES];
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:rotationGesture];
    
}
- (void)addSwipeGesture{
    [self setIsEnable:YES];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    if (panGesture_) {
        [panGesture_ requireGestureRecognizerToFail:swipeGesture];
    }
    [self addGestureRecognizer:swipeGesture];
    
    
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    if (panGesture_) {
        [panGesture_ requireGestureRecognizerToFail:swipeGesture];
    }
    [self addGestureRecognizer:swipeGesture];
    
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    if (panGesture_) {
        [panGesture_ requireGestureRecognizerToFail:swipeGesture];
    }
    [self addGestureRecognizer:swipeGesture];
    
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    if (panGesture_) {
        [panGesture_ requireGestureRecognizerToFail:swipeGesture];
    }
    [self addGestureRecognizer:swipeGesture];
    
    
}
- (void)addPanGesture{
    [self setIsEnable:YES];
    if (panGesture_ == nil) {
        panGesture_ = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    }
    [self addGestureRecognizer:panGesture_];
    
}
- (void)addlongPressGesture{
    [self setIsEnable:YES];
    for (int i = 5; i>=1; i--) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        longPress.numberOfTouchesRequired = i;
        [self addGestureRecognizer:longPress];
        
    }
}
#pragma mark -
#pragma mark gesture delegate
// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}


@end
