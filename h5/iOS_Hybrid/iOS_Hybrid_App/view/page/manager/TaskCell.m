//
//  TaskCell.m
//  cyy_task
//
//  Created by Qingyang on 16/9/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

+ (float)getCellHeight:(id)data{
    return 75;
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.contentView.backgroundColor=[UIColor clearColor];
    vBG.backgroundColor=RGBHex(kColorW);
    vMain.backgroundColor=RGBAHex(kColorW,0);
    vBtns.backgroundColor=RGBAHex(kColorW,0);
    
    lblPrix.textColor=RGBHex(kColorAuxiliary102);
    lblPPL.textColor=RGBHex(kColorGray203);
    lblTTL.textColor=RGBHex(kColorGray201);
    lblTime.textColor=RGBHex(kColorGray203);
    lbltype.textColor=RGBHex(kColorGray203);
    lblInfo.textColor=RGBHex(kColorAuxiliary105);
    
    lblInfo.font=fontSystem(kFontS28);
    lblTTL.font=fontSystem(kFontS28);
    lblPrix.font=fontSystem(kFontS28);
    lblPPL.font=fontSystem(kFontS26);
    lblTime.font=fontSystem(kFontS26);
    lbltype.font=fontSystem(kFontS26);
    
    btnClick.layer.cornerRadius=4;
    btnClick.layer.borderWidth=0.5;
    btnClick.layer.borderColor=RGBHex(kColorGray203).CGColor;
    [btnClick setTitleColor:RGBHex(kColorGray208) forState:UIControlStateNormal];
    [btnClick setTitleColor:RGBHex(kColorGray211) forState:UIControlStateHighlighted];
    
    CGFloat hh =0.5;
    CGRect frm;
    frm=CGRectMake(0, 0, self.contentView.width, hh);
    
    spBG.frame=frm;
    spBG.y=vBG.height-hh;
    spBG.backgroundColor=RGBHex(kColorGray206);
    spMain.frame=frm;
    spMain.y=vMain.height-hh;
    spMain.backgroundColor=RGBHex(kColorGray206);
    
//    if (sp1==nil) {
//        sp1=[[UIView alloc]initWithFrame:frm];
//        sp1.y=vBG.height-hh;
//        sp1.backgroundColor=RGBHex(kColorGray206);
//        [vBG addSubview:sp1];
//    }
//    
//    if (sp2==nil) {
//        sp2=[[UIView alloc]initWithFrame:frm];
//        sp2.y=vMain.height-hh;
//        sp2.backgroundColor=RGBHex(kColorGray206);
//        [vMain addSubview:sp2];
//    }
//
    
    
    
    vIcons.backgroundColor=[UIColor clearColor];
    
    
}

- (IBAction)btnClickAction:(id)sender{
    
}

- (void)setCell:(id)model{
    [vIcons removeAllSubviews];
    
    imgMark.hidden=YES;
    imgPrepa.hidden=YES;
    
    lblInfo.hidden=YES;
    btnClick.hidden=YES;
    
    if ([model isKindOfClass:[TaskModel class]]) {
        TaskModel *mm=model;
        lblTTL.text=mm.title;
        lblPPL.text=[NSString stringWithFormat:@"%@人参与",mm.total_bids];
        
        
        [self checkSelection:mm];
        [self checkStep:mm];//检查阶段
        [self checkPrix:mm];
        [self checkType:mm];
        [self checkIcon:mm];
        [self checkWorkStatus:mm];
    }
}

//投稿状态（1=>未中标，2=>备选，3=>中标，4=>被举报）(1=> did not win the bid, 2=> alternative, 3=> won the bid, 4=> was reported)
- (void)checkWorkStatus:(TaskModel*)mm{
    //投稿状态（1=>未中标，2=>备选，3=>中标，4=>被举报）
    switch (mm.work_status.intValue) {
        case TaskWorkStatusTypeNoBind:
        {
            
        }
            break;
        case TaskWorkStatusTypeAlternative:
        {
            imgPrepa.hidden=NO;
        }
            break;
        case TaskWorkStatusTypeBind:
        {
            imgMark.hidden=NO;
        }
            break;
        case TaskWorkStatusTypeReported:
        {
           
        }
            break;
        default:
            break;
    }
}
- (void)checkSelection:(TaskModel*)mm{
    btnSel.hidden=YES;
    if (self.selectionEnabled) {
        vMain.x=54;
        
        btnSel.hidden=NO;
        btnSel.selected=mm.selected;
        SyncBegin
        if (mm.selected) {
       
            vMain.backgroundColor=RGBHex(kColorGray207);
            vBG.backgroundColor=RGBHex(kColorGray207);
        }
        else {
       
            vMain.backgroundColor=RGBHex(kColorW);
            vBG.backgroundColor=RGBHex(kColorW);
        }
        SyncEnd
    }
    else {
        vMain.x=0;
        
        SyncBegin

        vMain.backgroundColor=RGBHex(kColorW);
        SyncEnd
    }
}

