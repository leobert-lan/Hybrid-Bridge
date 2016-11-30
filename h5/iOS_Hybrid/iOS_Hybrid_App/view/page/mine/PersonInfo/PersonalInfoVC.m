//
//  PersonalInfoVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "personalHeardCell.h"
#import "personalInfoCell.h"
#import "changeNicknameVC.h"
#import "phoneBound.h"
#import "changePwdVC.h"
#import "MineAPI.h"
#import "changePhoneNumVC.h"
#import "SignAPI.h"
#import "SubscripNewVC.h"
#import "ForgotPwdVerifyPhoneVC.h"
@interface PersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *infoArr,*infoArrR;
    UIImage *imgAvatar;
    PersonalInfoModel *personalInfoModelmodel;
    NSMutableArray *phoneArray;
//    NSString *attachment;
    UIView *vNodata;
}
@end

@implementation PersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    vNodata = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:vNodata];
    vNodata.backgroundColor = [UIColor whiteColor];
    
    
    [self refreshList];
}

#pragma mark - 获取数据
- (void)refreshList
{
    [self showLoading];
    [SignAPI getUserInfoUsername:QGLOBAL.auth.username success:^(UserModel *model) {
        [self removeInfoRefreshView];
        [UIView animateWithDuration:0.25 animations:^{
            vNodata.alpha = 0;
            
        }];
        DLog(@"%@",model.avatar);
        
        UserModel *userModel = [[UserModel alloc] init];
        userModel = model;
        QGLOBAL.usermodel = userModel;
        [self makeInfo];
        
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        [self didLoad];
        [self showInfoRefreshView:@"网络连接超时,请检查您的手机是否联网" image:@"pic_timeout" btnHidden:NO sel:@selector(refreshList)];
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
//        [self showText:err.errMessage];
    }];
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"个人资料"];
}
- (void)makeInfo{
    if ([QGLOBAL.usermodel.sex integerValue] == 0) {
        QGLOBAL.usermodel.sex = @"保密";
    }else if ([QGLOBAL.usermodel.sex integerValue] == 1){
        QGLOBAL.usermodel.sex = @"男";
    }else{
        QGLOBAL.usermodel.sex = @"女";
    }
    infoArrR = [NSMutableArray arrayWithCapacity:6];
    
    if (StrIsEmpty(QGLOBAL.usermodel.nickname)) {
        QGLOBAL.usermodel.nickname = @"";
    }
    if (StrIsEmpty(QGLOBAL.usermodel.sex)) {
        QGLOBAL.usermodel.sex = @"";
    }
    if (StrIsEmpty(QGLOBAL.usermodel.mobile)) {
        QGLOBAL.usermodel.mobile = @"";
    }
    
    infoArr = [NSMutableArray arrayWithObjects:@"昵称",@"性别",@"订阅", nil];
    infoArrR = [NSMutableArray arrayWithObjects:QGLOBAL.usermodel.nickname,QGLOBAL.usermodel.sex,@"",QGLOBAL.usermodel.mobile,@"****",nil];
    phoneArray = [NSMutableArray arrayWithObjects:@"手机",@"修改密码", nil];
    
    if (QGLOBAL.indusArr.count == 0) {
        [self indusArr];
    }
}

