//
//  CompanyAuthNewVC.m
//  cyy_task
//
//  Created by zhchen on 16/10/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CompanyAuthNewVC.h"
#import "ASBirthSelectSheet.h"
#import "MineAPI.h"
#import "CityListVC.h"
#import "AuthTextFieldCell.h"
#import "AuthCardPhotoCell.h"
#import "CityListVC.h"
#import "AuthCompanyStatusDataSource.h"
static CGFloat kMargin = 6;
@interface CompanyAuthNewVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,cloudBaseCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITableView *companyStatusTbl;
    IBOutlet UIView *vCompanAuth,*vAuthStatus;
    NSInteger areaNum;
    NSMutableArray *mainlandArr,*imgCardArr,*dateArr;
    UIView *vRealMenu,*vBlue;
    CGFloat menuW;
    NSString *strDate,*endDate,*areaStr,*areaHK,*strCompany,*strLegal,*strLicnum,*strTurnover,*strAddress,*strCity,*strValidity,*strDateF,*endDateF,*strBtnStart,*strBtnEnd;
    NSString *strP,*strC,*strS,*photoPer;
    BOOL istypeVc,isDate;
    UILabel *lblPlaceT;
    AuthCompanyStatusDataSource *companyTbl;
    NSMutableArray *dataArr,*cardImgArr;
}
@end

