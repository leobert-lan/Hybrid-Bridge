//
//  QYUserDefault.h
//  QYProjet
//
//  Created by YAN Qingyang on 14-5-7.
//  Copyright (c) 2014年 YAN Qingyang. All rights reserved.
//
//  Version 0.1


// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2014 YAN Qingyang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kQYUserID       @"kQYUserID"
#define kQYUserToken    @"kQYUserToken"

//@class QYModel;
@interface QYUserDefault : NSObject

#define StrFloat(num)           [QYUserDefault strWithFloat:num]

#define GetStrByKey(kw)         [QYUserDefault getStringBy:kw]
#define SetStrWithKey(st, kw)   [QYUserDefault setString:st key:kw]

/* UID */
#define SetUserID(uid)          [QYUserDefault setString:uid key:kQYUserID];
#define GetUserID               [QYUserDefault getStringBy:kQYUserID]
#define SetUserToken(utk)       [QYUserDefault setString:utk key:kQYUserToken];
#define GetUserToken            [QYUserDefault getStringBy:kQYUserToken]

+ (NSString*)strWithInt:(NSInteger)num;
+ (NSString*)strWithFloat:(CGFloat)num;
+ (NSString*)strWithBool:(BOOL)bul;

+ (BOOL)setString:(NSString*)str key:(NSString*)keyWord;
+ (NSString *)getStringBy:(NSString*)keyWord;

+ (BOOL)setBool:(BOOL)value key:(NSString*)keyWord;
+ (BOOL)getBoolBy:(NSString*)keyWord;

+ (BOOL)setDict:(NSDictionary*)dict key:(NSString*)keyWord;
+ (NSDictionary *)getDictBy:(NSString*)keyWord;

+ (BOOL)setObject:(id)obj key:(NSString*)keyWord;
+ (id)getObjectBy:(NSString*)keyWord;

+ (BOOL)setModel:(id)mod key:(NSString*)keyWord;
+ (id)getModelBy:(NSString*)keyWord;

+ (BOOL)setDouble:(double)value key:(NSString*)keyWord;
+ (double)getDoubleBy:(NSString*)keyWord;

+ (BOOL)setNumber:(NSNumber*)num key:(NSString*)keyWord;
+ (NSNumber *)getNumberBy:(NSString*)keyWord;
@end