#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return infoArr.count;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < infoArrR.count) {
    
    if (indexPath.section == 0) {
        personalHeardCell *heardCell = [tableView dequeueReusableCellWithIdentifier:@"personalHeardCell" forIndexPath:indexPath];
        heardCell.imgAvatar=imgAvatar;
        [heardCell setCell:QGLOBAL.usermodel];
        return heardCell;
    }
    else if(indexPath.section == 1){
        personalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalInfoCell" forIndexPath:indexPath];
        [cell setNameL:infoArr[indexPath.row] nameR:infoArrR[indexPath.row]];
        return cell;
    }
    else{
        personalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalInfoCell" forIndexPath:indexPath];
        [cell setNameL:phoneArray[indexPath.row] nameR:infoArrR[indexPath.row + 3]];
        return cell;
    }
    }else{
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self changePersonalAvatar];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self changePersonalNickname:indexPath.row];
        }else if (indexPath.row == 1){
            [self changePersonalSex];
            
        }else if (indexPath.row == 2){
            [MobClick event:UMSubscrFromMine];
            
            SubscripNewVC *vc=[[SubscripNewVC alloc]initWithNibName:@"SubscripNewVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self changePersonalPhone];
            
        }else if (indexPath.row == 1){
            changePwdVC *vc=(changePwdVC *)[QGLOBAL viewControllerName:@"changePwdVC" storyboardName:@"PersonalInfo"];
            vc.delegatePopVC=self.delegatePopVC;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCellHeight + 20;
    }else{
        return kCellHeight;
    }
}
#pragma mark - 修改头像
- (void)changePersonalAvatar
{
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
- (void)chooseImageType:(NSInteger)sourceType
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
//    imagePick.allowsEditing = YES;
    imagePick.sourceType = sourceType;
    [self showLoading];
    [self presentViewController:imagePick animated:YES completion:^{
        [self didLoad];
    }];
}
- (void)changeAvatar:(NSString *)avatar
{
    DLog(@">>>%@",avatar);
    [self showLoading];
    [MineAPI mineChangeInfoInfoLab:@"avatar" info:avatar success:^(id model) {
//        [self performSelector:@selector(waitingForAvatar) withObject:nil afterDelay:3];
        [self didLoad];
        [self changeAvatar];
   
        
    } failure:^(NetError *err) {
        [self didLoad];
        [self showText:err.errMessage];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
}
#pragma mark - 修改昵称
- (void)changePersonalNickname:(NSInteger)index
{
    changeNicknameVC *vc =(changeNicknameVC *)[QGLOBAL viewControllerName:@"changeNicknameVC" storyboardName:@"PersonalInfo"];
    vc.nickname = infoArrR[index];
    
    vc.changeNickname = ^(NSString *nickname){
        [infoArrR replaceObjectAtIndex:0 withObject:nickname];
        UserModel *userModel = [[UserModel alloc] init];
        userModel = QGLOBAL.usermodel;
        userModel.nickname = nickname;
        QGLOBAL.usermodel = userModel;
        [QGLOBAL.sideMenu setUserInfo:QGLOBAL.usermodel];
        [self.tableMain reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 修改性别
- (void)changePersonalSex
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __block NSString *sex;
    UIAlertAction *man = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = @"1";
        [self changeSex:sex];
    }];
    
    UIAlertAction *woman = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = @"2";
        [self changeSex:sex];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alt addAction:man];
    [alt addAction:woman];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
    
}
- (void)changeSex:(NSString *)sex
{
    [self showLoading];
    [MineAPI mineChangeInfoInfoLab:@"sex" info:sex success:^(id model) {
        UserModel *usermodel = [[UserModel alloc] init];
        usermodel = QGLOBAL.usermodel;
        usermodel.sex = sex;
       
        if ([usermodel.sex integerValue] == 0) {
            [infoArrR replaceObjectAtIndex:1 withObject:@"保密"];
        }else if ([usermodel.sex integerValue] == 1){
            [infoArrR replaceObjectAtIndex:1 withObject:@"男"];
        }else{
            [infoArrR replaceObjectAtIndex:1 withObject:@"女"];
        }
        QGLOBAL.usermodel = usermodel;
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError *err) {
        [self didLoad];
        [self showText:err.errMessage];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
}
#pragma mark - 修改手机号
- (void)changePersonalPhone
{
    if ([QGLOBAL.usermodel.mobile isEqualToString:@""]) {
        phoneBound *vc=(phoneBound *)[QGLOBAL viewControllerName:@"phoneBound" storyboardName:@"PersonalInfo"];
        vc.phoneBoundBlock = ^(NSString *phoneNum){
            QGLOBAL.usermodel.mobile = phoneNum;
            [self.tableMain reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        changePhoneNumVC *vc=(changePhoneNumVC *)[QGLOBAL viewControllerName:@"changePhoneNumVC" storyboardName:@"PersonalInfo"];
        vc.phoneNum = QGLOBAL.usermodel.mobile;
        vc.changePhoneNumBlock = ^(NSString *phoneNum){
            QGLOBAL.usermodel.mobile = phoneNum;
            [self.tableMain reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - UIImagePickerControllerdelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self didLoad];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self showLoading];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imgAvatar=[QYImage fixImageOrientation:image];
    imgAvatar=[imgAvatar imageByScalingAndCroppingForSize:CGSizeMake(480, 480)];
//    [self.tableMain reloadData];
    
    NSData *imgData = UIImageJPEGRepresentation(imgAvatar, 0.75);
    __block NSString* imageFileName;
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        imageFileName = [representation filename];
        if (imageFileName == nil) {
            imageFileName = [NSString stringWithFormat:@"%@.%@",[QGLOBAL dateToTimeInterval:[NSDate date]],@"JPG"];
        }
        else{
            NSArray *nameArr = [imageFileName componentsSeparatedByString:@"."];
            imageFileName = [NSString stringWithFormat:@"%@%@.%@",[nameArr firstObject],[QGLOBAL dateToTimeInterval:[NSDate date]],[nameArr lastObject]];
        }
        
        
        [OtherAPI UploadForAuth:imgData name:imageFileName objtype:UploadFileTypeSpace size:CGSizeZero success:^(UploadModel *model) {

//            attachment = model.file_url;
            DLog(@"%@",model.file_url);
            [self changeAvatar:model.file_url];
        } failure:^(NetError *err) {
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self didLoad];
            
            [self showText:err.errMessage];
        } sendDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        }];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
}


// StatusBar变色问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}
- (void)indusArr
{
    [MineAPI IndusGetListsuccess:^(NSMutableArray * array) {
        QGLOBAL.indusArr = array;
    } failure:^(NetError *err) {
        [self showText:err.errMessage];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
}

#pragma mark - 头像
//愚蠢的服务器，图片服务器转移头像有延迟
- (void)waitingForAvatar{
    [self didLoad];
    [QGLOBAL.sideMenu setUserInfo:QGLOBAL.usermodel];
    
    [self.tableMain reloadData];
}

- (void)changeAvatar{
    [self didLoad];
    
//    //获取头像,刷新导航栏头像
//    UIImage* newImg=[imgAvatar imageByScalingAndCroppingForSize:CGSizeMake(240, 240)];
//    QGLOBAL.navAvatar=[UIImage createRoundedRectImage:newImg radius:newImg.size.height/2];;
//    [QGLOBAL postNotif:NotifLoginSuccess data:QGLOBAL.navAvatar object:nil];
    [QGLOBAL.sideMenu updateAvatar:imgAvatar];
    [self.tableMain reloadData];
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
