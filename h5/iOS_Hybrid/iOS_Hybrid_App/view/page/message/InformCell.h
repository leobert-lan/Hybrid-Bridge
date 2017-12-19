//
//  InformCell.h
//  cyy_task
//
//  Created by zhchen on 16/8/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface InformCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UIView *vShow;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vShowL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblDetailR;
@property (strong, nonatomic) IBOutlet UIButton *btnClick;
@property (nonatomic,assign) SysMessagesModel *modItem;
@property (strong, nonatomic) IBOutlet UIView *vSpa,*vStamp;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblName,*lblData,*lblContent;
@end
