//
//  DragButton.m
//  CloudBox
//
//  Created by Qingyang on 16/3/22.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "DragButton.h"

@implementation DragButton

- (void)setupLongPress {
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)] ;
    [panGr setMinimumNumberOfTouches:1];
    [panGr setMaximumNumberOfTouches:1];
//    [panGr setDelegate:self];
    [self addGestureRecognizer:panGr];
}

#pragma mark - move
- (IBAction)moveAction:(id)sender{
    UIGestureRecognizerState pState=[(UIPanGestureRecognizer*)sender state];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.superview];

    if(pState == UIGestureRecognizerStateBegan) {
        [self setSelected:YES];
        
        firstX = [self center].x;
        firstY = [self center].y;
        
        
    }
    
    
    CGFloat xx=(firstX+translatedPoint.x)>0?(firstX+translatedPoint.x):0;
    CGFloat yy=(firstY+translatedPoint.y)>0?(firstY+translatedPoint.y):0;
    xx=(xx<self.superview.bounds.size.width)?xx:self.superview.bounds.size.width;
    yy=(yy<self.superview.bounds.size.height)?yy:self.superview.bounds.size.height;
    
    translatedPoint = CGPointMake(xx, yy);
    [self setCenter:translatedPoint];
 
    if  (pState == UIGestureRecognizerStateEnded) {
        [self setSelected:NO];
        
        //弹性贴边
        CGFloat hh = self.bounds.size.height/2;
        CGFloat ww = self.bounds.size.width/2;
        CGFloat margin = 2;
        
        if (xx-ww-margin<0) {
            xx=ww+margin;
        }
        if (yy-hh-margin<0) {
            yy=hh+margin;
        }
        
        if (xx+ww+margin>self.superview.bounds.size.width) {
            xx=self.superview.bounds.size.width-ww-margin;
        }
        if (yy+hh+margin>self.superview.bounds.size.height) {
            yy=self.superview.bounds.size.height-hh-margin;
        }
        
        CGPoint endPoint = CGPointMake(xx, yy);
//        [self setCenter:translatedPoint];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setFromValue:[NSValue valueWithCGPoint:translatedPoint]];
        [animation setToValue:[NSValue valueWithCGPoint:endPoint]];
        [animation setDuration:.25];
        [self.layer setPosition:endPoint];
        [self.layer addAnimation:animation forKey:nil];
    }
}

#pragma mark - 按钮尺寸更改
/*
// 放大
- (void)changeBig {
    self.transform = CGAffineTransformScale(self.transform,1.25,1.25);
    self.backgroundColor = [UIColor colorWithHexString:@"E0E0E0" alpha:1];
}

// 还原
- (void)changeBack {
    self.transform = CGAffineTransformScale(self.transform,0.8,0.8);
    // 按钮放大还原后会有偏移，所以要设置回正常位置，80和100是按钮尺寸
    self.frame = CGRectMake(_framePoint.x, _framePoint.y, 80, 100);
}
*/
#pragma mark - 手势管理
/*
 * 手势响应，并判断状态
 **/
- (void)longPressToDo:(UILongPressGestureRecognizer *)press {
    if ([press state] == UIGestureRecognizerStateBegan) {
        [self beganTouch:press];
//        [self changeBig]; // 放大
    }
    else if ([press state] == UIGestureRecognizerStateChanged) {
        [self movedTouch:press];
    }
    else if ([press state] == UIGestureRecognizerStateEnded){
        [self endedTouch:press];
    }
}

/*
 * 手势长按开始
 **/
- (void)beganTouch:(UILongPressGestureRecognizer *)press {
    prePoint = [press locationInView:self];
//    _frameRect = self.frame;
//    _framePoint = self.frame.origin;
    
}

/*
 * 手势长按结束
 **/
- (void)endedTouch:(UILongPressGestureRecognizer *)press {
    prePoint = [press locationInView:self];
//    [self changeBack];
    self.backgroundColor = [UIColor whiteColor];
}

/*
 * 长按过程中移动
 **/
