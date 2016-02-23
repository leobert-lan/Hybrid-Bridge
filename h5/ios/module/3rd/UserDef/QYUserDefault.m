//
//  QYUserDefault.m
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

#import "QYUserDefault.h"
//#import "QYModel.h"

@implementation QYUserDefault
#pragma mark -
+ (NSString*)strWithInt:(NSInteger)num{
    return [NSString stringWithFormat:@"%li",(long)num];
}

+ (NSString*)strWithFloat:(CGFloat)num{
    return [NSString stringWithFormat:@"%f",num];
}

+ (NSString*)strWithBool:(BOOL)bul{
    return [NSString stringWithFormat:@"%d",bul];
}


#pragma mark set&get
+ (BOOL)setObject:(id)obj key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [user setObject:data forKey:keyWord];
    [user synchronize];
    
    return YES;
}

+ (id)getObjectBy:(NSString*)keyWord{
//    NSLog(@"keyWord:%@",keyWord);
    if (keyWord==nil) {
        return nil;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSData class]]) {
        id file=[NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return file;
    }
    return nil;
}

+ (BOOL)setModel:(id)mod key:(NSString*)keyWord{
    return [self setObject:mod key:keyWord];
}

+ (id)getModelBy:(NSString*)keyWord{
    return [self getObjectBy:keyWord];
}

+ (BOOL)setString:(NSString*)str key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:str forKey:keyWord];
    [user synchronize];
    return YES;
}

+ (NSString *)getStringBy:(NSString*)keyWord{
    if (keyWord==nil) {
        return nil;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

+ (BOOL)setNumber:(NSNumber*)num key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:num forKey:keyWord];
    [user synchronize];
    return YES;
}

+ (NSNumber *)getNumberBy:(NSString*)keyWord{
    if (keyWord==nil) {
        return nil;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    return nil;
}

+ (BOOL)setDict:(NSDictionary*)dict key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:dict forKey:keyWord];
    [user synchronize];
    return YES;
}

+ (NSDictionary *)getDictBy:(NSString*)keyWord{
    if (keyWord==nil) {
        return nil;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSData class]]) {
        NSDictionary *dict=[NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return dict;
    }
    return nil;
}

+ (BOOL)setBool:(BOOL)value key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setBool:value forKey:keyWord];
    [user synchronize];
    return YES;
}

+ (BOOL)getBoolBy:(NSString*)keyWord{
    if (keyWord==nil) {
        return NO;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    return [user boolForKey:keyWord];
}

+ (BOOL)setDouble:(double)value key:(NSString*)keyWord{
    if (keyWord==nil) {
        return false;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setDouble:value forKey:keyWord];
    [user synchronize];
    return YES;
}

+ (double)getDoubleBy:(NSString*)keyWord{
    if (keyWord==nil) {
        return 0;
    }
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    return [user doubleForKey:keyWord];
}
#pragma mark 常用


#pragma mark 项目专业
@end
