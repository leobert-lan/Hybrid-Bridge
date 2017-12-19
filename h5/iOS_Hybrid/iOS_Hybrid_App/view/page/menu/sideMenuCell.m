//
//  sideMenuCell.m
//  cyy_task
//
//  Created by Qingyang on 16/7/13.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "sideMenuCell.h"
#import "sideMenuModel.h"
@implementation sideMenuCell
+ (float)getCellHeight:(id)data{
    return 50;
}
- (void)setCell:(sideMenuModel*)model{
    [super setCell:model];
    

    lblSubTTL.text=model.subTitle;

    [btnTTL setTitle:model.title forState:UIControlStateNormal];
    [btnTTL setImage:[UIImage imageNamed:model.imgNormal] forState:UIControlStateNormal];
    [btnTTL setImage:[UIImage imageNamed:model.imgDisabled] forState:UIControlStateDisabled];
    btnTTL.enabled=model.clickEnabled;
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.contentView.backgroundColor=RGBHex(kColorMain001);
    self.separatorLine.backgroundColor = RGBAHex(kColorMain001, 0);
    
    [self setSelectedBGColor:RGBHex(kColorAuxiliary103)];
    
//    lblTTL.textColor=RGBHex(kColorW);
    lblSubTTL.textColor=RGBHex(kColorW);
    
    [btnTTL setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    [btnTTL setTitleColor:RGBHex(kColorAuxiliary104) forState:UIControlStateDisabled];
}
@end
