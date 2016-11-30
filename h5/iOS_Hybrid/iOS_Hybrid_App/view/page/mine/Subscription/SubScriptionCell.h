//
//  SubScriptionCell.h
//  cyy_task
//
//  Created by Qingyang on 16/8/31.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface SubScriptionCell : BaseTableCell
{
    IBOutlet UILabel *lblTTL;
    IBOutlet UIButton *btnSel;
    IBOutlet UIImageView *imgIcon;
}
@property (assign) BOOL typeI;
@end
