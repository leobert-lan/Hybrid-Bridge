//
//  CNIDCheck.h
//  resource
//
//  Created by Qingyang on 16/6/21.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNIDCheck : NSObject
//是否大陆身份证
+ (BOOL)isChineseIdNo:(NSString*)idNumber;
@end