@implementation CompanyAuthNewVC

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
        imgCardArr = [NSMutableArray arrayWithObjects:@"license", nil];
        [self vMainland];
        istypeVc = YES;
        vCompanAuth.frame = CGRectMake(0, 0, APP_W, APP_H);
        [self.view addSubview:vCompanAuth];
        [self.view bringSubviewToFront:vCompanAuth];
        [self.tableMain reloadData];
    }else{
    [MineAPI CompanyAuthQuerysuccess:^(CompanyAuthModel *model) {
        istypeVc = NO;
        self.companyAuthModel = model;
        companyTbl = [[AuthCompanyStatusDataSource alloc] init];
        companyTbl.delegate = self;
        companyStatusTbl.dataSource = companyTbl;
        companyStatusTbl.delegate = companyTbl;
        [self makeint];
        companyTbl.companyAuthModel = model;
        companyTbl.dataArr = dataArr;
        companyTbl.cardImgArr = cardImgArr;
        
        companyTbl.delegatePopVC = self.delegatePopVC;
        companyTbl.delegateNav = [QGLOBAL.mainFrame navigationController];
        vAuthStatus.frame = CGRectMake(0, 0,APP_W,APP_H);
        companyStatusTbl.backgroundColor = RGBHex(kColorGray207);
        [self.view addSubview:vAuthStatus];
        [self.view bringSubviewToFront:vAuthStatus];
        [companyStatusTbl setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
        [companyStatusTbl  setSeparatorColor:[UIColor clearColor]];
        [self didLoad];
    } failure:^(NetError *err) {
        [self didLoad];
        imgCardArr = [NSMutableArray arrayWithObjects:@"license", nil];
        [self vMainland];
        istypeVc = YES;
        vCompanAuth.frame = CGRectMake(0, 0, APP_W, APP_H);
        [self.view addSubview:vCompanAuth];
        [self.view bringSubviewToFront:vCompanAuth];
        [self.tableMain reloadData];
    }];
    }
}
- (void)makeint
{
    NSString *company,*legal,*licen_num,*turnover,*licen_address,*cardVal;
    if (StrIsEmpty(self.companyAuthModel.legal)) {
        self.companyAuthModel.legal = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.company)) {
        self.companyAuthModel.company = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.licen_num)) {
        self.companyAuthModel.licen_num = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.residency)) {
        self.companyAuthModel.residency = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.turnover)) {
        self.companyAuthModel.turnover = @"";
    }
    
    if (StrIsEmpty(self.companyAuthModel.area_prov)) {
        self.companyAuthModel.area_prov = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.area_city)) {
        self.companyAuthModel.area_city = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.area_dist)) {
        self.companyAuthModel.area_dist = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.ent_start_time)) {
        self.companyAuthModel.ent_start_time = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.ent_end_time)) {
        self.companyAuthModel.ent_end_time = @"";
    }
    if (StrIsEmpty(self.companyAuthModel.licen_address)) {
        self.companyAuthModel.licen_address = @"";
    }
    legal = [NSString stringWithFormat:@"企业法人: %@",self.companyAuthModel.legal];
    if ([self.companyAuthModel.area_prov isEqualToString:@""]) {
        licen_address = [NSString stringWithFormat:@"注册地址: %@%@%@%@",self.companyAuthModel.area_prov,self.companyAuthModel.area_city,self.companyAuthModel.area_dist,self.companyAuthModel.licen_address];
    }else{
        licen_address = [NSString stringWithFormat:@"注册地址: %@省%@%@%@",self.companyAuthModel.area_prov,self.companyAuthModel.area_city,self.companyAuthModel.area_dist,self.companyAuthModel.licen_address];
    }
    
    
    NSString *timestart =   @"____________";
    NSString *timeend   =   @"____________";
    
    if (!StrIsEmpty(self.companyAuthModel.ent_start_time)) {
        timestart=[[QGLOBAL dateTimeIntervalToStr:self.companyAuthModel.ent_start_time] substringToIndex:10];
    }
    if (!StrIsEmpty(self.companyAuthModel.ent_end_time)) {
        timeend=[[QGLOBAL dateTimeIntervalToStr:self.companyAuthModel.ent_end_time] substringToIndex:10];
    }
    if ([self.companyAuthModel.ent_end_time isEqualToString:@"1"]) {
        cardVal = [NSString stringWithFormat:@"证件有效期: 长期"];
    }else{
        cardVal = [NSString stringWithFormat:@"证件有效期: %@ 至 %@",timestart,timeend];
    }
    
    company = [NSString stringWithFormat:@"企业名称: %@",self.companyAuthModel.company];
    licen_num = [NSString stringWithFormat:@"注册号: %@",self.companyAuthModel.licen_num];
    turnover = [NSString stringWithFormat:@"主营范围: %@",self.companyAuthModel.turnover];
    
    CGFloat tableviewH;
    CGFloat lblH = [self getTextHeightWithString:turnover withFontSize:14.0f]+5;
    if (lblH <= 45) {
        lblH = 45;
    }
    if ([self.companyAuthModel.auth_area isEqualToString:@"0"]) {
        dataArr = [NSMutableArray arrayWithObjects:company,legal,licen_num,turnover,licen_address,cardVal, nil];
        tableviewH = (5 * 45)+ lblH + 229 + (150 * kAutoScale) + 10;
    }else if ([self.companyAuthModel.auth_area isEqualToString:@"2"] || [self.companyAuthModel.auth_area isEqualToString:@"3"]){
        dataArr = [NSMutableArray arrayWithObjects:company,licen_num,turnover, nil];
        tableviewH = (2 * 45)+ lblH + 229 + (150 * kAutoScale) + 10;
    }else if ([self.companyAuthModel.auth_area isEqualToString:@"1"]){
        dataArr = [NSMutableArray arrayWithObjects:company,legal,licen_num,turnover,licen_address, nil];
        tableviewH = (4 * 45)+ lblH + 229 + (150 * kAutoScale) + 10;
    }
    cardImgArr = [NSMutableArray arrayWithObjects:self.companyAuthModel.licen_pic, nil];
    [self naviTitle:@"企业认证"];
    if ([self.companyAuthModel.auth_status integerValue] == 2 ||  [self.companyAuthModel.auth_status integerValue] == 3) {
        tableviewH += 80;
    }
    
    if (tableviewH < APP_H - 64) {
        companyStatusTbl.scrollEnabled = NO;
    }
}
- (void)UIGlobal
{
    [super UIGlobal];
}
- (void)vMainland
{
    if (areaNum == 1) {
        mainlandArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    }else if(areaNum == 0){
        mainlandArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }else if(areaNum == 2){
        mainlandArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
    strCity = @"请选择企业注册所在地";
    if (!isDate) {
        strValidity = @"请选择有效期限";
    }
    
    strBtnStart = @"";
    strBtnEnd = @"";
    dateArr = [NSMutableArray arrayWithObjects:strBtnStart,strBtnEnd, nil];
    
    [self naviTitle:@"企业认证"];
    CompanyAuthModelDB *ModelDB = [CompanyAuthModelDB getModelFromDB];
    
    if (ModelDB.isEdit.boolValue==YES) {
        areaStr = ModelDB.auth_area;
        if (StrIsEmpty(ModelDB.company)) {
            ModelDB.company = @"";
        }
        if (StrIsEmpty(ModelDB.legal)) {
            ModelDB.legal = @"";
        }
        if (StrIsEmpty(ModelDB.licen_num)) {
            ModelDB.licen_num = @"";
        }
        if (StrIsEmpty(ModelDB.turnover)) {
            ModelDB.turnover = @"";
        }
        if (StrIsEmpty(ModelDB.ent_start_time)) {
            ModelDB.ent_start_time = @"";
        }
        if (StrIsEmpty(ModelDB.ent_end_time)) {
            ModelDB.ent_end_time = @"";
        }
        strCompany = ModelDB.company;
        strLegal = ModelDB.legal;
        strLicnum = ModelDB.licen_num;
        strTurnover = ModelDB.turnover;
        strAddress = ModelDB.address;
        if (areaNum == 0) {
            strDate = ModelDB.s_time;
            endDate = ModelDB.e_time;
            mainlandArr = [NSMutableArray arrayWithObjects:ModelDB.company,ModelDB.legal,ModelDB.licen_num,ModelDB.turnover, nil];
            [dateArr replaceObjectAtIndex:0 withObject:ModelDB.ent_start_time];
            [dateArr replaceObjectAtIndex:1 withObject:ModelDB.ent_end_time];
        }else if (areaNum == 1){
            mainlandArr = [NSMutableArray arrayWithObjects:ModelDB.company,ModelDB.licen_num,ModelDB.turnover, nil];
        }else if (areaNum == 2){
            mainlandArr = [NSMutableArray arrayWithObjects:ModelDB.company,ModelDB.legal,ModelDB.licen_num,ModelDB.turnover, nil];
        }
    }
//    [self.tableMain reloadData];
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
            if (isDate) {
                return mainlandArr.count+5;
            }
            return mainlandArr.count+4;
        }else{
            return 3;
        }
        
    }else if (areaNum == 1){
        if (section == 0) {
            return mainlandArr.count+2;
        }else{
            return 3;
        }
        
    }else{
        if (section == 0) {
            return mainlandArr.count+3;
        }else{
            return 3;
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
                }else if (indexPath.row == 5) {
                    tableID = @"CompanyRegisterCell";
                }else if (indexPath.row == 6){
                    tableID = @"CompanyTextViewCell";
                }else if (indexPath.row == 7){
                    tableID = @"CompanySelectDateCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
                if (isDate) {
                    if (indexPath.row == 8) {
                        tableID = @"AuthCardCell";
                    }
                    
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 2){
                    tableID = @"AuthOkCell";
                }
            }
        }else if (areaNum == 1){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 1) {
                    tableID = @"AuthSeleteAreaCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
            }else{
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 2){
                    tableID = @"AuthOkCell";
                }
            }
        }else if (areaNum == 2){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    tableID = @"AuthKongCell";
                }else if (indexPath.row == 5) {
                    tableID = @"CompanyRegisterCell";
                }else if (indexPath.row == 6){
                    tableID = @"CompanyTextViewCell";
                }else{
                    tableID = @"AuthTextFieldCell";
                }
            }else{
                if (indexPath.row == 0) {
                    tableID = @"AuthSysCell";
                }else if (indexPath.row == 1){
                    tableID = @"AuthCardPhotoCell";
                }else if (indexPath.row == 2){
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
                if (indexPath.row>0 && indexPath.row < 5) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入企业名称",@"请输入企业法人姓名",@"请输入企业注册号码",@"请输入企业经营范围", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 1];
                    [cell setCell:mainlandArr[indexPath.row-1]];
                }else if (indexPath.row==5){
                    [cell setCell:strCity];
                }else if (indexPath.row == 6){
                    cell.txtView.delegate = self;
                    if (lblPlaceT == nil) {
                        
                        lblPlaceT = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 30)];
                        lblPlaceT.font = fontSystem(kFontS28);
                        lblPlaceT.textColor = RGBHex(kColorGray211);
                        lblPlaceT.text = @"请填写企业详细注册地址";
                        lblPlaceT.backgroundColor=[UIColor clearColor];
                        
                        DLog(@"%@",strAddress);
                        
                    }
                    [cell.txtView addSubview:lblPlaceT];
                    [cell setCell:strAddress];
                }else if (indexPath.row == 7){
                    [cell setCell:strValidity];
                }else{
                    [cell setCell:nil];
                }
                if (isDate) {
                    if (indexPath.row == 8) {
                        [cell setCell:dateArr];
                    }
                    
                }
            }else if (areaNum == 1){
                if (indexPath.row>1 && indexPath.row < 5) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入企业名称",@"请输入企业注册号码",@"请输入企业经营范围", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 2];
                    [cell setCell:mainlandArr[indexPath.row-2]];
                }else if (indexPath.row == 1){
                    if (StrIsEmpty(areaHK)) {
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
                if (indexPath.row>0 && indexPath.row < 5) {
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:@"请输入企业名称",@"请输入企业法人姓名",@"请输入企业注册号码",@"请输入企业经营范围", nil];
                    cell.txtField.delegate = self;
                    cell.txtField.placeholder = arr[indexPath.row - 1];
                    [cell setCell:mainlandArr[indexPath.row-1]];
                }else if (indexPath.row==5){
                    [cell setCell:strCity];
                }else if (indexPath.row == 6){
                    cell.txtView.delegate = self;
                    [cell.txtView addSubview:lblPlaceT];
                    [cell setCell:strAddress];
                }else{
                    [cell setCell:nil];
                }
            }
        }else{
            cell.separatorHidden = YES;
            if (indexPath.row > 0) {
                if (indexPath.row == 1) {
                    [cell setCell:imgCardArr[indexPath.row - 1]];
                }else{
                    [cell setCell:nil];
                }
            }else{
                [cell setCell:nil];
            }
            
        }
        if (StrIsEmpty(strAddress)) {
            lblPlaceT.hidden = NO;
        }else{
            lblPlaceT.hidden = YES;
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
        if (areaNum != 1) {
            if (indexPath.row == 6) {
                return 90;
            }
        }
        return 45;
    }else{
        if (indexPath.row == 0) {
            return 45;
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
        CompanyAuthModelDB *mm = [CompanyAuthModelDB getModelFromDB];
        mm.s_time = strDate;
        mm.ent_start_time = strDateF;
        QGLOBAL.companyAuthModelDB = mm;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
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
        CompanyAuthModelDB *mm = [CompanyAuthModelDB getModelFromDB];
        mm.e_time = endDate;
        mm.ent_end_time = endDateF;
        QGLOBAL.companyAuthModelDB = mm;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
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
- (void)AuthStatusSelectCityDelegate:(id)delegate
{
    [self.view endEditing:YES];
    CityListVC *vc=(CityListVC *)[QGLOBAL viewControllerName:@"CityListVC" storyboardName:@"CityListVC"];
    vc.cityListBlock = ^(NSString *prov, NSString*city, NSString*dist){
        strP = prov;
        strC = city;
        strS = dist;
        if ([strC isEqualToString:@""]) {
            strCity = [NSString stringWithFormat:@"%@",strP];
        }else if ([strS isEqualToString:@""] && ![strC isEqualToString:@""]){
            strCity = [NSString stringWithFormat:@"%@,%@",strP,strC];
        }else{
            strCity = [NSString stringWithFormat:@"%@,%@,%@",strP,strC,strS];
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)AuthCompanySelectDateDelegate:(id)delegate
{
    
    [self.view endEditing:YES];
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *man = [UIAlertAction actionWithTitle:@"短期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strValidity = @"短期";
        isDate = YES;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:8 inSection:0];
        
        [self.tableMain insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction *woman = [UIAlertAction actionWithTitle:@"长期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        isDate = NO;
        
        if ([strValidity isEqualToString:@"短期"]) {
            NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:8 inSection:0];
            [self.tableMain deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        strValidity = @"长期";
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alt addAction:man];
    [alt addAction:woman];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}
- (void)AuthOkDelegate:(id)delegate
{
    NSString *msg;
    if (areaNum == 0) {
        if (StrIsEmpty(strCompany)) {
            msg = @"请输入企业名称";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strLegal)){
            msg = @"请输入企业法人姓名";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strLicnum)){
            msg = @"请输入企业注册号码";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strTurnover)){
            msg = @"请输入企业经营范围";
            [self alertMessage:msg];
        }else if ([strCity isEqualToString:@"请选择企业注册所在地"]){
            msg = @"请选择注册所在地";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strAddress)){
            msg = @"请填写详细注册地址";
            [self alertMessage:msg];
        }else if ([strValidity isEqualToString:@"请选择有效期限"]){
            msg = @"请选择有效期限";
            [self alertMessage:msg];
        }else if (StrIsEmpty(photoPer)){
            msg = @"请上传营业执照";
            [self alertMessage:msg];
        }else{
            if ([strValidity isEqualToString:@"长期"]) {
                endDate = @"1";
            }
            [self showLoading];
            areaStr = @"0";
            [MineAPI AuthCompanyCreateCompany:strCompany licenNum:strLicnum licenpic:photoPer legal:strLegal turnover:strTurnover startTime:strDate endTime:endDate areaprov:strP areacity:strC areadist:strS address:strAddress autharea:areaStr type:1 success:^(id model) {
                
                [self tableDataSourceInit];
                [self didLoad];
                
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
        
    }else if (areaNum == 1){
        if (StrIsEmpty(strCompany)) {
            msg = @"请输入企业名称";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strLicnum)){
            msg = @"请输入企业注册号码";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strTurnover)){
            msg = @"请输入企业经营范围";
            [self alertMessage:msg];
        }else if (StrIsEmpty(areaHK)){
            msg = @"请选择所属地区";
            [self alertMessage:msg];
        }else if (StrIsEmpty(photoPer)){
            msg = @"请上传营业执照";
            [self alertMessage:msg];
        }else{
            [self showLoading];
            [MineAPI AuthCompanyCreateCompany:strCompany licenNum:strLicnum licenpic:photoPer legal:nil turnover:strTurnover startTime:strDate endTime:endDate areaprov:strP areacity:strC areadist:strS address:nil autharea:areaStr type:3 success:^(id model) {
                [self tableDataSourceInit];
                [self didLoad];
            } failure:^(NetError *err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
            }];
        }
    }else if (areaNum == 2){
        areaStr = @"1";
        if (StrIsEmpty(strCompany)) {
            msg = @"请输入企业名称";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strLegal)){
            msg = @"请输入企业法人姓名";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strLicnum)){
            msg = @"请输入企业注册号码";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strTurnover)){
            msg = @"请输入企业经营范围";
            [self alertMessage:msg];
        }else if ([strCity isEqualToString:@"请选择企业注册所在地"]){
            msg = @"请选择注册所在地";
            [self alertMessage:msg];
        }else if (StrIsEmpty(strAddress)){
            msg = @"请填写详细注册地址";
            [self alertMessage:msg];
        }else if (StrIsEmpty(photoPer)){
            msg = @"请上传营业执照";
            [self alertMessage:msg];
        }else{
            [self showLoading];
            [MineAPI AuthCompanyCreateCompany:strCompany licenNum:strLicnum licenpic:photoPer legal:strLegal turnover:strTurnover startTime:strDate endTime:endDate areaprov:strP areacity:strC areadist:strS address:strAddress autharea:areaStr type:2 success:^(id model) {
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
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self showLoading];
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
                AuthCardPhotoCell *cell = (AuthCardPhotoCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                photoPer = model.file_url;
                [imgCardArr replaceObjectAtIndex:0 withObject:photoPer];
                cell.imgCard.image = image;
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
- (CGFloat)getTextHeightWithString:(NSString *)text withFontSize:(CGFloat)fontSize
{
    // 计算高度,必须对宽度进行限定
    // 第三个参数字体的大小必须和label上的字体保持一致,否则计算不准确
    CGRect rect = [text boundingRectWithSize:CGSizeMake(APP_W - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}
#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        lblPlaceT.hidden = NO;
    }
    else{
        lblPlaceT.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CompanyAuthModelDB *mm = [CompanyAuthModelDB getModelFromDB];
    mm.address = textView.text;
    QGLOBAL.companyAuthModelDB = mm;
    strAddress = textView.text;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CompanyAuthModelDB *mm = [[CompanyAuthModelDB alloc] init];
    mm.isEdit = [NSNumber numberWithBool:YES];
    AuthTextFieldCell *cell;
    if (areaNum == 0) {
        for (int i = 1; i < 5; i ++) {
            cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i == 1) {
                mm.company = cell.txtField.text;
                strCompany = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:0 withObject:mm.company];
            }else if (i == 2){
                mm.legal = cell.txtField.text;
                strLegal = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:1 withObject:mm.legal];
            }else if (i == 3){
                mm.licen_num = cell.txtField.text;
                strLicnum = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:2 withObject:mm.licen_num];
            }else if (i == 4){
                mm.turnover = cell.txtField.text;
                strTurnover = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:3 withObject:mm.turnover];
            }
        }
        mm.auth_area = @"0";
        mm.area_city = strCity;
    }else if (areaNum == 1){
        
        mm.auth_area = areaStr;
        for (int i = 2; i < 5; i ++) {
            cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i == 2) {
                mm.company = cell.txtField.text;
                 strCompany = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:0 withObject:mm.company];
            }else if (i == 3){
                mm.licen_num = cell.txtField.text;
                strLicnum = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:1 withObject:mm.licen_num];
            }else if (i == 4){
                mm.turnover = cell.txtField.text;
                strTurnover = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:2 withObject:mm.turnover];
            }
        }
        if ([areaStr isEqualToString:@"2"]) {
            mm.authH = @"香港";
        }else{
            mm.authH = @"澳门";
        }
    }else{
        mm.auth_area = @"1";
        for (int i = 1; i < 5; i ++) {
            cell = (AuthTextFieldCell *)[self.tableMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i == 1) {
                mm.company = cell.txtField.text;
                strCompany = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:0 withObject:mm.company];
            }else if (i == 2){
                mm.legal = cell.txtField.text;
                strLegal = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:1 withObject:mm.legal];
            }else if (i == 3){
                mm.licen_num = cell.txtField.text;
                strLicnum = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:2 withObject:mm.licen_num];
            }else if (i == 4){
                mm.turnover = cell.txtField.text;
                strTurnover = cell.txtField.text;
                [mainlandArr replaceObjectAtIndex:3 withObject:mm.turnover];
            }
        }
        mm.area_city = strCity;
    }
    QGLOBAL.companyAuthModelDB = mm;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"请输入企业经营范围"]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableMain.contentOffset = CGPointMake(0, 100);
        }];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
    }
    return YES;
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
