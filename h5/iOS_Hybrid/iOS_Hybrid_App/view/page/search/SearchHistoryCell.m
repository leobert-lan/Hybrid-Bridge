//
//  SearchHistoryCell.m
//  cyy_task
//
//  Created by Qingyang on 16/7/28.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

+ (float)getCellHeight:(id)data{
    return 45;
}


- (void)setCell:(SearchHistoryModel*)model{
    [super setCell:model];
    
    lblTTL.text=model.keyword;
    
}

- (void)UIGlobal{
    [super UIGlobal ];
    
    lblTTL.textColor=RGBHex(kColorGray201);
    lblTTL.font=fontSystem(kFontS28);
}
@end
