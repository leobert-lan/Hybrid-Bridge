//
//  AuthCompanyStatusDataSource.h
//  cyy_task
//
//  Created by zhchen on 16/10/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableDataSource.h"

@interface AuthCompanyStatusDataSource : BaseTableDataSource
@property(nonatomic,strong)CompanyAuthModel *companyAuthModel;
@property(nonatomic,strong)NSMutableArray *dataArr,*cardImgArr;
@end
