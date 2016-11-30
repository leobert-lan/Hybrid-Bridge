//
//  SearchTypeCell.m
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchTypeCell.h"
@interface SearchTypeCell() {
    CollectionItemTypeModel *model;
}
@end
@implementation SearchTypeCell

- (void)UIGlobal{
    [super UIGlobal ];
    
    [self setSeparatorMargin:15 edge:EdgeRight|EdgeLeft];
    
    btnTitle.titleLabel.font=fontSystem(kFontS28);
    
    [btnTitle setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    [btnTitle setTitleColor:RGBHex(kColorAuxiliary102) forState:UIControlStateHighlighted];
    [btnTitle setTitleColor:RGBHex(kColorAuxiliary102) forState:UIControlStateSelected];
    
    [self btnStatus:model.selected type:self.typeI];
//    if (model.selected) {
//        btnTitle.selected=YES;
//        self.contentView.backgroundColor=RGBHex(kColorGray207);
//        [self setSeparatorMargin:0 edge:EdgeRight|EdgeLeft];
//    }
//    else {
//        btnTitle.selected=NO;
//        self.contentView.backgroundColor=RGBAHex(kColorGray207,0);
//    }
    
    if (self.typeI==false) {
        self.contentView.backgroundColor=RGBAHex(kColorGray207,0);
    }
}

- (void)setCell:(CollectionItemTypeModel*)mm{
    model=mm;
    [super setCell:model];
    
    [btnTitle setTitle:model.title forState:UIControlStateNormal];
    
    [self btnStatus:model.selected type:self.typeI];
}

- (void)btnStatus:(BOOL)selected type:(BOOL)typeI{
    self.contentView.backgroundColor=RGBAHex(kColorGray207,0);
    btnTitle.selected=NO;
    self.separatorLine.backgroundColor = RGBHex(kColorGray206);
    if (selected) {
        
        if (typeI) {
            self.contentView.backgroundColor=RGBHex(kColorGray207);
            [self setSeparatorMargin:0 edge:EdgeRight|EdgeLeft];
        }
        else {
            btnTitle.selected=YES;
            self.separatorLine.backgroundColor = RGBHex(kColorAuxiliary102);
        }
    }
//    else {
//        
//        if (typeI) {
//            self.contentView.backgroundColor=RGBHex(kColorGray207);
//            [self setSeparatorMargin:0 edge:EdgeRight|EdgeLeft];
//        }
//        else {
//            self.contentView.backgroundColor=RGBAHex(kColorGray207,0);
//        }
//    }
    
}

- (IBAction)clickAction:(id)sender{
    
}
@end
