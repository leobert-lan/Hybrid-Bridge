//
//  EvaluateVC.m
//  cyy_task
//
//  Created by zhchen on 16/9/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "EvaluateVC.h"
#import "TaskAPI.h"
@interface EvaluateVC ()<UITextViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UIView *vEvaluate,*vEndDate,*vLine;
    IBOutlet UIButton *btnRequire,*btnResou,*btnPay,*btnDate,*btnOk;
    IBOutlet UILabel *lblRequire,*lblResou,*lblPay,*lblDate,*lblName;
    IBOutlet UITextView *txtAdvise;
    NSArray *arrConfig;
    IBOutlet NSLayoutConstraint *vEvaluteH;
    NSString *strRequire,*strResou,*strPay,*strDate;
    IBOutlet UIImageView *imgHeard;
    UILabel *lblPlace;
    IBOutlet NSLayoutConstraint *adviseT;
    IBOutlet UIScrollView *scrollView;
    UIView *vNodata;
}
@end

@implementation EvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    vNodata = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:vNodata];
    vNodata.backgroundColor = [UIColor whiteColor];
    [self showLoading];
    lblPlace.hidden=NO;
    [self refreshList];
    [self refreshTaskDetailList];
    // Do any additional setup after loading the view from its nib.
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"评价"];
    
    lblRequire.textColor = RGBHex(kColorGray201);
    lblResou.textColor = RGBHex(kColorGray201);
    lblPay.textColor = RGBHex(kColorGray201);
    lblDate.textColor = RGBHex(kColorGray201);;
    
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    
    lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, APP_W - 30, 20)];
    lblPlace.numberOfLines = 0;
    lblPlace.font = fontSystem(kFontS28);
    lblPlace.textColor = RGBHex(kColorGray211);
    lblPlace.text = @"对于此次合作说点什么吧....";
    lblPlace.backgroundColor=[UIColor clearColor];
    [txtAdvise addSubview:lblPlace];
    lblPlace.hidden=YES;
    
    lblName.textColor = RGBHex(kColorGray201);
    
    imgHeard.clipsToBounds = YES;
    imgHeard.layer.cornerRadius = 50/2;
    
}

