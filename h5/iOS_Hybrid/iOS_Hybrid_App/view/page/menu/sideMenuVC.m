//
//  sideMenuVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "sideMenuVC.h"
#import "SetVC.h"
#import "sideMenuModel.h"
#import "sideMenuCell.h"
#import "loginVC.h"
#import "PersonalInfoVC.h"
#import "MyConcernVC.h"
#import "ThirdShare.h"
#import "MineAPI.h"
#import "RealNameNew.h"
#import "CompanyAuthNewVC.h"
@interface sideMenuVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *vMenu,*vHeader,*vLogin;
    IBOutlet UIButton *btnLogin,*btnTel;
    IBOutlet UILabel *lblName,*lblID;
    IBOutlet UIImageView *imgAvatar,*imgIcon,*imgEnter,*imgLv;
    NSMutableArray *arrData;
    sideMenuModel *mm1,*mm2,*mm3,*mm4,*mm5,*mm6;
}
@end

@implementation sideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self UISetting];
    [self menuInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self UISetting];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor=[UIColor clearColor];

    vMenu.backgroundColor=RGBHex(kColorMain001);
    vHeader.backgroundColor=RGBHex(kColorW);
    vLogin.backgroundColor=RGBHex(kColorW);
    
    //否则妨碍statusbar触发返回顶部
    self.tableMain.scrollsToTop=NO;
}

