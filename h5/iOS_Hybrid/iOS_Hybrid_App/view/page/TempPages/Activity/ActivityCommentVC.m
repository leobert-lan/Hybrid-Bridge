//
//  ActivityCommentVC.m
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ActivityCommentVC.h"
#import "ActivityAPI.h"
#import "ActivityCmtListVC.h"
#import "loginVC.h"
#define Msg_lblPlaceholder @"请在此输入您的评论（最多140字）"
@interface ActivityCommentVC ()<UITextViewDelegate>
{
    IBOutlet UITextView *txtComment;
    UILabel *lblPlaceholder;
    IBOutlet UIButton *btnOK;
    IBOutlet UILabel *lblHint,*lblHintT,*lblNum;
    IBOutlet UIView *vLine;
}
@end

@implementation ActivityCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self alertMessage:@"活动期间,每个用户仅限评论1次,请认真填写哦!"];
    [self lblPlaceholderCreat];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"填写评论"];
    self.view.backgroundColor = RGBHex(kColorTmp003);
    
    btnOK.backgroundColor = RGBHex(kColorGray211);
    btnOK.layer.borderColor = RGBHex(kColorGray211).CGColor;
    [btnOK setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    btnOK.layer.borderWidth = 1;
    btnOK.layer.cornerRadius = kCornerRadius;
    btnOK.userInteractionEnabled = NO;
    
    lblHint.font = fontSystem(kFontS26);
    lblHint.textColor = RGBHex(kColorTmp007);
    
    lblHintT.font = fontSystem(kFontS26);
    lblHintT.textColor = RGBHex(kColorTmp007);
    
    lblNum.font = fontSystem(kFontS26);
    lblNum.textColor = RGBHex(kColorTmp008);
    lblNum.text = @"0/140";
    vLine.backgroundColor = RGBHex(kColorTmp008);
    
    txtComment.font = fontSystem(kFontS26);
    txtComment.textColor = RGBHex(kColorTmp007);
}
- (void)lblPlaceholderCreat
{
    lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, APP_W-35, 30)];
    lblPlaceholder.font = fontSystem(kFontS26);
    lblPlaceholder.textColor = RGBHex(kColorTmp008);
    lblPlaceholder.text = Msg_lblPlaceholder;
    lblPlaceholder.backgroundColor = [UIColor clearColor];
    [txtComment addSubview:lblPlaceholder];
}
#pragma mark - action
- (IBAction)btnOKAction:(id)sender {
    if (StrIsEmpty(txtComment.text)) {
        [self didLoad];
        [self alertMessage:Msg_lblPlaceholder];
    }else if (![QGLOBAL hadAuthToken]){
        loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
    }else{
        [self showLoadingWithMessage:@"正在提交"];
        [self btnOKStatus:NO];
        [ActivityAPI ActivityCreatCommentContent:txtComment.text Success:^(id model) {
            [self didLoad];
            if ([self.delegate respondsToSelector:@selector(ActivityCommentDelegate:success:)]) {
                [self.delegate ActivityCommentDelegate:self success:YES];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NetError* err) {
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self didLoad];
            [self btnOKStatus:YES];
            [self showText:err.errMessage];
        }];
    }
}

- (void)btnOKStatus:(BOOL)Status
{
    if (Status) {
        btnOK.backgroundColor = RGBAHex(kColorTmp001, 1);
        btnOK.layer.borderColor = RGBHex(kColorTmp001).CGColor;
        [btnOK setTitleColor:RGBHex(kColorTmp004) forState:UIControlStateNormal];
        btnOK.userInteractionEnabled = YES;
    }else{
        [btnOK setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
        btnOK.backgroundColor = RGBHex(kColorGray211);
        btnOK.layer.borderColor = RGBHex(kColorGray211).CGColor;
        btnOK.userInteractionEnabled = NO;
    }
}
#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        lblNum.text = @"0/140";
        lblPlaceholder.text = Msg_lblPlaceholder;
        [self btnOKStatus:NO];
    }else{
        lblNum.text = [NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length];
        lblPlaceholder.text = @"";
        [self btnOKStatus:YES];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
        return YES;
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 140 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
        [self alertMessage:@"输入长度超过限制"];
        lblNum.text = @"140/140";
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)alertMessage:(NSString *)message
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [self presentViewController:alt animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
