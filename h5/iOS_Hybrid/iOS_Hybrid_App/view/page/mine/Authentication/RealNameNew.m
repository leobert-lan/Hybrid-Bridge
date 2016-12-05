//
//  RealNameNew.m
//  cyy_task
//
//  Created by zhchen on 16/10/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "RealNameNew.h"
#import "AuthTextFieldCell.h"
#import "ASBirthSelectSheet.h"
#import "AuthCardPhotoCell.h"
#import "AuthCardConPhotoCell.h"
#import "AuthCardPerPhotoCell.h"
#import "CNIDCheck.h"
#import "MineAPI.h"
#import "AuthStatusTableDataSource.h"

static CGFloat kMargin = 6;
@interface RealNameNew ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,cloudBaseCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITableView *authStatusTbl;
    IBOutlet UIView *vAuth,*vauthStatus;
    NSInteger areaNum,btnTag;
    NSMutableArray *mainlandArr,*imgCardArr,*dateArr;
    UIView *vRealMenu,*vBlue;
    CGFloat menuW;
    NSString *strDate,*endDate,*areaStr,*areaHK,*strName,*strCard,*strDateF,*endDateF,*strBtnStart,*strBtnEnd;
    NSString *proStr,*conStr,*perStr;
    BOOL istypeVc;
    AuthStatusTableDataSource *authTbl;
    NSMutableArray *dataArr,*cardImgArr;
    NSString *area,*name,*card,*cardVal;
    int refreshType;
}
@end

