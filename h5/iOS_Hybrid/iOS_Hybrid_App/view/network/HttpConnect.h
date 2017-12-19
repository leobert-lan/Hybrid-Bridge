//
//  HttpConnect.h
//  resource
//
//  Created by Yan Qingyang on 15/11/9.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "NetConnect.h"
#define  HTTPConnecting [HttpConnect sharedInstance]
#define  HTTPDownload [HttpConnect aInstance]
#define  HTTPUpload [HttpConnect aInstance]
@interface HttpConnect : NetConnect
//单例
+ (instancetype)sharedInstance;

//副本
+ (instancetype)aInstance;
@end
