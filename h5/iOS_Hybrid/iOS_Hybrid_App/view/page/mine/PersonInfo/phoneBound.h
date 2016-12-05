//
//  phoneBound.h
//  Chuangyiyun
//
//  Created by zhchen on 16/5/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
typedef void(^PhoneBoundBlock)(NSString *phoneNum);
@interface phoneBound : BaseViewController
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)PhoneBoundBlock phoneBoundBlock;
@property(nonatomic,copy)NSString *boundType;
@end
