//
//  MsgHomeVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "MsgHomeVC.h"
#import "sysMessagesVC.h"
#import "InformVC.h"
#import "MessageAPI.h"

@interface MsgHomeVC ()
{
    UILabel *lblNumS,*lblNumI;
    IBOutlet UILabel *lblSys,*lblMsgS,*lblInform,*lblMsgI,*lblDataS,*lblDataI;
    IBOutlet UIImageView *imgSys,*imgInform;
    IBOutlet UIView *vSys,*vInform;
}
@end

@implementation MsgHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)UIGlobal{
    [super UIGlobal];
    [self naviTitle:@"消息"];
    lblNumS = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 10, 10)];
    lblNumS.layer.cornerRadius = 5;
    lblNumS.layer.borderColor = RGBHex(kColorAuxiliary102).CGColor;
    lblNumS.layer.borderWidth = 0.5;
    lblNumS.clipsToBounds=YES;
    lblNumS.backgroundColor = RGBHex(kColorW);
    lblNumS.font = fontSystem(5);
    lblNumS.textColor = RGBHex(kColorAuxiliary102);
    lblNumS.textAlignment=NSTextAlignmentCenter;
    lblNumS.hidden = YES;
    [vSys addSubview:lblNumS];
    lblNumI = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 10, 10)];
    lblNumI.layer.cornerRadius = 5;
    lblNumI.layer.borderColor = RGBHex(kColorAuxiliary102).CGColor;
    lblNumI.layer.borderWidth = 0.5;
    lblNumI.clipsToBounds=YES;
    lblNumI.backgroundColor = RGBHex(kColorW);
    lblNumI.font = fontSystem(5);
    lblNumI.textColor = RGBHex(kColorAuxiliary102);
    lblNumI.textAlignment=NSTextAlignmentCenter;
    lblNumI.hidden = YES;
    [vInform addSubview:lblNumI];
    
    lblSys.font = fontSystemBold(kFontS28);
    lblSys.textColor = RGBHex(kColorGray201);
    lblInform.font = fontSystemBold(kFontS28);
    lblInform.textColor = RGBHex(kColorGray201);
    lblMsgS.text = @"欢迎登录任务大厅APP";
    lblMsgI.text = @"欢迎登录任务大厅APP";
    
    lblMsgS.textColor = RGBHex(kColorGray203);
    lblMsgI.textColor = RGBHex(kColorGray203);
    
    
    lblDataS.textColor = RGBHex(kColorGray203);
    lblDataI.textColor = RGBHex(kColorGray203);
}

#pragma mark - 获取数据
- (void)refreshList{
    [MessageAPI NewMessageType:@"system" success:^(MessageSysModel* mm) {
        
        MessageModel *sysModel = [mm.message firstObject];
        if (mm.message != nil) {
            lblNumS.hidden = NO;
            lblDataS.hidden = NO;
            if (mm.count.integerValue < 1) {
                lblNumS.hidden = YES;
            }else{
            lblNumS.text = mm.count;
            }
            lblMsgS.text = [[self filterHTML:sysModel.content] removeSpaceAndNewline];
            lblDataS.text = [QGLOBAL dateTimeIntervalToStr:sysModel.on_time];
        }else{
            lblMsgS.text = @"欢迎登录任务大厅APP";
            lblNumS.hidden = YES;
            lblDataS.hidden = YES;
        }
        
        [self didLoad];
        DLog(@"%@",sysModel);
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        [self showText:err.errMessage];
    }];
    
    [MessageAPI NewMessageType:@"appmsg" success:^(MessageInformModel* mm) {
        MessageModel *informModel = [mm.message firstObject];
        if (mm.message != nil) {
            lblNumI.hidden = NO;
            lblDataI.hidden = NO;
            
            if (mm.count.integerValue < 1) {
                lblNumI.hidden = YES;
            }else{
                lblNumI.text = mm.count;
            }
            lblMsgI.text = [[self filterHTML:informModel.content] removeSpaceAndNewline];
            lblDataI.text = [QGLOBAL dateTimeIntervalToStr:informModel.on_time];
        }else{
            lblMsgI.text = @"欢迎登录任务大厅APP";
            lblNumI.hidden = YES;
            lblDataI.hidden = YES;
        }
        
        [self didLoad];
        DLog(@"%@",informModel);
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        [self showText:err.errMessage];
    }];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [QGLOBAL.menu hideTabBar:NO];
    
    if (![QGLOBAL hadAuthToken]) {
        //如果没登录
        [self naviLeftButtonImage:[UIImage imageNamed:@"Default_avatar"] highlighted:[UIImage imageNamed:@"Default_avatar"] action:@selector(navLeftAction:)];
        vSys.hidden = YES;
        vInform.hidden = YES;
        [self showInfoViewLogin:@"您还未登录," image:@"goLogin"];
    }
    else {
        //如果登录，这里要换头像图片
        [self naviLeftButtonImage:QGLOBAL.navAvatar highlighted:QGLOBAL.navAvatar action:@selector(navLeftAction:)];
        [self removeInfoLoginView];
        vSys.hidden = NO;
        vInform.hidden = NO;
        [self showLoading];
        [self refreshList];
    }
    
    
}

#pragma mark - action
- (IBAction)navLeftAction:(id)sender{

    [QGLOBAL.mainFrame showLeftView];
}

- (IBAction)btnSysMessagesAction:(id)sender {
    sysMessagesVC *vc=(sysMessagesVC *)[QGLOBAL viewControllerName:@"sysMessagesVC" storyboardName:@"sysMessages"];
    vc.sysMessagesBlock = ^(){
        [self refreshList];
    };
    vc.hidesPopNav=YES;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}
- (IBAction)btnInformVCAction:(id)sender {
    InformVC *vc=(InformVC *)[QGLOBAL viewControllerName:@"InformVC" storyboardName:@"sysMessages"];
    vc.InformBlock = ^(){
        [self refreshList];
    };
    vc.hidesPopNav=YES;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}



#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    [super getNotifType:type data:data target:obj];
    if (type == NotifLoginSuccess){
        //login
        
        if ([QGLOBAL object:data isClass:[UIImage class]]) {
            //            AuthModel *mm=obj;
            DLog(@"$$$$$$$$$$$$$$$$$$$$$$$");
            [self viewWillAppear:NO];
            [self refreshList];
        }
        
    }
    if (type == NotifQuitOut){
        //logout

        [self viewWillAppear:NO];
        [self refreshList];
    }
}
@end
