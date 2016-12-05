//
//  AuthCardCell.h
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"
#import "AuthCell.h"
@interface AuthCardCell : AuthCell
@property (strong, nonatomic) IBOutlet UILabel *lblCard;
@property (strong, nonatomic) IBOutlet UILabel *lblShow;
@property (strong, nonatomic) IBOutlet UIButton *btnSta;
@property (strong, nonatomic) IBOutlet UIButton *btnEnd;

@end
