//
//  SubmissionVC.m
//  cyy_task
//
//  Created by zhchen on 16/8/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SubmissionVC.h"
#import "TaskAPI.h"
@interface SubmissionVC ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *vMenu,*vSealedbid,*vOpenbid,*vContenview,*vlinese,*vtxt,*vhide,*vnohide;
    IBOutlet UILabel *lblProMoey,*lblDay,*lblWorkDay,*lblMoney,*lblWorkDayO,*lblDayO,*lblhint,*lblhide,*lblNoHide;
    IBOutlet UITextField *txtPro,*txtWork,*txtWorkO;
    IBOutlet UITextView *txtcontent;
    IBOutlet UIButton *btnAdd,*btnHide,*btnNoHide,*btnOk;
    IBOutlet NSLayoutConstraint *vMenuH;
    UILabel *lblPlace;
    UIImage *heardImg;
    BOOL ishide;
    BOOL isNohide;
    UIButton *btnDele;
    IBOutlet NSLayoutConstraint *scrollViewH,*vlinetH;
    IBOutlet UIScrollView *scrollView;
    NSString *attachment,*attachmentName,*isMark;
}
@end

@implementation SubmissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ishide = NO;
    isNohide = NO;
//    lblPlace.hidden=NO;
    [self SubmissionMenuInt];
    scrollView.scrollEnabled = NO;
    
    [MobClick event:UMTaskSubmisPage];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"投稿"];
    vContenview.backgroundColor=RGBHex(kColorGray207);
    vSealedbid.backgroundColor = RGBHex(kColorGray207);
    vOpenbid.backgroundColor = RGBHex(kColorGray207);
    vMenu.backgroundColor = RGBHex(kColorGray207);
    
    lblProMoey.textColor = RGBHex(kColorGray201);
    lblWorkDay.textColor = RGBHex(kColorGray201);
    lblMoney.textColor = RGBHex(kColorGray201);
    lblDay.textColor = RGBHex(kColorGray201);
    lblWorkDayO.textColor = RGBHex(kColorGray201);
    lblDayO.textColor = RGBHex(kColorGray201);
    lblhint.textColor = RGBHex(kColorGray203);
    lblhide.textColor = RGBHex(kColorGray201);
    lblNoHide.textColor = RGBHex(kColorGray201);
    
    txtPro.textColor = RGBHex(kColorGray201);
    txtWork.textColor = RGBHex(kColorGray201);
    txtWorkO.textColor = RGBHex(kColorGray201);
    
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
   
    
    vlinese.backgroundColor = RGBHex(kColorGray206);
    
    btnDele = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDele.frame = CGRectMake(61 - 22, 0, 22, 22);
    [btnDele setImage:[UIImage imageNamed:@"delete-1"] forState:UIControlStateNormal];
    [btnAdd addSubview:btnDele];
    btnDele.hidden = YES;
    [btnDele addTarget:self action:@selector(btnDeleAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnHide setImage:[UIImage imageNamed:@"single_button2"] forState:UIControlStateNormal];
    isMark = @"2";
    
}
- (void)SubmissionMenuInt
{
    if (APP_H < 647 && APP_H >= 548) {
        scrollViewH.constant = 150;
    }else if (APP_H < 548){
        scrollViewH.constant = 150;
    }
    
    UIView *sp2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    sp2.backgroundColor=RGBHex(kColorGray206);
    [vtxt addSubview:sp2];
    UIView *sp1=[[UIView alloc]initWithFrame:CGRectMake(0, 222-1, APP_W, 0.5)];
    sp1.backgroundColor=RGBHex(kColorGray206);
    [vtxt addSubview:sp1];
    
    UIView *sp3=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    sp3.backgroundColor=RGBHex(kColorGray206);
    [vhide addSubview:sp3];
    UIView *sp4=[[UIView alloc]initWithFrame:CGRectMake(0, 45, APP_W, 0.5)];
    sp4.backgroundColor=RGBHex(kColorGray206);
    [vhide addSubview:sp4];
    UIView *sp5=[[UIView alloc]initWithFrame:CGRectMake(0, 44, APP_W, 0.5)];
    sp5.backgroundColor=RGBHex(kColorGray206);
    [vnohide addSubview:sp5];
    
    lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(4, -5, APP_W - 30, 60)];
    lblPlace.numberOfLines = 0;
    lblPlace.font = fontSystem(kFontS28);
    lblPlace.textColor = RGBHex(kColorGray211);
    lblPlace.text = @"请填写稿件说明，说明的越具体清晰，中标的几率就越高哦。(50字内)";
    lblPlace.backgroundColor=[UIColor clearColor];
    [txtcontent addSubview:lblPlace];
    if (self.isMArk.intValue == 3) {
        lblhint.text = @"(附件必选，仅限一张)";
    }else{
        lblhint.text = @"(附件可选，仅限一张)";
    }
    vMenu.width = APP_W;
    
    int num = [self.isMArk intValue];
    switch (num) {
        case 1:{
            vMenuH.constant = 55;
            UIView *sp2=[[UIView alloc]initWithFrame:CGRectMake(0, 45, APP_W, 0.5)];
            sp2.backgroundColor=RGBHex(kColorGray206);
            [vMenu addSubview:sp2];
            vOpenbid.frame = CGRectMake(0, 0, CGRectGetWidth(vMenu.frame), 45);
            [vMenu addSubview:vOpenbid];
            break;
        }
        case 2:{
            vMenuH.constant = 100;
            UIView *sp2=[[UIView alloc]initWithFrame:CGRectMake(0, 91, APP_W, 0.5)];
            sp2.backgroundColor=RGBHex(kColorGray206);
            [vMenu addSubview:sp2];
            vSealedbid.frame = CGRectMake(0, 0, CGRectGetWidth(vMenu.frame), 90.5);
            [vMenu addSubview:vSealedbid];
            break;
        }
        case 3:
            vMenuH.constant = 0;
            break;
        default:
            break;
    }
}
#pragma mark - action
- (IBAction)btnAddAction:(id)sender {
    [self.view endEditing:YES];
    if (APP_H < 647 && APP_H >= 548) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            scrollView.scrollEnabled = NO;
        }];
    }else if (APP_H < 548){
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
//            scrollView.scrollEnabled = NO;
        }];
    }
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self chooseImageType:UIImagePickerControllerSourceTypeCamera];
        }
    }];
    [alt addAction:camera];
    UIAlertAction *PhotoLibrary = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseImageType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    [alt addAction:PhotoLibrary];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}
