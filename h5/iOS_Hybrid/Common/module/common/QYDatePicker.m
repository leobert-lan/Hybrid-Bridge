//
//  QWDatePicker.m
//  wenyao
//
//  Created by Yan Qingyang on 15/4/14.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//
//#import "QWcss.h"
#import "QYDatePicker.h"

//static float kAlpha = 0.4f;
static NSString *kDateF=@"yyyy-MM-dd";

@interface QYDatePicker()
{
    IBOutlet UIButton *btnShadow;

    IBOutlet UIView *vTime;

    IBOutlet UIButton *btnOK;

    IBOutlet UIDatePicker *picker;

    NSInteger curTime;
}
@end

@implementation QYDatePicker

//+(QWDatePicker *)instanceWithDelegate:(id)delegate dateString:(NSString*)dateString{
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QWDatePicker" owner:nil options:nil];
//    QWDatePicker *sheet=[nibView objectAtIndex:0];
//    sheet.delegate=delegate;
//    sheet.dateString=dateString;
//    return sheet;
//}
+ (QYDatePicker *)instanceWithDate:(NSDate*)date callBack:(CallBack)callBack{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QYDatePicker" owner:nil options:nil];
    QYDatePicker *sheet=[nibView objectAtIndex:0];
    if ([date isKindOfClass:[NSDate class]]) {
        sheet.date=date;
    }
    else sheet.date=[NSDate date];
    
    sheet.callBack=callBack;
    [sheet show];
    return sheet;
}
- (void)UIGlobal{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;

    CGRect frm;
    
    frm=vTime.frame;
    frm.origin.y=CGRectGetHeight(win.bounds);
    vTime.frame=frm;
    
    btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

    vTime.backgroundColor=[UIColor whiteColor];
    
    
    
    btnOK.backgroundColor=RGBHex(0xff8a00);
    btnOK.titleLabel.font=fontSystem(18);
    btnOK.layer.cornerRadius=4;
    
   
    
    [picker setBackgroundColor:[UIColor whiteColor]];
    //    [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
//    picker.datePickerMode = UIDatePickerModeTime;
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
//    [picker setLocale:locale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateF];
//    NSDate *dt = [dateFormatter dateFromString:self.dateString];
    if ([_date compare:[NSDate date]]<0) {
        [picker setDate:[NSDate date] animated:NO];
    }
    else
        [picker setDate:_date animated:NO];
    
    [picker setMinimumDate:[NSDate date]];
  
}


- (void)show{
    [self UIGlobal];
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate]
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    CGRect frm=win.bounds;
    self.frame=frm;
    [win addSubview:self];
    //    [win bringSubviewToFront:self];
    
    
    
    frm=vTime.frame;
    frm.origin.y=CGRectGetHeight(win.bounds);
    vTime.frame=frm;
    
    [UIView animateWithDuration:.25 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:.4];
        
        CGRect frm;
        frm=vTime.frame;
        frm.origin.y=CGRectGetHeight(win.bounds)-CGRectGetHeight(vTime.frame);
        vTime.frame=frm;
 
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - action

- (IBAction)closeAction:(id)sender{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.15 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        CGRect frm;
        frm=vTime.frame;
        frm.origin.y=CGRectGetHeight(win.bounds);
        vTime.frame=frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.callBack) {
            self.callBack(nil);
        }
    }];
}

- (IBAction)okAction:(id)sender{
  
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.15 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        CGRect frm;
        frm=vTime.frame;
        frm.origin.y=CGRectGetHeight(win.bounds);
        vTime.frame=frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.callBack) {
            self.callBack(picker.date);
        }
//        if ([self.delegate respondsToSelector:@selector(QWLNActionSheetDelegate:)]) {
//            [self.delegate QWLNActionSheetDelegate:self.listTimes];
//        }
    }];
}
@end
