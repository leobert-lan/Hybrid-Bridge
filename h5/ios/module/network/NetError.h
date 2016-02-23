//
//  NetError.h
//  CloudBox
//
//  Created by YAN Qingyang on 15/12/8.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetError : NSError
@property (nonatomic,strong) NSString *errMessage;
@property (nonatomic,assign) NSInteger errStatusCode;
@property (nonatomic,strong) NSDictionary* errDescriptions;
- (NSDictionary*)toDictionary;
//- (void)errDescriptionsInit;
@end
