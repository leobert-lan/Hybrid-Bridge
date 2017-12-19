//
//  TaskCell.h
//  cyy_task
//
//  Created by Qingyang on 16/9/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface TaskCell : BaseTableCell
{
    IBOutlet UIView *vBG,*vMain,*vIcons,*vBtns;
    IBOutlet UILabel *lblTTL,*lblPPL,*lblTime,*lbltype,*lblPrix,*lblInfo;
    IBOutlet UIButton *btnClick;
    IBOutlet UIImageView *imgMark,*imgPrepa;
    IBOutlet UIButton *btnSel;
    
    IBOutlet UIView *spBG,*spMain;
}
@property (nonatomic,assign) BOOL selectionEnabled;
@end
