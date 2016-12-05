//
//  CityListVC.h
//  cyy_task
//
//  Created by zhchen on 16/9/2.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^CityListBlock)(NSString *prov, NSString*city, NSString*dist);
@interface CityListVC : BaseViewController
@property(nonatomic,copy)CityListBlock cityListBlock;
@end
