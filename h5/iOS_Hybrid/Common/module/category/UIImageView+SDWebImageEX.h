//
//  UIImageView+LoadRenameImage.h
//  CloudBox
//
//  Created by qyyan on 15/12/10.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SDWebImageEX)
+ (UIImageView*)imageNamed:(NSString*)name;
+ (void)imageOldKey:(NSString*)oldKey newKey:(NSString*)newKey;

- (void)setImageAuthURL:(NSString*)strUrl placeholderImage:(UIImage *)placeholder tag:(NSString*)tag refresh:(BOOL)refresh;
- (void)setImageAuthURL:(NSString*)strUrl placeholderImage:(UIImage *)placeholder tag:(NSString*)tag refresh:(BOOL)refresh progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder key:(NSString*)key options:(SDWebImageOptions)options;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder key:(NSString*)key options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock ;

#pragma mark - 设置图片下载LastModify
+ (void)SDWebImageLastModifySetting;
@end
