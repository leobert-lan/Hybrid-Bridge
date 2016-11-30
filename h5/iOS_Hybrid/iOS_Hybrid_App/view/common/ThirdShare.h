//
//  ThirdShare.h
//  CloudBox
//
//  Created by zhchen on 16/3/29.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdShare : NSObject
+ (instancetype)sharedInstance;
- (void)ThirdShareView:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title btnCopy:(BOOL)btnCopy;
@end
