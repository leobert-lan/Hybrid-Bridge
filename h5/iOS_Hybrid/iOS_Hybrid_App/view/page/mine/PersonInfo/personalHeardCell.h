//
//  personalHeardCell.h
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface personalHeardCell : BaseTableCell
{
    IBOutlet UIImageView *heardImg;
    IBOutlet UILabel *lblName,*lblChange;
    
//    UIActivityIndicatorView *act;
}

@property (nonatomic,retain ) UIImage *imgAvatar;;
@end
