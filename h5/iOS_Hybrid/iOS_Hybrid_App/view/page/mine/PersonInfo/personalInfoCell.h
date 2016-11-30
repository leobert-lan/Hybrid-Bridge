//
//  personalInfoCell.h
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface personalInfoCell : BaseTableCell
{
    IBOutlet UILabel *lblNameL,*lblNameR;

}
- (void)setNameL:(NSString *)nameL nameR:(NSString *)nameR;
@end
