//
//  QWImageView.h
//  APP
//
//  Created by Yan Qingyang on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GestureDelegate <NSObject>

- (void)getGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

@end
@interface QYImageView : UIImageView<UIGestureRecognizerDelegate>
{
 
    //Gesture
    __unsafe_unretained id <GestureDelegate>     gestureDelegate_;
    UITapGestureRecognizer          *tapGesture_;
    UIPinchGestureRecognizer        *pinchGesture_;
    UIRotationGestureRecognizer     *rotationGesture_;
    UISwipeGestureRecognizer        *swipeGesture_;
    UIPanGestureRecognizer          *panGesture_;
    UILongPressGestureRecognizer    *longPressGesture_;
    NSMutableDictionary             *refCallbackForGesture_;
    
}
@property (nonatomic, retain) NSString *placeholderName;
@property (nonatomic, assign) BOOL isEnable;
- (void)setImageURL:(NSString*)value ;

// gesture listener ref in luastate
- (void)setCallbackRefForGesture:(int)ref key:(NSString *)key;
- (int)getCallbackRefForGestureWithKey:(NSString *)key;

- (void)addTapGesture;
- (void)addPinchGesture;
- (void)addRotationGesture;
- (void)addSwipeGesture;
- (void)addPanGesture;
- (void)addlongPressGesture;
 
@end
