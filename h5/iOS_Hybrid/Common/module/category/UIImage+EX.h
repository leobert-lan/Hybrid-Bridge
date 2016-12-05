//
//  UIImage+EX.h
//  cyy_task
//
//  Created by Qingyang on 16/7/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EX)
+ (id)createRoundedRectImage:(UIImage*)image radius:(NSInteger)radius;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

#pragma mark - 缩放到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
//截取一个正方形，大小长宽是size
- (UIImage *)cropThumbnailSize:(CGFloat)size;
#pragma mark - 等比缩放
- (UIImage*)imageCompressWithScale:(float)scale;
@end