- (void)UISetting{
//    DLog(@"%f %f",APP_W,kAutoScale);
    CGFloat hh=(324/2)*(kAutoScale)+20;
    CGRect frm=[UIScreen mainScreen].bounds;
    self.view.frame=frm;
   
    frm.origin.y=0;
    frm.origin.x=kSideMenuShadow;
    frm.size.height=hh;
    frm.size.width-=kSideMenuShadow;
    vHeader.frame=frm;
    vLogin.frame=frm;
    
    frm.origin.y=hh;
    frm.size.height=self.view.frame.size.height-hh;
    vMenu.frame=frm;

    frm=vMenu.bounds;
    frm.size.height=15;
    frm.origin.x=0;
    frm.origin.y=vMenu.height-frm.size.height-22;
    btnTel.frame=frm;
    
    frm=vMenu.bounds;
    frm.size.height=btnTel.y;
    self.tableMain.frame=frm;
    
    [btnTel setTitle:kTelNum forState:UIControlStateNormal];
//    [btnTel setImage:[UIImage imageNamed:@"ph400"] forState:UIControlStateNormal];
    
    btnLogin.layer.cornerRadius = kBtnCornerRadius;
    
    self.tableMain.backgroundColor=[UIColor clearColor];
    [self.tableMain setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    imgIcon.frame = CGRectMake(30, (vLogin.height / 2)-(imgIcon.height/2), 55, 55);
    btnLogin.frame = CGRectMake(CGRectGetMaxX(imgIcon.frame)+20, CGRectGetMinY(imgIcon.frame), vLogin.width - 85-30-22-20, 55);
    [btnLogin setTitleColor:RGBHex(kColorB) forState:UIControlStateNormal];
    btnLogin.titleLabel.font = fontSystemBold(kFontS34);
    imgEnter.frame = CGRectMake(CGRectGetMaxX(btnLogin.frame), (vLogin.height / 2)-14, 22, 22);
    
    CGFloat width = [self getTextSizeWithString:QGLOBAL.usermodel.nickname withFontSize:17.0f];
    imgAvatar.frame = CGRectMake(30, (vHeader.height / 2)-(imgAvatar.height/2), 55, 55);
    imgAvatar.clipsToBounds = YES;
    imgAvatar.layer.cornerRadius = 55/2;
    lblName.frame = CGRectMake(CGRectGetMaxX(imgAvatar.frame)+13, CGRectGetMinY(imgAvatar.frame)+5, width+10, imgAvatar.height/2-5);
    lblName.font = fontSystemBold(kFontS34);
    lblName.textColor = RGBHex(kColorB);
    imgLv.frame = CGRectMake(CGRectGetMaxX(lblName.frame)+5, CGRectGetMinY(lblName.frame)+3, 16, 16);
    
    
    lblID.frame = CGRectMake(CGRectGetMinX(lblName.frame), CGRectGetMaxY(lblName.frame)+5, CGRectGetWidth(lblName.frame) + 100, CGRectGetHeight(lblName.frame) - 5);
    lblID.textColor = RGBHex(kColorB);
    lblID.font = fontSystem(kFontS28);
    UIButton *btnimg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnimg.frame = CGRectMake(30, (vLogin.height / 2)-(imgIcon.height/2), CGRectGetMaxX(imgEnter.frame)-30, 55);
    btnimg.backgroundColor = [UIColor clearColor];
    [vLogin addSubview:btnimg];
    [btnimg addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    imgIcon.userInteractionEnabled = YES;
    [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
    
}
- (CGFloat)getTextSizeWithString:(NSString *)text withFontSize:(CGFloat)fontSize
{
    // 计算高度,必须对宽度进行限定
    // 第三个参数字体的大小必须和label上的字体保持一致,否则计算不准确
    CGRect rect = [text boundingRectWithSize:CGSizeMake(vHeader.width-140, 22.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.width;
}

#pragma mark - menu
- (void)menuInit{
    BOOL clickEnabled=false;
    
    arrData=nil;
    arrData=[[NSMutableArray alloc]initWithCapacity:6];
    
    mm1=[sideMenuModel new];
    mm1.title=@"个人资料";
    mm1.clickEnabled=clickEnabled;
    mm1.subTitle=@"";
    mm1.subTitleEnabled=false;
    mm1.imgNormal=@"personal";
    mm1.imgDisabled=@"personal2";
    mm1.tag=SideMenuCellInfo;
    
    mm2=[sideMenuModel new];
    mm2.title=@"我的关注";
    mm2.clickEnabled=clickEnabled;
    mm2.subTitle=@"";
    mm2.subTitleEnabled=false;
    mm2.imgNormal=@"attention";
    mm2.imgDisabled=@"attention2";
    mm2.tag=SideMenuCellFavo;
    
    mm3=[sideMenuModel new];
    mm3.title=@"实名认证";
    mm3.clickEnabled=clickEnabled;
    mm3.subTitle=@"";
    mm3.subTitleEnabled=false;
    mm3.imgNormal=@"Real_name";
    mm3.imgDisabled=@"Real_name2";
    mm3.tag=SideMenuCellPerso;
    
    mm4=[sideMenuModel new];
    mm4.title=@"企业认证";
    mm4.clickEnabled=clickEnabled;
    mm4.subTitle=@"";
    mm4.subTitleEnabled=false;
    mm4.imgNormal=@"enterprise";
    mm4.imgDisabled=@"enterprise2";
    mm4.tag=SideMenuCellComp;
    
    mm5=[sideMenuModel new];
    mm5.title=@"设置";
    mm5.clickEnabled=YES;
    mm5.subTitle=@"";
    mm5.subTitleEnabled=false;
    mm5.imgNormal=@"Set_up";
    mm5.imgDisabled=@"Set_up2";
    mm5.tag=SideMenuCellSet;
    
    mm6=[sideMenuModel new];
    mm6.title=@"推荐给好友";
    mm6.clickEnabled=YES;
    mm6.subTitle=@"";
    mm6.subTitleEnabled=false;
    mm6.imgNormal=@"recommend";
    mm6.imgDisabled=@"recommend2";
    mm6.tag=SideMenuCellProp;
    QGLOBAL.usermodel = [UserModel getModelFromDB];
    if (![QGLOBAL hadAuthToken]) {
        [arrData addObject:mm1];
        [arrData addObject:mm2];
        [arrData addObject:mm3];
        [arrData addObject:mm4];
        [arrData addObject:mm5];
        [arrData addObject:mm6];
    }else{
    
    
    
    [arrData addObject:mm1];
    [arrData addObject:mm2];
        if (QGLOBAL.usermodel.enterprise_auth_status.intValue == 1) {
            
        }else{
            [arrData addObject:mm3];
        }
    [arrData addObject:mm4];
    [arrData addObject:mm5];
    [arrData addObject:mm6];
    }
    [self.tableMain reloadData];
}

- (void)menuEnabled{
    for (sideMenuModel *mm in arrData) {
        mm.clickEnabled=true;
    }
    [self.tableMain reloadData];
}

- (void)menuDisabled{
    for (sideMenuModel *mm in arrData) {
        mm.clickEnabled=false;
        if (mm.tag==SideMenuCellProp || mm.tag==SideMenuCellSet) {
            mm.clickEnabled=true;
        }
    }
    [self.tableMain reloadData];
}
#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row<arrData.count) {
        sideMenuModel * mm=[arrData objectAtIndex:row];
        
        BaseTableCell *cell;
        tableID = @"sideMenuCell";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        [cell setCell:mm];
        return cell;
    }
    return nil;
}
#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
  
    
    if (row<arrData.count){
        sideMenuModel * mm=[arrData objectAtIndex:row];
        if (mm.clickEnabled==false) {
            return;
        }
        switch (mm.tag) {
            case SideMenuCellInfo:
            {
                [self menuPersonal];
            }
                break;
            case SideMenuCellFavo:
            {
                [self menuMyConcern];
            }
                break;
            case SideMenuCellPerso:
            {
                [self menuRealNameVC];
            }
                break;
            case SideMenuCellComp:
            {
                [self menuCompany];
            }
                break;
            case SideMenuCellSet:
            {
                [self menuSetting];
            }
                break;
            case SideMenuCellProp:
            {
                [self menuProp];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -
- (void)menuSetting{
    //    [QGLOBAL.mainFrame hiddenLeftView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    SetVC *vc=(SetVC *)[QGLOBAL viewControllerName:@"SetVC" storyboardName:@"Set"];
    vc.hidesPopNav=YES;
    
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }
}
- (void)menuPersonal{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    PersonalInfoVC *vc=(PersonalInfoVC *)[QGLOBAL viewControllerName:@"PersonalInfoVC" storyboardName:@"PersonalInfo"];
    vc.hidesPopNav=YES;
    vc.delegatePopVC=self.delegatePopVC;
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }
}
- (void)menuMyConcern{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    MyConcernVC *vc=(MyConcernVC *)[QGLOBAL viewControllerName:@"MyConcernVC" storyboardName:@"MyConcern"];
    vc.hidesPopNav=YES;
    
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }
}
- (void)menuProp{
    [[ThirdShare sharedInstance] ThirdShareView:Msg_ShareRecommand name:Msg_ShareContent nav:[self.delegatePopVC navigationController] title:Msg_ShareTitle btnCopy:NO];
}

- (void)menuRealNameVC{
    //    [self showLoadingWin];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //    RealNameVC *vc=(RealNameVC *)[QGLOBAL viewControllerName:@"RealNameVC" storyboardName:@"RealName"];
    //    RealNameNewVC *vc=(RealNameNewVC *)[QGLOBAL viewControllerName:@"RealNameNewVC" storyboardName:@"RealNameNewVC"];
    RealNameNew *vc = [[RealNameNew alloc] initWithNibName:@"RealNameNew" bundle:nil];
    vc.delegatePopVC=self.delegatePopVC;
    vc.hidesPopNav=YES;
    
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }
    
    
    
    //    [MineAPI RealNAmeQuerysuccess:^(RealNameModel *model) {
    //        if ([model.auth_status integerValue] == 0) {
    //
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //            AuthStatusNewVC *vc=(AuthStatusNewVC *)[QGLOBAL viewControllerName:@"AuthStatusNewVC" storyboardName:@"RealNameNewVC"];
    //            vc.hidesPopNav=YES;
    //            vc.delegatePopVC=self.delegatePopVC;
    //            vc.realNameModel = model;
    //            if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //            }
    //        }else{
    //
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //            AuthStatusNewVC *vc=(AuthStatusNewVC *)[QGLOBAL viewControllerName:@"AuthStatusNewVC" storyboardName:@"RealNameNewVC"];
    //            vc.hidesPopNav=YES;
    //            vc.delegatePopVC=self.delegatePopVC;
    //            vc.realNameModel = model;
    //            if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //            }
    //        }
    //        [self didLoad];
    //    } failure:^(NetError *err) {
    //        [self didLoad];
    //        if (err.errStatusCode == 13862) {
    //                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    //                RealNameVC *vc=(RealNameVC *)[QGLOBAL viewControllerName:@"RealNameVC" storyboardName:@"RealName"];
    //                vc.delegatePopVC=self.delegatePopVC;
    ////            RealNameNewVC *vc=(RealNameNewVC *)[QGLOBAL viewControllerName:@"RealNameNewVC" storyboardName:@"RealNameNewVC"];
    //                vc.hidesPopNav=YES;
    //
    //                if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                    [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                    [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //                }
    //        }else{
    //        [self showWindowText:err.errMessage delay:1.2];
    //        }
    //        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    //    }];
}
- (void)menuCompany
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    CompanyAuthNewVC *vc=[[CompanyAuthNewVC alloc] initWithNibName:@"CompanyAuthNewVC" bundle:nil];
    vc.hidesPopNav=YES;
    vc.delegatePopVC=self.delegatePopVC;
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }
    
    //    [self showLoadingWin];
    //    [MineAPI CompanyAuthQuerysuccess:^(CompanyAuthModel *model) {
    //        if ([model.auth_status integerValue] == 0){
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    ////            CompanyAuthStatusVC *vc=(CompanyAuthStatusVC *)[QGLOBAL viewControllerName:@"CompanyAuthStatusVC" storyboardName:@"RealName"];
    //            AuthStatusCompanyNewVC *vc=(AuthStatusCompanyNewVC *)[QGLOBAL viewControllerName:@"AuthStatusCompanyNewVC" storyboardName:@"RealNameNewVC"];
    //            vc.hidesPopNav=YES;
    //            vc.delegatePopVC=self.delegatePopVC;
    //            vc.companyAuthModel = model;
    //            if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //            }
    //        }else{
    //
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    ////            CompanyAuthStatusVC *vc=(CompanyAuthStatusVC *)[QGLOBAL viewControllerName:@"CompanyAuthStatusVC" storyboardName:@"RealName"];
    //            AuthStatusCompanyNewVC *vc=(AuthStatusCompanyNewVC *)[QGLOBAL viewControllerName:@"AuthStatusCompanyNewVC" storyboardName:@"RealNameNewVC"];
    //            vc.hidesPopNav=YES;
    //            vc.delegatePopVC=self.delegatePopVC;
    //            DLog(@"%@",model);
    //            vc.companyAuthModel = model;
    //            if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //            }
    //        }
    //        [self didLoad];
    //    } failure:^(NetError *err) {
    //        [self didLoad];
    //        if (err.errStatusCode == 13862) {
    //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    //            companyAuthVC *vc=(companyAuthVC *)[QGLOBAL viewControllerName:@"companyAuthVC" storyboardName:@"RealName"];
    //            vc.hidesPopNav=YES;
    //            vc.delegatePopVC=self.delegatePopVC;
    //            if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
    //
    //                [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
    //                [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    //            }
    //        }else{
    //            [self showWindowText:err.errMessage delay:1.2];
    //        }
    //        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    //    }];
}
#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [sideMenuCell getCellHeight:nil];
}

