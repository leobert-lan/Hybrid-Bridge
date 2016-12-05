//
//  ActivityCmtListCell.h
//  cyy_task
//
//  Created by Qingyang on 16/11/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"
#import "ActivityConfig.h"
#import "ActivityCmtModel.h"
@protocol ActivityCmtListCellDelegate <NSObject>
@optional
- (void)ActivityCmtListCellDelegate:(id)delegate  zan:(ActivityCmtModel*)model;
- (void)ActivityCmtListCellDelegate:(id)delegate  openCell:(ActivityCmtModel*)model;
@end

@interface ActivityCmtListCell : BaseTableCell
{
    IBOutlet UILabel *lblUser,*lblTime,*lblZan,*lblContent,*lblNum;
    IBOutlet UIImageView *imgAvatar;
    IBOutlet UIImageView *iconCup,*iconZan;
    IBOutlet UIButton *btnOpenContent,*btnZan;

}

@property (nonatomic,assign) ActivityCmtModel *mmMyCmt;
@end
