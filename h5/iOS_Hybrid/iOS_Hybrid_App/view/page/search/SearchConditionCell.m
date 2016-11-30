//
//  SearchConditionCell.m
//  cyy_task
//
//  Created by Qingyang on 16/8/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchConditionCell.h"
@interface SearchConditionCell() {
    CollectionItemTypeModel *model;
}
@end
@implementation SearchConditionCell

- (void)UIGlobal{
    [super UIGlobal ];
    
//    self.backgroundColor=[UIColor clearColor];
    
    btnTitle.titleLabel.font=fontSystem(kFontS28);
    
    [btnTitle setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    [btnTitle setTitleColor:RGBHex(kColorGray206) forState:UIControlStateHighlighted];
    [btnTitle setTitleColor:RGBHex(kColorGray203) forState:UIControlStateSelected];
    
    
   
    
    btnTitle.layer.borderWidth=0.5;
    btnTitle.layer.cornerRadius=3;
    btnTitle.clipsToBounds=YES;
    
    [self btnStatus:model.selected];
    
}

- (void)setCell:(CollectionItemTypeModel*)mod{
    model=mod;
    
    [btnTitle setTitle:model.title forState:UIControlStateNormal];
    
    [self btnStatus:model.selected];
//    if (model.selected) {
//        btnTitle.selected=YES;
//        self.contentView.backgroundColor=RGBHex(kColorGray207);
//    }
//    else {
//        btnTitle.selected=NO;
//        self.contentView.backgroundColor=RGBAHex(kColorGray207,0);
//    }
}

- (void)btnStatus:(BOOL)selected{
    if (selected) {
        btnTitle.selected=YES;
        btnTitle.backgroundColor=RGBHex(kColorMain002);
        btnTitle.layer.borderColor=RGBHex(kColorAuxiliary104).CGColor;
    }
    else {
        btnTitle.selected=NO;
        
        btnTitle.backgroundColor=RGBHex(kColorW);
        btnTitle.layer.borderColor=RGBHex(kColorGray206).CGColor;
    }
}

- (IBAction)clickAction:(id)sender{
    
}
@end


//@implementation SearchConditionSection
//
//@end