//
//  MyConcernCell.h
//  cyy_task
//
//  Created by zhchen on 16/7/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface MyConcernCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UIImageView *imgHeard;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (nonatomic,strong)MyConcernModel *model;
@end