#pragma mark - action
- (void)btnLoginAction
{
    [self loginAction:nil];
}
- (IBAction)loginAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
    vc.hidesPopNav=YES;
    vc.delegatePopVC=self.delegatePopVC;
    if (self.delegatePopVC && [self.delegatePopVC navigationController]) {
        
        [[self.delegatePopVC navigationController] setNavigationBarHidden:NO animated:NO];
        [[self.delegatePopVC navigationController] pushViewController:vc animated:YES];
    }

}

- (IBAction)telAction:(id)sender{
    NSString *ttl=[NSString stringWithFormat:@"是否拨打 %@?",kTelNum];
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ttl preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",kTelNum];
        if (str != nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alt addAction:can];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}

#pragma mark - user
- (void)setUserInfo:(id)obj{
    
    if (obj == nil) {
        //登出
        vHeader.hidden=YES;
        vLogin.hidden=NO;
        
        
        QGLOBAL.navAvatar=nil;
        [QGLOBAL postNotif:NotifQuitOut data:nil object:nil];
        
        [self menuInit];
        
    }else{
        NSString *avatar,*nickname,*username;
        if ([obj isKindOfClass:[AuthModel class]]) {
            AuthModel*model=obj;
            avatar=model.avatar;
            nickname=model.nickname;
            username=model.username;
            DLog(@"+++++++++ AuthModel头像地址:\n%@\n\n",avatar);
        }
        if ([obj isKindOfClass:[UserModel class]]) {
            UserModel*model=obj;
            avatar=model.avatar;
            nickname=model.nickname;
            username=model.username;
            DLog(@"+++++++++ UserModel头像地址:\n%@\n\n",avatar);
        }
        [self menuInit];
        
        //登录成功
        SyncBegin
        vHeader.hidden=NO;
        vLogin.hidden=YES;

        
        [imgAvatar setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error==nil && image) {
                //获取头像,刷新导航栏头像
                UIImage* newImg=[image imageByScalingAndCroppingForSize:CGSizeMake(240, 240)];
                QGLOBAL.navAvatar=[UIImage createRoundedRectImage:newImg radius:newImg.size.height/2];;
                [QGLOBAL postNotif:NotifLoginSuccess data:QGLOBAL.navAvatar object:obj];
            }
        }];
        CGFloat width = [self getTextSizeWithString:nickname withFontSize:17.0f];
        lblName.frame = CGRectMake(CGRectGetMaxX(imgAvatar.frame)+13, CGRectGetMinY(imgAvatar.frame)+5, width+10, imgAvatar.height/2-5);
        imgLv.frame = CGRectMake(CGRectGetMaxX(lblName.frame)+5, CGRectGetMinY(lblName.frame)+3, 16, 16);
        lblName.text = nickname;
        lblID.text = [NSString stringWithFormat:@"ID:%@",username];