- (void)checkTime:(TaskModel*)mm{
    if (!StrIsEmpty(mm.sub_end_time_alias)) {
        lblTime.text=mm.sub_end_time_alias;
    }
    else {
        lblTime.text=[QGLOBAL dateDiffFromTimeInterval:mm.sub_end_time];
    }
}
- (void)checkStep:(TaskModel*)mm{
    //没有阶段显示时间
    if (StrIsEmpty(mm.step)) {
        [self checkTime:mm];
        return;
    }
    //阶段（1=>发布，2=>投稿，3=>选稿，4=>公示，5=>制作，6=>结束）
    switch (mm.step.intValue) {
        case TaskStepTypeRelease:
        {
            lblTime.text=@"发布";
        }
            break;
        case TaskStepTypeSubmission:
        {
            [self checkTime:mm];
        }
            break;
        case TaskStepTypeDraft:
        {
            lblTime.text=@"选稿中";
        }
            break;
        case TaskStepTypePublicity:
        {
            lblTime.text=@"公示中";
        }
            break;
        case TaskStepTypeProduction:
        {
            lblTime.text=@"制作中";
        }
            break;
        case TaskStepTypeEnd:
        {
            lblTime.text=@"结束";
        }
            break;
        default:
            break;
    }
    //    if (mm.step.intValue==2) {
    //
    //
    //
    //    }
    //    else {
    //        if (!StrIsEmpty(mm.status_alias)) {
    //            lblTime.text=mm.status_alias;
    //        }
    //        else {
    //            lblTime.text=@"...";
    //        }
    //    }
}
- (void)checkPrix:(TaskModel*)mm{
    //招标类型（1=>明标，2=>暗标）
    if (mm.is_mark.intValue==2) {
        lblPrix.text=@"暗标";
    }
    else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *ss = [formatter stringFromNumber:[NSNumber numberWithInteger:[mm.task_cash integerValue]]];
        if (mm.task_cash.length==0) {
            //            DLog(@"%@",mm.toDictionary);
            ss = [formatter stringFromNumber:[NSNumber numberWithInteger:[mm.min_cash integerValue]]];
        }
        lblPrix.text=[NSString stringWithFormat:@"￥%@",ss];
        
        
    }
}

- (void)checkIcon:(TaskModel*)mm{
    SyncBegin
    int num=0;
    CGFloat xx=0;
    CGFloat margin=4;
    if (mm.urgent.intValue>0) {
        UIImageView *imgv=[UIImageView imageNamed:@"status_ji"];
        imgv.frame=CGRectMake(xx, 0, 15, 15);
        [vIcons addSubview:imgv];
        
        vIcons.width=CGRectGetMaxX(imgv.frame);
    }
    
    if (mm.top.intValue>0) {
        num = (int)vIcons.subviews.count;
        if (num>0) {
            xx=num*(15+2);
        }
        
        UIImageView *imgv=[UIImageView imageNamed:@"status_ding"];
        imgv.frame=CGRectMake(xx, 0, 15, 15);
        [vIcons addSubview:imgv];
        
        vIcons.width=CGRectGetMaxX(imgv.frame);
    }
    
    //大小自适应
    [lblTTL sizeToFit];
    lblTTL.height=20;
    lblTTL.y=11.5;
//    DLog(@"-----> %f",lblTTL.width);
    
    //后边距
    if (CGRectGetMaxX(lblTTL.frame)>CGRectGetMaxX(lblTime.frame)) {
        lblTTL.width=CGRectGetMaxX(lblTime.frame)-CGRectGetMinX(lblTTL.frame);
    }
    
    if (vIcons.subviews.count>0) {
        if (CGRectGetMaxX(lblTTL.frame)+vIcons.width+margin>CGRectGetMaxX(lblTime.frame)) {
            //icon+ttl 超边界 lblTTL宽减少
            lblTTL.width=CGRectGetMaxX(lblTime.frame)-(vIcons.width+margin)-CGRectGetMinX(lblTTL.frame);
        }
        
        
        vIcons.x=CGRectGetMaxX(lblTTL.frame)+margin;
    }
    SyncEnd
}
- (void)checkType:(TaskModel*)mm{
    int tt=mm.model.intValue; //需求类型（1=>悬赏，2=>招标，3=>雇佣）
    switch (tt) {
        case 1:
            lbltype.text=@"悬赏";
            break;
        case 2:
            lbltype.text=@"招标";
            break;
        case 3:
            lbltype.text=@"雇佣";
            break;
            
        default:
            break;
    }
}

@end
