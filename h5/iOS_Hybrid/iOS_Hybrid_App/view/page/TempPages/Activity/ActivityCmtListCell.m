//
//  ActivityCmtListCell.m
//  cyy_task
//
//  Created by Qingyang on 16/11/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ActivityCmtListCell.h"
static float kMargin=20;
@implementation ActivityCmtListCell
+ (float)getCellHeight:(ActivityCmtModel*)mod{
    CGSize sz=[QGLOBAL sizeText:mod.content font:fontSystem(kFontS28) limitWidth:APP_W-15-58];
    CGFloat hh=68;
    if (sz.height<21) {
        hh+=21;
    }
    else if (sz.height>42){
        if (mod.isOpen.boolValue) {
            hh+=sz.height+21;
        }
        else
            hh+=42+21;
    }
    else {
        hh+=42;
    }
    
    
    
    hh+=kMargin;
    return hh;
}

- (void)UIGlobal{
    [super UIGlobal];
    
    [self setSeparatorMargin:15 edge:EdgeLeft|EdgeRight ];
    
    [self checkZan];
    [self checkContent];
    
    self.contentView.backgroundColor=RGBHex(kColorTmp003);;
    lblUser.textColor=RGBHex(kColorTmp006);
    lblZan.textColor=RGBHex(kColorTmp006);
    lblNum.textColor=RGBHex(kColorTmp006);
    lblTime.textColor=RGBHex(kColorTmp008);
    lblContent.textColor=RGBHex(kColorTmp007);
    [btnOpenContent setTitleColor:RGBHex(kColorTmp001) forState:UIControlStateNormal];
    [btnOpenContent setTitleColor:RGBHex(kColorTmp001) forState:UIControlStateSelected];
    
    self.separatorLine.backgroundColor = RGBHex(kColorTmp008);
}
- (void)setCell:(ActivityCmtModel*)mod{
//    DLog(@"%@",[mod toDictionary]);
    _mmMyCmt=mod;
    
    lblUser.text=StrFromObj(_mmMyCmt.nickname);
    lblNum.text=StrFromObj(_mmMyCmt.ranking);
    
    lblTime.text=[QGLOBAL dateToStr:[QGLOBAL dateFromTimeInterval:_mmMyCmt.created_at] format:@"yyyy-MM-dd HH:mm"];
    
    
    imgAvatar.clipsToBounds = YES;
    imgAvatar.layer.cornerRadius = imgAvatar.width/2;
    [imgAvatar setImageWithURL:[NSURL URLWithString:mod.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    [self check123];
    [self checkZan];
    [self checkContent];

}

- (void)check123{
    iconCup.hidden=NO;
    if (_mmMyCmt.ranking.integerValue==1) {
        iconCup.image=[UIImage imageNamed:@"dym"];
    }
    else if (_mmMyCmt.ranking.integerValue==2) {
        iconCup.image=[UIImage imageNamed:@"dem"];
    }
    else if (_mmMyCmt.ranking.integerValue==3) {
        iconCup.image=[UIImage imageNamed:@"dsm"];
    }
    else {
        iconCup.hidden=YES;
    }
}

- (void)checkZan{
    lblZan.text=[NSString stringWithFormat:@"赞 (%@)",_mmMyCmt.zans];
    [lblZan sizeToFit];
    lblZan.height=21;
    lblZan.y=23;
    lblZan.x=APP_W-15-lblZan.width;
    
    
    iconZan.highlighted=_mmMyCmt.already_zan.boolValue;
    iconZan.x=lblZan.x-2-iconZan.width;
    
    btnZan.x=iconZan.x;
    
    lblUser.width=iconZan.x-lblUser.x-5;
}

- (void)checkContent{
    btnOpenContent.hidden=YES;
    lblContent.text=StrFromObj(_mmMyCmt.content);
    
    lblContent.width=APP_W-15-58;
    
    CGSize sz=[QGLOBAL sizeText:lblContent.text font:lblContent.font limitWidth:lblContent.width];
//    DLog(@"%@",NSStringFromCGSize(sz));
    if (sz.height<21) {
        lblContent.height=sz.height;
    }
    else if (sz.height>42){
        if (_mmMyCmt.isOpen.boolValue) {
            lblContent.height=sz.height+1;
            
        }
        else {
            lblContent.height=34;
        }
        btnOpenContent.y=lblContent.height+lblContent.y+4;
        btnOpenContent.hidden=NO;
        btnOpenContent.selected=_mmMyCmt.isOpen.boolValue;
    }
    else {
        lblContent.height=34;
    }
}

- (IBAction)zanAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(ActivityCmtListCellDelegate:zan:)]) {
        [self.delegate ActivityCmtListCellDelegate:self zan:_mmMyCmt];
    }
}

- (IBAction)openAction:(id)sender{
    UIButton *btn=sender;
    btn.selected=!btn.selected;
    
    _mmMyCmt.isOpen=[NSNumber numberWithBool:btn.selected];
    
    if ([self.delegate respondsToSelector:@selector(ActivityCmtListCellDelegate:openCell:)]) {
        [self.delegate ActivityCmtListCellDelegate:self openCell:_mmMyCmt];
    }
}
@end
