//
//  UIImageView+LoadRenameImage.m
//  CloudBox
//
//  Created by qyyan on 15/12/10.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "UIImageView+SDWebImageEX.h"

@implementation UIImageView (SDWebImageEX)
+ (void)imageOldKey:(NSString*)oldKey newKey:(NSString*)newKey{
    NSString *new=[[SDImageCache sharedImageCache] defaultCachePathForKey:newKey];
    if ([FileManager isExist:new]) {
        [FileManager deletePath:new];
    }
    [FileManager moveItemAtPath:[[SDImageCache sharedImageCache] defaultCachePathForKey:oldKey] toPath:new];
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder key:(NSString*)key options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    if (key==nil || key.length==0) {
        [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    }
    else {
        __weak typeof (self) weakSelf = self;
        __block SDWebImageManager *sd=[SDWebImageManager sharedManager];
        [self setImageWithURL:[NSURL URLWithString:key] placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //如果没有对应key值图，下载后以key值重命名
            if (error && sd){
                [sd downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    if (error==nil) {
                        //                        DLog(@"～～%li",(long)cacheType);
                        [UIImageView imageOldKey:url.absoluteString newKey:key];
                        weakSelf.image=image;
                    }
                    
                    if (completedBlock) {
                        completedBlock(image, error, cacheType);
                    }
                }];
            }
            else if (completedBlock) {
                completedBlock(image, error, cacheType);
            }
        }];
    }
}




- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder key:(NSString*)key options:(SDWebImageOptions)options{
    [self setImageWithURL:url placeholderImage:placeholder key:key options:options progress:nil completed:nil];
}

- (void)setImageAuthURL:(NSString*)strUrl placeholderImage:(UIImage *)placeholder tag:(NSString*)tag refresh:(BOOL)refresh{
    [self setImageAuthURL:strUrl placeholderImage:placeholder tag:tag refresh:refresh progress:nil completed:nil];

}

- (void)setImageAuthURL:(NSString*)strUrl placeholderImage:(UIImage *)placeholder tag:(NSString*)tag refresh:(BOOL)refresh progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock{
    NSString *url=strUrl;//[strUrl URLEncodeing];
    NSArray *arr=[url componentsSeparatedByString:@"&"];
    SDWebImageOptions op=refresh?SDWebImageRefreshCached:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageContinueInBackground;
    if (arr.count==1) {
        [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:op progress:progressBlock completed:completedBlock];
    }
    else if (arr.count > 1){
        //        DLog(@"%@",arr);
        
        NSString *path=arr.firstObject;
        BOOL noAuth=YES;
        for (int i = 1; i<arr.count; i++) {
            NSString *ss=[arr objectAtIndex:i];
            if ([ss hasPrefix:@"access_token"] || [ss hasPrefix:@"access_id"]) {
                noAuth=NO;
            }
            else {
                path=[NSString stringWithFormat:@"%@&%@",path,ss];
            }
        }
        
        if (!StrIsEmpty(tag)) {
            path=[NSString stringWithFormat:@"%@&%@",path,tag];
            path=[path MD5];
        }
        
        if (noAuth) {
            path=nil;
        }
        
        [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder key:path options:op progress:progressBlock completed:completedBlock];
    }
}
@end