@implementation RealNameNew

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableDataSourceInit];
    areaNum = 0;
    // Do any additional setup after loading the view from its nib.
    
}
#pragma mark - table
- (void)tableDataSourceInit
{
    [self showLoadingWin];
    if (self.isAgain) {
        self.isAgain = NO;
        [self didLoad];
        istypeVc = YES;
        imgCardArr = [NSMutableArray arrayWithObjects:@"card1",@"card2",@"card3", nil];
        [self vMainland];
        vAuth.frame = CGRectMake(0, 0, APP_W, APP_H);
        [self.view addSubview:vAuth];
        [self.view bringSubviewToFront:vAuth];
        [self.tableMain reloadData];
    }else{
    [MineAPI RealNAmeQuerysuccess:^(RealNameModel *model) {
        [self naviTitle:@"实名认证"];
        self.realNameModel = model;
        istypeVc = NO;
        authTbl = [[AuthStatusTableDataSource alloc] init];
        authTbl.delegate = self;
        authStatusTbl.dataSource = authTbl;
        authStatusTbl.delegate = authTbl;
        authTbl.realNameModel = model;
        authStatusTbl.backgroundColor=RGBHex(kColorGray207);
        [self makeint];
        authTbl.dataArr = dataArr;
        authTbl.imgArr = cardImgArr;
        authTbl.delegatePopVC = self.delegatePopVC;
        authTbl.delegateNav = [QGLOBAL.mainFrame navigationController];
        vauthStatus.frame = CGRectMake(0, 0,APP_W,APP_H);
        [self.view addSubview:vauthStatus];
        [self.view bringSubviewToFront:vauthStatus];
        [authStatusTbl setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
        [authStatusTbl  setSeparatorColor:[UIColor clearColor]];
        [self didLoad];
    } failure:^(NetError *err) {
        [self didLoad];
        istypeVc = YES;
        imgCardArr = [NSMutableArray arrayWithObjects:@"card1",@"card2",@"card3", nil];
        [self vMainland];
        vAuth.frame = CGRectMake(0, 0, APP_W, APP_H);
        [self.view addSubview:vAuth];
        [self.view bringSubviewToFront:vAuth];
        [self.tableMain reloadData];
        
    }];
    }
}
- (void)vMainland
{
    
    mainlandArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
    
    strBtnStart = @"";
    strBtnEnd = @"";
    dateArr = [NSMutableArray arrayWithObjects:strBtnStart,strBtnEnd, nil];
    [self naviTitle:@"实名认证"];
    
    RealNameModelDB *ModelDB = [RealNameModelDB getModelFromDB];
    if (ModelDB.isEdit.boolValue == YES) {
        if (StrIsEmpty(ModelDB.realname)) {
            ModelDB.realname = @"";
        }
        if (StrIsEmpty(ModelDB.id_card)) {
            ModelDB.id_card = @"";
        }
        if (StrIsEmpty(ModelDB.validity_e_time)) {
            ModelDB.validity_e_time = @"";
        }
        if (StrIsEmpty(ModelDB.validity_s_time)) {
            ModelDB.validity_s_time = @"";
        }
        strName = ModelDB.realname;
        strCard = ModelDB.id_card;
        mainlandArr = [NSMutableArray arrayWithObjects:ModelDB.realname,ModelDB.id_card, nil];
        if ([ModelDB.auth_area integerValue] == 0) {
            [dateArr replaceObjectAtIndex:0 withObject:ModelDB.validity_s_time];
            [dateArr replaceObjectAtIndex:1 withObject:ModelDB.validity_e_time];
            
            strDateF = ModelDB.validity_s_time;
            endDateF = ModelDB.validity_e_time;
            strDate = ModelDB.s_time;
            endDate = ModelDB.e_time;
            
        }else if ([ModelDB.auth_area integerValue] == 2 || [ModelDB.auth_area integerValue] == 3){
            areaHK = ModelDB.authH;
            if ([ModelDB.auth_area integerValue] == 2) {
                areaStr = @"2";
            }else{
                areaStr = @"3";
            }
            [dateArr replaceObjectAtIndex:0 withObject:ModelDB.validity_s_time];
            [dateArr replaceObjectAtIndex:1 withObject:ModelDB.validity_e_time];
            strDateF = ModelDB.validity_s_time;
            endDateF = ModelDB.validity_e_time;
            strDate = ModelDB.s_time;
            endDate = ModelDB.e_time;
        }
    }
//    [self.tableMain reloadData];
}
- (void)UIGlobal
{
    [super UIGlobal];
    
}

#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (areaNum == 0) {
        if (section == 0) {
            return mainlandArr.count+2;
        }else{
            return 7;
        }
        
    }else if (areaNum == 1){
        if (section == 0) {
            return mainlandArr.count+3;
        }else{
            return 7;
        }
        
    }else{
        if (section == 0) {
            return mainlandArr.count+1;
        }else{
            return 7;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (istypeVc) {
        
        
        static NSString *tableID;
        
        AuthCell *cell;
        if (areaNum == 0) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 3) {
                    tableID = @"AuthCardCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 2 || indexPath.row == 4){
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 3){
                    tableID = @"AuthCardConPhotoCell";
                }else if (indexPath.row == 5){
                    tableID = @"AuthCardPerPhotoCell";
                }else if (indexPath.row == 6){
                    tableID = @"AuthOkCell";
                }
            }
        }else if (areaNum == 1){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 1) {
                    tableID = @"AuthSeleteAreaCell";
                }else if (indexPath.row == 4){
                    tableID = @"AuthCardCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
            }else{
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 2 || indexPath.row == 4){
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 3){
                    tableID = @"AuthCardConPhotoCell";
                }else if (indexPath.row == 5){
                    tableID = @"AuthCardPerPhotoCell";
                }else if (indexPath.row == 6){
                    tableID = @"AuthOkCell";
                }
            }
        }else if (areaNum == 2){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    tableID = @"AuthKongCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
            }else{
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 2 || indexPath.row == 4){
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 3){
                    tableID = @"AuthCardConPhotoCell";
                }else if (indexPath.row == 5){
                    tableID = @"AuthCardPerPhotoCell";
                }else if (indexPath.row == 6){
                    tableID = @"AuthOkCell";
                }
            }
        }
        cell = (AuthCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        
        
        
        cell.delegate=self;
        if (indexPath.section == 0) {
            
            if (areaNum == 0) {
                if (indexPath.row>0 && indexPath.row < 3) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请输入身份证号", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 1];
                    
                    [cell setCell:mainlandArr[indexPath.row-1]];
                }else if (indexPath.row==3){
                    [cell setCell:dateArr];
                }else{
                    [cell setCell:nil];
                }
            }else if (areaNum == 1){
                if (indexPath.row>1 && indexPath.row < 4) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请输入身份证号", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 2];
                    [cell setCell:mainlandArr[indexPath.row-2]];
                }else if (indexPath.row == 1){
                    if (areaHK == nil || [areaHK isEqualToString:@""]) {
                        [cell setCell:@"请选择您的所属地区"];
                    }else{
                        [cell setCell:areaHK];
                    }
                }else if (indexPath.row==4){
                    [cell setCell:dateArr];
                }else{
                    [cell setCell:nil];
                }
            }else{
                if (indexPath.row>0 && indexPath.row < 3) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请输入身份证号", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 1];
                    [cell setCell:mainlandArr[indexPath.row-1]];
                }else{
                    [cell setCell:nil];
                }
            }
        }else{
            cell.separatorHidden = YES;
            if (indexPath.row > 0) {
                if (indexPath.row == 1) {
                    [cell setCell:imgCardArr[indexPath.row - 1]];
                }else if (indexPath.row == 3){
                    [cell setCell:imgCardArr[indexPath.row - 2]];
                }else if (indexPath.row == 5){
                    [cell setCell:imgCardArr[indexPath.row - 3]];
                }else{
                    [cell setCell:nil];
                }
            }else{
                [cell setCell:nil];
            }
            
        }
        
        return cell;
        
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 10;
        }
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 45;
        }else if (indexPath.row == 2 || indexPath.row == 4){
            return 5;
        }
        return kAutoScale *170;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (istypeVc) {
        if (section == 0) {
            return 45;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        vRealMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 45)];
        [self taskMenuInit];
        return vRealMenu;
    }else if (section == 1){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 20)];
