//
//  H5DataCheck.m
//  H5
//
//  Created by Qingyang on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "H5DataCheck.h"

@implementation H5DataCheck
+ (id)checkData:(id)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dd=data;
        if (dd[@"data"]) {
            return dd[@"data"];
        }
    }
    return nil;
}
@end
