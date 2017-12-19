//
//  ThirdShareView.m
//  CloudBox
//
//  Created by zhchen on 16/3/2.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "ThirdShareView.h"

@interface ThirdShareView ()
{
    IBOutlet UIButton *btnShadow;
    IBOutlet UIView *vBtns;
    IBOutlet UIButton *btnSina,*btnQQ,*btnWeixin,*btnQQZone,*btnWexinLine,*btnCancel;
    IBOutlet UILabel *lblSina,*lblQQ,*lblWeixin,*lblQQZone,*lblWexinLine;

}
@end
@implementation ThirdShareView
+ (ThirdShareView *)instanceWithBtnCopy:(BOOL)btnCopy Block:(ShareBlock)block{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ThirdShareView" owner:nil options:nil];
    ThirdShareView *vv=[nibView objectAtIndex:0];
    if (btnCopy == YES) {
        vv.btnCopy.hidden = NO;
        vv.lblCopy.hidden = NO;
    }else{
        vv.btnCopy.hidden = YES;
        vv.lblCopy.hidden = YES;
    }
    
    vv.callBackBlock=block;
    [vv show];
    return vv;
}
- (void)UIGlobal{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    CGRect frm;
    
    
    self.frame=win.bounds;
    btnShadow.frame=win.bounds;
    
    
    frm=vBtns.frame;
    frm.origin.y=CGRectGetHeight(win.bounds);
    vBtns.frame=frm;
    
    btnShadow.backgroundColor=[UIColor clearColor];//[UIColor colorWithWhite:0 alpha:0];
    
    vBtns.backgroundColor=[UIColor whiteColor];
    
    self.backgroundColor=[UIColor clearColor];

    lblSina.textColor = RGBHex(kColorGray208);
    lblQQ.textColor = RGBHex(kColorGray208);
    lblQQZone.textColor = RGBHex(kColorGray208);
    lblWeixin.textColor = RGBHex(kColorGray208);
    lblWexinLine.textColor = RGBHex(kColorGray208);
    [btnCancel setTitleColor:RGBHex(kColorGray208) forState:UIControlStateNormal];
    
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = win.bounds;
//    [self addSubview:effectview];
//    [self sendSubviewToBack:effectview];
    
    btnSina.tag=ShareEnumTypeSina;
    btnQQ.tag=ShareEnumTypeQQ;
    btnWeixin.tag=ShareEnumTypeWeixin;
    btnQQZone.tag = ShareEnumTypeQQZone;
    btnWexinLine.tag = ShareEnumTypeWexinLine;
    self.btnCopy.tag = ShareEnumTypeCopy;
}


- (void)show{
    [self UIGlobal];
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate]
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    CGRect frm=win.bounds;
    self.frame=frm;
    [win addSubview:self];
    //    [win bringSubviewToFront:self];
    
    
    
    frm=vBtns.frame;
    frm.origin.y=CGRectGetHeight(win.bounds);
    vBtns.frame=frm;
    
    [UIView animateWithDuration:.25 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
        
        CGRect frm;
        frm=vBtns.frame;
        frm.origin.y=CGRectGetHeight(win.bounds)-CGRectGetHeight(vBtns.frame);
        vBtns.frame=frm;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - action
- (IBAction)closeAction:(id)sender{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.15 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        CGRect frm;
        frm=vBtns.frame;
        frm.origin.y=CGRectGetHeight(win.bounds);
        vBtns.frame=frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}
- (IBAction)closeAction2:(id)sender {
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.15 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        CGRect frm;
        frm=vBtns.frame;
        frm.origin.y=CGRectGetHeight(win.bounds);
        vBtns.frame=frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (IBAction)clickAction:(id)sender{
    UIButton *btn=sender;
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.15 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
        CGRect frm;
        frm=vBtns.frame;
        frm.origin.y=CGRectGetHeight(win.bounds);
        vBtns.frame=frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.callBackBlock) {
            
            self.callBackBlock([btn tag]);
        }
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