//        view.backgroundColor = RGBHex(kColorGray207);
//        return view;
    }
    return nil;
}


#pragma mark - UI
- (void)taskMenuInit{
    CGRect frm;
    int num=3;
    vRealMenu.width = APP_W;
    menuW=vRealMenu.width/num;
    
    vRealMenu.backgroundColor=RGBHex(kColorW);
    frm=vRealMenu.bounds;
    frm.size.height=0.5;
    frm.origin.y=45-0.5;
    UIView *sep=[[UIView alloc]initWithFrame:frm];
    sep.backgroundColor=RGBHex(kColorGray206);
    [vRealMenu addSubview:sep];
    
    //菜单
    int i =0;
    while (i<num) {
        
        frm=CGRectMake(0, 0, menuW, 45);
        frm.origin.x=i*frm.size.width;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        btn.titleLabel.font=fontSystem(kFontS28);
        [btn setTitleColor:RGBHex(kColorGray202) forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(kColorGray211) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        switch (i) {
            case 0:
                [btn setTitle:@"大陆地区" forState:UIControlStateNormal];
                break;
            case 1:
                [btn setTitle:@"港澳地区" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"台湾地区" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [vRealMenu addSubview:btn];
        
        //分割线
        if (i+1 != num) {
            frm=CGRectMake((i+1)*menuW, (45-22)/2, 0.5, 22);
            UIView *fg=[[UIView alloc]initWithFrame:frm];
            fg.backgroundColor=RGBHex(kColorGray206);
            [vRealMenu addSubview:fg];
        }
        i++;
    }
    
    frm=CGRectMake(areaNum*menuW+kMargin, sep.y-1, menuW-kMargin*2, 1);
    vBlue=[[UIView alloc]initWithFrame:frm];
    vBlue.backgroundColor=RGBHex(kColorMain001);
    [vRealMenu addSubview:vBlue];
    
}

#pragma mark - CellDelegate
- (void)AuthSelectStartDateDeDelegate:(id)delegate
{
    [self.view endEditing:YES];
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSDate *date) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        strDateF = [formatter stringFromDate:date];
        
        [dateArr replaceObjectAtIndex:0 withObject:[formatter stringFromDate:date]];
        strDate=[QGLOBAL dateToTimeInterval:date];
        RealNameModelDB *mm = [RealNameModelDB getModelFromDB];
        mm.s_time = strDate;
        mm.validity_s_time = strDateF;
        QGLOBAL.realNameModelDB = mm;
        NSInteger row;
        if (areaNum == 0) {
            row = 3;
        }else{
            row = 4;
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:datesheet];
}
- (void)AuthSelectEndDateDeDelegate:(id)delegate
{
    [self.view endEditing:YES];
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSDate *date) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        endDateF=[formatter stringFromDate:date];
        [dateArr replaceObjectAtIndex:1 withObject:[formatter stringFromDate:date]];
        endDate=[QGLOBAL dateToTimeInterval:date];
        RealNameModelDB *mm = [RealNameModelDB getModelFromDB];
        mm.e_time = endDate;
        mm.validity_e_time = endDateF;
        QGLOBAL.realNameModelDB = mm;
        NSInteger row;
        if (areaNum == 0) {
            row = 3;
        }else{
            row = 4;
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:datesheet];
}
- (void)AuthSelectAreaDeDelegate:(id)delegate{
    [self.view endEditing:YES];
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __block NSString *areaS;
    UIAlertAction *man = [UIAlertAction actionWithTitle:@"香港" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        areaS = @"2";
        areaStr = areaS;
        areaHK = @"香港";
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction *woman = [UIAlertAction actionWithTitle:@"澳门" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        areaS = @"3";
        areaStr = areaS;
        areaHK = @"澳门";
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alt addAction:man];
    [alt addAction:woman];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
    
}
- (void)AuthCardPhotoDeDelegate:(id)delegate tag:(NSInteger)tag
{
    [self.view endEditing:YES];
    btnTag = tag;
    [self.view endEditing:YES];
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

- (void)AuthCardConPhotoDeDelegate:(id)delegate tag:(NSInteger)tag
{
    [self.view endEditing:YES];
    btnTag = tag;
    [self.view endEditing:YES];
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
- (void)AuthCardPerPhotoDeDelegate:(id)delegate tag:(NSInteger)tag
{
    [self.view endEditing:YES];
    btnTag = tag;
    [self.view endEditing:YES];
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
- (void)AuthOkDelegate:(id)delegate
{
    DLog(@"%@,%@",strDate,endDate);
    NSString *msg;
    if (areaNum == 0) {
        if (StrIsEmpty(strName)){
            msg = @"请输入姓名";
            [self alertMessage:msg];
        }else if (![CNIDCheck isChineseIdNo:strCard]){
            msg = @"身份证不合法";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strDate) || StrIsEmpty(endDate)){
            msg = @"请填写身份证有效期";
            [self alertMessage:msg];
        }else if (StrIsEmpty(proStr) || StrIsEmpty(conStr) || StrIsEmpty(perStr)){
            msg = @"请上传身份证照片";
            [self alertMessage:msg];
        }else{
            [self showLoading];
            [MineAPI AuthRealname:strName idCard:strCard idPicPro:proStr idPicCon:conStr idPicPer:perStr validitySTime:strDate validityETime:endDate authArea:@"0" type:1 success:^(id model) {
                [self tableDataSourceInit];
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
        
    }else if (areaNum == 1){
        if (StrIsEmpty(strName)){
            msg = @"请输入姓名";
            [self alertMessage:msg];
        }else if (StrIsEmpty(areaStr)){
            msg = @"请选择所属地区";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strDate) || StrIsEmpty(endDate)){
            msg = @"请填写身份证有效期";
            [self alertMessage:msg];
        }else if (StrIsEmpty(proStr) || StrIsEmpty(conStr) || StrIsEmpty(perStr)){
            msg = @"请上传身份证照片";
            [self alertMessage:msg];
        }else{
            [self showLoading];
            DLog(@"%@",areaStr);
            [MineAPI AuthRealname:strName idCard:strCard idPicPro:proStr idPicCon:conStr idPicPer:perStr validitySTime:strDate validityETime:endDate authArea:areaStr type:2 success:^(id model) {
                [self tableDataSourceInit];
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
        
    }else if (areaNum == 2){
        if (StrIsEmpty(strName)){
            msg = @"请输入姓名";
            [self alertMessage:msg];
        }else if (StrIsEmpty(proStr) || StrIsEmpty(conStr) || StrIsEmpty(perStr)){
            msg = @"请上传身份证照片";
            [self alertMessage:msg];
        }else{
            [self showLoading];
            [MineAPI AuthRealname:strName idCard:strCard idPicPro:proStr idPicCon:conStr idPicPer:perStr validitySTime:strDate validityETime:endDate authArea:@"1" type:3 success:^(id model) {
               [self tableDataSourceInit];
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
        
    }
}


#pragma mark - UIImagePickerControllerdelegate
- (void)chooseImageType:(NSInteger)sourceType
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
    //imagePick.allowsEditing = YES;
    imagePick.sourceType = sourceType;
    [self presentViewController:imagePick animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self showLoading];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    [self showLoadingWithMessage:@"正在上传图片"];
    
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
        [OtherAPI UploadForAuth:imgData name:imageFileName objtype:UploadFileTypeUserCert size:CGSizeZero success:^(UploadModel *model) {
            if (btnTag == 1001) {
                AuthCardPhotoCell *cell = (AuthCardPhotoCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                
                proStr = model.file_url;
                [imgCardArr replaceObjectAtIndex:0 withObject:proStr];
                cell.imgCard.image = image;
            }else if (btnTag == 1002){
                AuthCardConPhotoCell *cell = (AuthCardConPhotoCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                conStr = model.file_url;
                [imgCardArr replaceObjectAtIndex:1 withObject:conStr];
                cell.imgCard.image = image;
            }else if (btnTag == 1003){
                AuthCardPerPhotoCell *cell = (AuthCardPerPhotoCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
                perStr = model.file_url;
                [imgCardArr replaceObjectAtIndex:2 withObject:perStr];
                cell.imgCard.image = image;
            }
            [self didLoad];
            //            [self.tableMain reloadData];
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

#pragma mark - action
- (IBAction)menuAction:(id)sender{
    [self.view endEditing:YES];
    UIButton *btn=sender;
    int tag = (int)btn.tag;
    if (tag==0) {
        areaNum = 0;
        
    }else if (tag == 1) {
        areaNum = 1;
        
    }else if (tag == 2){
        areaNum = 2;
        
    }
    [self vMainland];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableMain reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [UIView animateWithDuration:0.05*(tag+1) animations:^{
        vBlue.x=tag*menuW+kMargin;
    }];
}

- (void)alertMessage:(NSString *)message
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [self presentViewController:alt animated:YES completion:nil];
}

#pragma mark - textField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    RealNameModelDB *mm = [[RealNameModelDB alloc] init];
    mm.isEdit = [NSNumber numberWithBool:YES];
    if (areaNum == 0) {
        AuthTextFieldCell *cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        AuthTextFieldCell *cell2 = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        mm.realname = cell.txtField.text;
        mm.id_card = cell2.txtField.text;
        strName = cell.txtField.text;
        strCard = cell2.txtField.text;
        mm.auth_area = @"0";
        
        [mainlandArr replaceObjectAtIndex:0 withObject:mm.realname];
        [mainlandArr replaceObjectAtIndex:1 withObject:mm.id_card];
    }else if (areaNum == 1){
        mm.auth_area = areaStr;
//        if (areaStr == nil) {
//            mm.auth_area = @"2";
//        }
        AuthTextFieldCell *cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        AuthTextFieldCell *cell2 = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        mm.realname = cell.txtField.text;
        mm.id_card = cell2.txtField.text;
        strName = cell.txtField.text;
        strCard = cell2.txtField.text;
        mm.authH = areaHK;
        [mainlandArr replaceObjectAtIndex:0 withObject:mm.realname];
        [mainlandArr replaceObjectAtIndex:1 withObject:mm.id_card];
    }else{
        AuthTextFieldCell *cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        AuthTextFieldCell *cell2 = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        mm.realname = cell.txtField.text;
        mm.id_card = cell2.txtField.text;
        strName = cell.txtField.text;
        strCard = cell2.txtField.text;
        mm.auth_area = @"1";
        [mainlandArr replaceObjectAtIndex:0 withObject:mm.realname];
        [mainlandArr replaceObjectAtIndex:1 withObject:mm.id_card];
    }
    QGLOBAL.realNameModelDB = mm;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)makeint
{
    if (StrIsEmpty(self.realNameModel.auth_area)) {
        self.realNameModel.auth_area = @"";
    }
    if (StrIsEmpty(self.realNameModel.realname)) {
        self.realNameModel.realname = @"";
    }
    if (StrIsEmpty(self.realNameModel.id_card)) {
        self.realNameModel.id_card = @"";
    }
    if ([self.realNameModel.validity_s_time isEqualToString:@"0"] || StrIsEmpty(self.realNameModel.validity_s_time)) {
        self.realNameModel.validity_s_time = @"";
    }
    if ([self.realNameModel.validity_e_time isEqualToString:@"0"] || StrIsEmpty(self.realNameModel.validity_e_time)) {
        self.realNameModel.validity_e_time = @"";
    }
    // StrIsEmpty()
    if ([self.realNameModel.auth_area isEqualToString:@"0"]) {
        area = [NSString stringWithFormat:@"所属地区: %@",@"中国大陆"];
        
    }else if ([self.realNameModel.auth_area isEqualToString:@"1"]){
        area = [NSString stringWithFormat:@"所属地区: %@",@"台湾"];
    }else if ([self.realNameModel.auth_area isEqualToString:@"2"]){
        area = [NSString stringWithFormat:@"所属地区: %@",@"香港"];
    }else if ([self.realNameModel.auth_area isEqualToString:@"3"]){
        area = [NSString stringWithFormat:@"所属地区: %@",@"澳门"];
    }
    name = [NSString stringWithFormat:@"姓名: %@",self.realNameModel.realname];
    card = [NSString stringWithFormat:@"身份证: %@",self.realNameModel.id_card];
    
    NSString *timestart =   @"____________";
    NSString *timeend   =   @"____________";
    
    if (!StrIsEmpty(self.realNameModel.validity_s_time)) {
        timestart=[[QGLOBAL dateTimeIntervalToStr:self.realNameModel.validity_s_time] substringToIndex:10];
    }
    if (!StrIsEmpty(self.realNameModel.validity_e_time)) {
        timeend=[[QGLOBAL dateTimeIntervalToStr:self.realNameModel.validity_e_time] substringToIndex:10];
    }
    cardVal = [NSString stringWithFormat:@"证件有效期: %@ 至 %@",timestart,timeend];
    
    CGFloat tableviewH;
    
    if ([self.realNameModel.auth_area isEqualToString:@"1"]) {
        dataArr = [NSMutableArray arrayWithObjects:area,name,card, nil];
        tableviewH = (45 * 3) + 229 + (80 * kAutoScale) + 10;
    }else{
        dataArr = [NSMutableArray arrayWithObjects:area,name,card,cardVal, nil];
        tableviewH = (45 * 4) + 229 + (80 * kAutoScale) + 10;
    }
    cardImgArr = [NSMutableArray arrayWithObjects:self.realNameModel.id_pic,self.realNameModel.id_pic_2,self.realNameModel.id_pic_3, nil];
//    [self naviTitle:@"实名认证"];
    
    if ([self.realNameModel.auth_status integerValue] == 2 || [self.realNameModel.auth_status integerValue] == 1 || [self.realNameModel.auth_status integerValue] == 3) {
        tableviewH += 80;
    }
    
    if (tableviewH < APP_H - 64) {
        authStatusTbl.scrollEnabled = NO;
    }
}
- (void)popVCAction:(id)sender{
    [self jumpToPopVCAction:nil];
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
