//
//  QYImage.h
//  PhotoInfo
//
//  Created by YAN Qingyang on 14-6-26.
//  Copyright (c) 2014年 YAN Qingyang. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYImage : NSObject
+ (UIImage *)fixImageOrientation:(UIImage*)aImage;
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)cropThumbnail:(UIImage *)image;
@end
