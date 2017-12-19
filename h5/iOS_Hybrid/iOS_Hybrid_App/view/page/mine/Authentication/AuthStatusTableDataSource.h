//
//  AuthStatusTableDataSource.h
//  cyy_task
//
//  Created by zhchen on 16/10/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableDataSource.h"

@interface AuthStatusTableDataSource : BaseTableDataSource
@property(nonatomic,strong)RealNameModel *realNameModel;
@property(nonatomic,copy)NSString *authType;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *imgArr;
@end
