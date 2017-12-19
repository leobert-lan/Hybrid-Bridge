//
//  CityListCell.h
//  cyy_task
//
//  Created by zhchen on 16/9/2.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"

@interface CityListCell : BaseTableCell
{
    IBOutlet UILabel *cityName;
    IBOutlet UIImageView *imgDown;

    IBOutlet NSLayoutConstraint *lblnameL;
}
@end