- (void)movedTouch:(UILongPressGestureRecognizer *)press {
    CGPoint now = [press locationInView:self];
    
    NSInteger x = now.x - prePoint.x;
    NSInteger y = now.y - prePoint.y;
    self.frame = CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, self.frame.size.width, self.frame.size.height);
    DLog(@"move:%@",NSStringFromCGPoint(self.center));
//    [self placeIsChanged:CGPointMake(self.frame.origin.x + prePoint.x, self.frame.origin.y + prePoint.y)];
}

#pragma mark - 按钮调整
/*

// 判断当前按钮位置是否变化，并进行调整

- (void)placeIsChanged:(CGPoint)point {
    for (NSInteger i = 0; i < [self.buttonArray count]; i++) {
        if ([self pointIn:point rect:((UIButton *)[_buttonArray objectAtIndex:i]).frame]
            && _indexOfArray != i) {
            [self adjustButtons:i];
        }
    }
}
*/
/*
 * 判断点是否在rect内
 **/
- (BOOL)pointIn:(CGPoint)point rect:(CGRect)rect {
    if (point.x > rect.origin.x && point.y > rect.origin.y && point.x < rect.origin.x+rect.size.width && point.y < rect.origin.y+rect.size.height) {
        return YES;
    }
    return NO;
}
/*

// 调整按钮位置

- (void)adjustButtons:(NSInteger)index {
    CGRect rect = ((UIButton *)[_buttonArray objectAtIndex:index]).frame;
    
    __block NSInteger i = 0;
    __block NSInteger num = index;
    // 将靠前的按钮移动到靠后的位置
    if (_indexOfArray < index) {
        // 将上一个按钮的位置赋值给当前按钮
        [UIView animateWithDuration:0.5 animations:^{
            for (i = num; i > _indexOfArray+1; i--) {
                ((UIDragButton *)[_buttonArray objectAtIndex:i]).frame = ((UIDragButton *)[_buttonArray objectAtIndex:i-1]).frame;
            }
            ((UIDragButton *)[_buttonArray objectAtIndex:i]).frame = _frameRect;
        }];
        _frameRect = rect;
        
        // 调整顺序  保证数组中按钮的frame按顺序排列
        for (i = _indexOfArray; i < index; i++) {
            [_buttonArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            ((UIDragButton *)[_buttonArray objectAtIndex:i]).indexOfArray = i;
        }
        ((UIDragButton *)[_buttonArray objectAtIndex:index]).indexOfArray = index;
    }
    else { // 将靠后的按钮移动到前边
        // 将上一个按钮的位置赋值给当前按钮
        [UIView animateWithDuration:0.5 animations:^{
            for (i = num; i < _indexOfArray-1; i++) {
                ((UIDragButton *)[_buttonArray objectAtIndex:i]).frame = ((UIDragButton *)[_buttonArray objectAtIndex:i+1]).frame;
            }
            ((UIDragButton *)[_buttonArray objectAtIndex:i]).frame = _frameRect;
        }];
        _frameRect = rect;
        
        // 调整顺序  保证数组中按钮的frame按顺序排列
        for (i = _indexOfArray; i > index; i--) {
            [_buttonArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
            ((UIDragButton *)[_buttonArray objectAtIndex:i]).indexOfArray = i;
        }
        ((UIDragButton *)[_buttonArray objectAtIndex:index]).indexOfArray = index;
    }
    _framePoint = _frameRect.origin;
}
*/
#pragma mark - 按钮移动动画
- (void)moveTo:(CGRect)rect Animation:(BOOL)flag {
    if (flag) {
        // 计算偏移并移动
        float x = rect.origin.x - self.frame.origin.x;
        float y = rect.origin.y - self.frame.origin.y;
        [self.layer addAnimation:[self moveX:0.1 X:[NSNumber numberWithFloat:x]] forKey:nil];
        [self.layer addAnimation:[self moveY:0.1 Y:[NSNumber numberWithFloat:y]] forKey:nil];
    }
    else {
        self.frame = rect;
    }
}

- (CABasicAnimation *)moveX:(float)time X:(NSNumber *)x  // 横向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue=x;
    animation.duration=time;                    // 动画持续时间
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

- (CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y  // 纵向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue=y;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
@end
