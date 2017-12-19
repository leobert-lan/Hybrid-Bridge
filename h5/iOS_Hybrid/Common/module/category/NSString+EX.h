//
//  NSString+MD5.h
//  resource
//
//  Created by Yan Qingyang on 15/11/3.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigAttributedString.h"

@interface NSString (EX)
- (NSString *)MD5;
- (NSString*)fileNameOfURL;
- (NSString*)URLEncodeing;
//不分大小写比较
- (BOOL)compareInsensitive:(NSString*)other;

//创建富文本属性
- (NSMutableAttributedString *)createAttributedStringAndConfig:(NSArray *)configs;
- (NSRange)rangeFrom:(NSString *)string;
- (NSRange)range;

#pragma mark - 去首尾空格和所有换行
- (NSString *)removeSpaceAndNewline;
@end
