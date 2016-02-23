//
//  NSString+MD5.h
//  resource
//
//  Created by Yan Qingyang on 15/11/3.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EX)
- (NSString *)MD5;
- (NSString*)fileNameOfURL;
- (NSString*)URLEncodeing;
//不分大小写比较
- (BOOL)compareInsensitive:(NSString*)other;
@end
