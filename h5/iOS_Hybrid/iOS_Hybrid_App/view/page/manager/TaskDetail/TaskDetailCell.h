//
//  TaskDetailCell.h
//  cyy_task
//
//  Created by zhchen on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"
@protocol TaskDetailCellDelegate <NSObject>
- (void)TaskDetailCellDelegateOpenOrClose;
// 附件
- (void)TaskDetailFileDelegate:(id)delegate model:(id)model;
- (void)TaskDetailImageDelegate:(id)delegate model:(id)model;
@end

@interface TaskDetailCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblData;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;
@property (strong, nonatomic) IBOutlet UIImageView *imgphoto;
@property (strong, nonatomic) IBOutlet UILabel *lblDown;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgDown;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblContentH,*lblPriceH,*lblPriceT;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)BOOL isSelct;
@property (nonatomic,assign) TaskDetailWorksModel *modItem;
@property (strong, nonatomic) IBOutlet UIImageView *imgSucc;
@property (strong, nonatomic) IBOutlet UIView *vDown;
@end
