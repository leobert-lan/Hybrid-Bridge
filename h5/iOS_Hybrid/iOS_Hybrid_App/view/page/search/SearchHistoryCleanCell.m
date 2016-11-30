//
//  SearchHistoryCleanCell.m
//  cyy_task
//
//  Created by Qingyang on 16/7/28.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchHistoryCleanCell.h"

@implementation SearchHistoryCleanCell

+ (float)getCellHeight:(id)data{
    return 64;
}

- (void)UIGlobal{
    [super UIGlobal ];
    
    lblTTL.textColor=RGBHex(kColorAuxiliary101);
    lblTTL.font=fontSystem(kFontS26);
    
    self.contentView.backgroundColor=RGBHex(kColorGray207);
}
@end
