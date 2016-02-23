//
//  NSString+MD5.m
//  resource
//
//  Created by Yan Qingyang on 15/11/3.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "NSString+EX.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (EX)
- (NSString *)MD5 {
    if(self.length == 0) {
        return self;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

//获取文件名字 （不要用lastPathComponent ‘abc/’会返回abc而不是nil）
- (NSString*)fileNameOfURL{
    NSString *fileName;
    
    NSRange range = [self rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        fileName = [self substringFromIndex:range.location+1];
        if (fileName && fileName.length)
            return fileName;
        else return nil;
    }
    else {
        return nil;
    }
}

- (NSString*)URLEncodeing{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)compareInsensitive:(NSString*)other{
    BOOL result = [self caseInsensitiveCompare:other] == NSOrderedSame;
    return result;
}
@end