- (void)btnDeleAction:(UIButton *)sender
{
    [btnAdd setImage:[UIImage imageNamed:@"Add_attachments"] forState:UIControlStateNormal];
    btnDele.hidden = YES;
}
- (IBAction)btnHideAction:(id)sender {
    [self.view endEditing:YES];
    ishide = !ishide;
//    isNohide = !isNohide;
    if (ishide) {
        isMark = @"2";
        [btnHide setImage:[UIImage imageNamed:@"single_button2"] forState:UIControlStateNormal];
        [btnNoHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
        isNohide = NO;
    }else{
    [btnHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
        [btnNoHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
    }
    
    
    
    
    
}
- (IBAction)btnNoHideAction:(id)sender {
    [self.view endEditing:YES];
    isNohide = !isNohide;
//    ishide = !ishide;
    if (isNohide) {
        isMark = @"1";
        [btnNoHide setImage:[UIImage imageNamed:@"single_button2"] forState:UIControlStateNormal];
        [btnHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
        ishide = NO;
    }else{
        [btnNoHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
        [btnHide setImage:[UIImage imageNamed:@"single_button1"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnOkAction:(id)sender
{
    
    if(self.isMArk.intValue == 1 || self.isMArk.intValue == 2){
        if ([txtcontent.text isEqualToString:@""] || isMark == nil) {
            [self showText:@"请完善投稿信息"];
            
            [MobClick event:UMTaskSubmisIncompl];
        }else{
            NSString *days;
            int num = [self.isMArk intValue];
            switch (num) {
                case 1:
                    days = txtWorkO.text;
                    break;
                case 2:
                    days = txtWork.text;
                    break;
                case 3:
                    
                    break;
                default:
                    break;
            }
            [self showLoading];
            [TaskAPI SubmissionTaskbn:self.taskBn description:txtcontent.text attachments:attachment attachment_name:attachmentName days:days price:txtPro.text isMArk:isMark type:num success:^(id model) {
                [MobClick event:UMTaskSubmission attributes:@{@"success":StrFromInt(1)}];
                [self showText:@"投稿成功"];
                [self performSelector:@selector(popVcAction) withObject:nil afterDelay:1.3];
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [MobClick event:UMTaskSubmission attributes:@{@"failure":StrFromInt(err.errStatusCode)}];
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
    }else{
        if ([txtcontent.text isEqualToString:@""] || [attachment isEqualToString:@""] || heardImg == nil || isMark == nil  || attachment == nil) {
            [self showText:@"请完善投稿信息"];
        }else{
            NSString *days;
            int num = [self.isMArk intValue];
            switch (num) {
                case 1:
                    days = txtWorkO.text;
                    break;
                case 2:
                    days = txtWork.text;
                    break;
                case 3:
                    
                    break;
                default:
                    break;
            }
            [self showLoading];
            [TaskAPI SubmissionTaskbn:self.taskBn description:txtcontent.text attachments:attachment attachment_name:attachmentName days:days price:txtPro.text isMArk:isMark type:num success:^(id model) {
                [self showText:@"投稿成功"];
                 [self performSelector:@selector(popVcAction) withObject:nil afterDelay:1.3];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.submissionBlock) {
//                        
//                        self.submissionBlock();
//                    }
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
    }
}

- (void)popVcAction{
    if (self.submissionBlock) {
        
        self.submissionBlock();
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self popVCAction:nil];
}
#pragma mark - UIImagePickerControllerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image=[QYImage fixImageOrientation:image];
    NSData *imgData = UIImageJPEGRepresentation(image, .85);
    __block NSString* imageFileName;
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        imageFileName = [representation filename];
        if (imageFileName == nil) {
            imageFileName = [NSString stringWithFormat:@"%@.%@",[QGLOBAL dateToTimeInterval:[NSDate date]],@"jpg"];
        }else{
            NSArray *nameArr = [imageFileName componentsSeparatedByString:@"."];
            imageFileName = [NSString stringWithFormat:@"%@%@.%@",[nameArr firstObject],[QGLOBAL dateToTimeInterval:[NSDate date]],[nameArr lastObject]];
        }
        [OtherAPI UploadFile:imgData name:imageFileName success:^(NSString *path) {
            attachment = path;
            attachmentName = imageFileName;
        } failure:^(NetError *err) {
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self didLoad];
            
            [self showText:err.errMessage];
        } sendDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        }];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
    
    heardImg = image;
    btnDele.hidden = NO;
    image = [image cropThumbnailSize:61.0*2];
    [btnAdd setImage:image forState:UIControlStateNormal];
}
// StatusBar变色问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}
- (void)chooseImageType:(NSInteger)sourceType
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
//    imagePick.allowsEditing = YES;
    imagePick.sourceType = sourceType;
    [self presentViewController:imagePick animated:YES completion:nil];
}
#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 50 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
//        [self alertMessage:@"输入长度超过限制"];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    scrollView.scrollEnabled = YES;
    if (self.isMArk.intValue == 1|| self.isMArk.intValue == 2) {
    if (APP_H < 647 && APP_H >= 548) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 50);
        }];
    }else if (APP_H < 548){
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 100);
        }];
    }
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