//        [self.tableMain reloadData];
        
        
        QGLOBAL.usermodel = [UserModel getModelFromDB];
        if (QGLOBAL.usermodel.realname_auth_status.intValue == 1 && QGLOBAL.usermodel.enterprise_auth_status.intValue != 1) {
            imgLv.image = [UIImage imageNamed:@"Real_name2"];
        }else if (QGLOBAL.usermodel.realname_auth_status.intValue != 1 && QGLOBAL.usermodel.enterprise_auth_status.intValue == 1){
            imgLv.image = [UIImage imageNamed:@"enterprise2"];
        }else if (QGLOBAL.usermodel.realname_auth_status.intValue == 1 && QGLOBAL.usermodel.enterprise_auth_status.intValue == 1){
            imgLv.image = [UIImage imageNamed:@"enterprise2"];
        }else if (QGLOBAL.usermodel.realname_auth_status.intValue != 1 && QGLOBAL.usermodel.enterprise_auth_status.intValue != 1){
            imgLv.hidden = YES;
        }
        
        
        [self menuEnabled];
        SyncEnd
        
        
    }
}

//全局更换头像
- (void)updateAvatar:(UIImage*)avatar{
    if (avatar==nil) {
        return;
    }
    imgAvatar.image=avatar;
    //获取头像,刷新导航栏头像
    UIImage* newImg=[avatar imageByScalingAndCroppingForSize:CGSizeMake(240, 240)];
    QGLOBAL.navAvatar=[UIImage createRoundedRectImage:newImg radius:newImg.size.height/2];;
    [QGLOBAL postNotif:NotifLoginSuccess data:QGLOBAL.navAvatar object:nil];
}
@end