#pragma mark - 获取数据
- (void)refreshList
{
    [TaskAPI EvaluateConfigTaskbn:self.taskBn success:^(NSArray *arr) {
        arrConfig = [NSArray array];
        arrConfig = [arr copy];
        if (arr.count < 4) {
            vEndDate.hidden = YES;
            vLine.hidden = YES;
            EvaluateModel *model1 = arr[0];
            lblRequire.text = [NSString stringWithFormat:@"%@:",model1.name];
            EvaluateModel *model2 = arr[1];
            lblResou.text = [NSString stringWithFormat:@"%@:",model2.name];
            EvaluateModel *model3 = arr[2];
            lblPay.text = [NSString stringWithFormat:@"%@:",model3.name];
            adviseT.constant = -40;
        }else{
            vEndDate.hidden = NO;
            vLine.hidden = NO;
            vEvaluteH.constant = 125;
            EvaluateModel *model1 = arr[0];
            lblRequire.text = [NSString stringWithFormat:@"%@:",model1.name];
            EvaluateModel *model2 = arr[1];
            lblResou.text = [NSString stringWithFormat:@"%@:",model2.name];
            EvaluateModel *model3 = arr[2];
            lblPay.text = [NSString stringWithFormat:@"%@:",model3.name];
            EvaluateModel *model4 = arr[3];
            lblDate.text = [NSString stringWithFormat:@"%@:",model4.name];
            
        }
        [UIView animateWithDuration:0.25 animations:^{
            vNodata.alpha = 0;
            
        }];
        [self didLoad];
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
}
- (void)refreshTaskDetailList
{
    [TaskAPI TaskDetailsWithTaskbn:self.taskBn html2text:true success:^(TaskDetailModel *model) {
        [imgHeard setImageWithURL:[NSURL URLWithString:model.publisher.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        lblName.text = model.publisher.nickname;
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
}

#pragma mark - action
- (IBAction)btnRequireAction:(id)sender
{
    UIButton *btn = sender;
    strRequire = [NSString stringWithFormat:@"%ld",btn.tag - 1000];
    for (int i = 1; i < 6; i++) {
        if (i < btn.tag-1000+1) {
            UIButton *btnR = (UIButton *)[self.view viewWithTag:1000+i];
            [btnR setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }else{
            UIButton *btnR = (UIButton *)[self.view viewWithTag:1000+i];
            [btnR setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
        }
        
    }
}
- (IBAction)btnResouAction:(id)sender
{
    UIButton *btn = sender;
    strResou = [NSString stringWithFormat:@"%ld",btn.tag - 2000];
    for (int i = 1; i < 6; i++) {
        if (i < btn.tag-2000+1) {
            UIButton *btnR = (UIButton *)[self.view viewWithTag:2000+i];
            [btnR setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }else{
            UIButton *btnR = (UIButton *)[self.view viewWithTag:2000+i];
            [btnR setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
        }
        
    }
}
- (IBAction)btnPayAction:(id)sender
{
    UIButton *btn = sender;
    strPay = [NSString stringWithFormat:@"%ld",btn.tag - 3000];
    for (int i = 1; i < 6; i++) {
        if (i < btn.tag-3000+1) {
            UIButton *btnR = (UIButton *)[self.view viewWithTag:3000+i];
            [btnR setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }else{
            UIButton *btnR = (UIButton *)[self.view viewWithTag:3000+i];
            [btnR setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
        }
        
    }
}
- (IBAction)btnEndDateAction:(id)sender
{
    UIButton *btn = sender;
    strDate= [NSString stringWithFormat:@"%ld",btn.tag - 4000];
    for (int i = 1; i < 6; i++) {
        if (i < btn.tag-4000+1) {
            UIButton *btnR = (UIButton *)[self.view viewWithTag:4000+i];
            [btnR setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
        }else{
            UIButton *btnR = (UIButton *)[self.view viewWithTag:4000+i];
            [btnR setImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
        }
        
    }
}
- (IBAction)btnokAction:(id)sender
{
    if (arrConfig.count > 3) {
        if (StrIsEmpty(strRequire) || StrIsEmpty(strResou) || StrIsEmpty(strPay) || StrIsEmpty(strDate) || StrIsEmpty(txtAdvise.text)) {
            [self alertMessage:Msg_Evaluate];
        }else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSArray *btnArr = [NSArray arrayWithObjects:strRequire,strResou,strPay,strDate, nil];
            for (int i = 0; i < arrConfig.count; i++) {
                EvaluateModel *model = arrConfig[i];
                [dict setObject:btnArr[i] forKey:model.aid];
            }
            [TaskAPI EvaluateTaskbn:self.taskBn items:dict content:txtAdvise.text success:^(id model) {
                [self popVCAction:nil];
//                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NetError* err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
    }else{
    if (StrIsEmpty(strRequire) || StrIsEmpty(strResou) || StrIsEmpty(strPay) || StrIsEmpty(txtAdvise.text)) {
        [self alertMessage:Msg_Evaluate];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *btnArr = [NSArray arrayWithObjects:strRequire,strResou,strPay, nil];
        for (int i = 0; i < arrConfig.count; i++) {
            EvaluateModel *model = arrConfig[i];
            [dict setObject:btnArr[i] forKey:model.aid];
        }
        [TaskAPI EvaluateTaskbn:self.taskBn items:dict content:txtAdvise.text success:^(id model) {
            [self popVCAction:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
    }
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
#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        lblPlace.hidden = NO;
    }
    else{
        lblPlace.hidden = YES;
        
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            scrollView.scrollEnabled = NO;
        }];
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    if (APP_H == 647) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 50);
            scrollView.scrollEnabled = YES;
        }];
    }else if (APP_H < 647 && APP_H >= 548) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 120);
            scrollView.scrollEnabled = YES;
        }];
    }else if (APP_H < 548){
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 180);
            scrollView.scrollEnabled = YES;
        }];
    }
    
    return YES;
}
#pragma mark -scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
