//
//  FeedbackVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/5/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "FeedbackVC.h"
#import "FeedbackCell.h"
#import "MineAPI.h"
#import "OtherAPI.h"
#define kAdviseSize 500
#define kCornerRadius 4.2
@interface FeedbackVC ()<UITextViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FeedbackCellDelegate,UIScrollViewDelegate>
{
    IBOutlet UITextField *phoneText;
    IBOutlet UITextView *adviseTxt;
    IBOutlet UIView *viewImg,*vSp;
    UIImage *heardImg;
    NSMutableArray *imgArr;
    IBOutlet UIButton *btnOk;
    IBOutlet NSLayoutConstraint *collectionViewH;
    IBOutlet UILabel *label,*labelR;
    UILabel *lblPlace;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *photoArr;
}

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    imgArr = [NSMutableArray array];
    [imgArr addObject:[UIImage imageNamed:@"Add_attachments"]];
    
    photoArr = [NSMutableArray array];
    
    if (APP_H > 647) {
        scrollView.scrollEnabled = NO;
    }else{
        scrollView.scrollEnabled = YES;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    lblPlace.hidden=NO;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [adviseTxt becomeFirstResponder];
    
}
#pragma mark - UI
- (void)UIGlobal{
    [super UIGlobal];
    collectionViewH.constant = (61*APP_W/375.0) + 15;
    [self naviTitle:@"意见反馈"];
    
    phoneText.font = fontSystem(13);
    phoneText.textColor = RGBHex(kColorGray201);
    
    adviseTxt.font = fontSystemBold(13);
    adviseTxt.textColor = RGBHex(kColorGray201);
    
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    
    phoneText.layer.borderWidth = 1;
    phoneText.layer.borderColor = RGBHex(kColorGray210).CGColor;
    phoneText.layer.cornerRadius = kCornerRadius;
    phoneText.delegate = self;
    
//    adviseTxt.layer.borderWidth = 1;
//    adviseTxt.layer.borderColor = RGBHex(kColorGray210).CGColor;
//    adviseTxt.layer.cornerRadius = kCornerRadius;
    adviseTxt.delegate = self;
    
    lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 30)];
    lblPlace.font = fontSystem(kFontS28);
    lblPlace.textColor = RGBHex(kColorGray211);
    lblPlace.text = @"请输入您的问题／建议";
    lblPlace.backgroundColor=[UIColor clearColor];
    [adviseTxt addSubview:lblPlace];
    lblPlace.hidden=YES;
    
    
    label.textColor = RGBHex(kColorGray201);
    label.font = fontSystem(kFontS22);
    labelR.textColor = RGBHex(kColorGray211);
    labelR.font = fontSystem(kFontS22);
    self.collectMain.backgroundColor = [UIColor clearColor];
    self.collectMain.scrollEnabled = NO;
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 45 )];
    phoneText.leftView = viewUser;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [vSp addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 16, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [vSp addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 57, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [vSp addSubview:sp3];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [self.view addGestureRecognizer:tap];
    [self naviTitle:@"意见反馈"];
}

#pragma mark collectionviewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark 返回多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedbackCell" forIndexPath:indexPath];
    if (imgArr.count < 2 || indexPath.row == imgArr.count - 1) {
        cell.btnDel.hidden = YES;
    }else{
        cell.btnDel.hidden = NO;
    }
    cell.delegate = self;
    [cell setCellImg:imgArr[indexPath.row]];
    return cell;
}
#pragma mark 返回每个item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake(61*APP_W/375.0, 61*APP_W/375.0);
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row=indexPath.row;
    if (row<imgArr.count) {
        if (indexPath.row == imgArr.count - 1 ) {
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
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ((APP_W-(61*APP_W/375.0*5)-20)/4.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10*APP_W/375.0, 0,10*APP_W/375.0);
        return inset;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0,((APP_W-(61*APP_W/375.0*5)-20)/4.0));
    return inset;
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)FeedbackCellDelegateDel:(id)delegate img:(id)img
{
    [imgArr removeObject:img];
    [self.collectMain reloadData];
    
}

- (void)chooseImageType:(NSInteger)sourceType
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
//    imagePick.allowsEditing = YES;
    imagePick.sourceType = sourceType;
    [self presentViewController:imagePick animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
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

        [OtherAPI UploadForAuth:imgData name:imageFileName objtype:UploadFileTypeDefault size:CGSizeZero success:^(UploadModel *model) {
            if (model) {
                [photoArr addObject:model.file_id];
            }
            
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
    image = [image cropThumbnailSize:61.0*kAutoScale*2];
    [imgArr insertObject:image atIndex:imgArr.count - 1];
    [self.collectMain reloadData];
}
// StatusBar变色问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}
#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (IBAction)btnOkAction:(id)sender {
    [self.view endEditing:YES];
    if (APP_H<=647) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    if ([QGLOBAL isPhoneNumber:phoneText.text] == NO || [[adviseTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self alertMessage:@"请输入正确联系方式和宝贵建议"];
    }else{
        phoneText.text = [phoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showLoading];
        NSString *photoStr = [photoArr componentsJoinedByString:@","];
        [MineAPI FeedbackContent:adviseTxt.text mobile:phoneText.text file:photoStr success:^(id model) {
            [self didLoad];
//            [self alerteMessage:@"您的意见已提交,我们会尽快处理,感谢您的支持"];
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"您的意见已提交,我们会尽快处理,感谢您的支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alt.delegate = self;
            [self.view addSubview:alt];
            [alt show];
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
        }];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self popVCAction:nil];
    }
}

#pragma mark - UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (APP_H<=647) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 100);
        }];
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self btnOkAction:nil];
    if (APP_H<=647) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (phoneText == textField) {
        if (aString.length > 70) {
            textField.text = [aString substringToIndex:70];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView
{
    DLog(@"%i",(int)textView.text.length);
    //adviseTxt.text = textView.text;
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
    
    NSInteger caninputlen = kAdviseSize - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
        [self alertMessage:@"输入长度超过限制"];
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
#pragma mark -scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
