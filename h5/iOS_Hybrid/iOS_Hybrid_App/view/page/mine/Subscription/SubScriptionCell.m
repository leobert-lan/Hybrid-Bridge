//
//  SubScriptionCell.m
//  cyy_task
//
//  Created by Qingyang on 16/8/31.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SubScriptionCell.h"

@implementation SubScriptionCell

- (void)setCell:(CollectionItemTypeModel *)model{
    lblTTL.text=model.title;
    SyncBegin
    if (model.selected){
        btnSel.alpha=1;
        self.contentView.backgroundColor=RGBHex(kColorGray207);
    }
    else {
        btnSel.alpha=0;
        self.contentView.backgroundColor=RGBHex(kColorW);
    }
    SyncEnd
}

- (void)UIGlobal{
    [super UIGlobal ];
    lblTTL.font = fontSystem(kFontS30);
    lblTTL.textColor=RGBHex(kColorGray202);
    
    if (self.typeI) {
        btnSel.hidden=YES;
        imgIcon.hidden=NO;
    }
    else {
        btnSel.hidden=NO;
        imgIcon.hidden=YES;
    }
}

@end
