//
//  TaskDetailHideCell.h
//  cyy_task
//
//  Created by zhchen on 16/8/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface TaskDetailHideCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblData;
@property (strong, nonatomic) IBOutlet UILabel *lblHide;
@property (strong, nonatomic) IBOutlet UIImageView *imgSucc;
@end
