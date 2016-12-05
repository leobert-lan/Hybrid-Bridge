//
//  TaskMgrCell.m
//  cyy_task
//
//  Created by Qingyang on 16/7/20.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskMgrCell.h"

@implementation TaskMgrCell

+ (float)getCellHeight:(TaskModel*)model{
    if (model.operate.count==0) {
        return 80;
    }
    return 118;
}
- (void)UIGlobal{
    [super UIGlobal];
    
    if (_myTaskEnabled && taskMd.operate.count==0) {
        
        vBG.backgroundColor=[UIColor clearColor];
        vBtns.backgroundColor=[UIColor clearColor];
        
//        self.separatorLine.backgroundColor = RGBHex(kColorAuxiliary101);
    }
}

- (void)setCell:(TaskModel*)model{
    [super setCell:model];
    

    if (_myTaskEnabled) {
        [self checkOperate:model];
    }
}
/*
1 再次投稿
2 等待雇主选稿
3 联系TA
4 签署协议
5 等待对方签署协议
6 上传源文件
7 等待对方确认
8 重新上传
9 等待签署协议
10 等待对方托管资金
11 等待托管下期资金
12 去评价
13 投稿
14 选择中标稿件（请至电脑上选择中标稿件）
15 验收稿件（请至电脑上验收稿件）
16 去支付
*/
- (void)checkOperate:(TaskModel*)mm{
    taskMd=mm;
//    step 	Number 需求所处阶段
//    model 	Number 需求类型（1=>悬赏，2=>招标，3=>雇佣）
    //阶段（1=>发布，2=>投稿，3=>选稿，4=>公示，5=>制作，6=>结束）
    
//    if (taskMd.operate.count==0) {
//        
//        vBG.backgroundColor=[UIColor clearColor];
//        vBtns.backgroundColor=[UIColor clearColor];
//        
//        return;
//    }
    
    for (id obj in mm.operate) {
//        DLog(@">>> operate: %@ %@",obj,[obj class]);
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            
            int num=[obj intValue];
//            num=3;
            switch (num) {
                case 1:
                {
                    btnClick.hidden=NO;
                    btnClick.tag=num;
                    [btnClick setTitle:@"再次投稿" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待雇主选稿";
                }
                    break;
                case 3:
                {
                    btnClick.hidden=NO;
                    btnClick.tag=num;
                    [btnClick setTitle:@"联系TA" forState:UIControlStateNormal];
                }
                    break;
                case 4://签署协议
                {
                    btnClick.hidden=NO;
                    btnClick.tag=num;
                    [btnClick setTitle:@"签署协议" forState:UIControlStateNormal];
                }
                    break;
                case 5:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待对方签署协议";
                }
                    break;
                case 6://上传源文件
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"上传源文件";
                }
                    break;
                case 7:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待对方确认";
                }
                    break;
                case 8://重新上传
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"重新上传";
                }
                    break;
                case 9:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待签署协议";
                }
                    break;
                case 10:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待对方托管资金";
                }
                    break;
                case 11:// 等待托管下期资金
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"等待托管下期资金";
                }
                    break;
                case 12:
                {
                    btnClick.hidden=NO;
                    btnClick.tag=num;
                    [btnClick setTitle:@"去评价" forState:UIControlStateNormal];
                }
                    break;
                    /////以下应该微站数据
                case 13://投稿
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"投稿";
                }
                    break;
                case 14:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"选择中标稿件（请至电脑上选择中标稿件）";
                }
                    break;
                case 15:
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"验收稿件（请至电脑上验收稿件）";
                }
                    break;
                case 16://去支付
                {
                    lblInfo.hidden=NO;
                    lblInfo.text=@"去支付";
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}


- (IBAction)btnClickAction:(id)sender{
    UIButton *btn=sender;
    DLog(@"%@ %li",self.delegateNav,btn.tag);
    if (self.delegateNav==nil) {
        return;
    }
    
//    UIViewController *vv;
    switch (btn.tag) {
        case 1://再次投稿
        {
            SubmissionVC *vc = [[SubmissionVC alloc] initWithNibName:@"SubmissionVC" bundle:nil];
            vc.taskBn = taskMd.task_bn;
            if ([taskMd.is_mark intValue] == 1) {
                vc.isMArk = @"1";
            }else if ([taskMd.is_mark intValue] == 2){
                vc.isMArk = @"2";
            }else if ([taskMd.model intValue] == 1){
                vc.isMArk = @"3";
            }
            
            vc.hidesPopNav=self.hidesPopNav;
            [self.delegateNav setNavigationBarHidden:NO animated:NO];
            [self.delegateNav pushViewController:vc animated:NO];
        }
            break;
        case 3://联系TA
        {
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"是否拨打 %@?",taskMd.mobile] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *can = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *str = [NSString stringWithFormat:@"tel:%@",taskMd.mobile];
                if (str != nil) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
                }
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alt addAction:can];
            [alt addAction:cancel];
            [self.delegateNav presentViewController:alt animated:YES completion:nil];
        }
            break;
        case 4://签署协议
        {
            ProtocolVC *vc=[[ProtocolVC alloc] initWithNibName:@"ProtocolVC" bundle:nil];
            vc.protocolType = taskMd.model;
            vc.taskbn = taskMd.task_bn;
            vc.hidesPopNav=self.hidesPopNav;
            [self.delegateNav setNavigationBarHidden:NO animated:NO];
            [self.delegateNav pushViewController:vc animated:NO];
        }
            break;
        case 12://去评价
        {
            EvaluateVC *vc = [[EvaluateVC alloc] initWithNibName:@"EvaluateVC" bundle:nil];
            
            vc.taskBn = taskMd.task_bn;
//            vc.imgstr = taskMd.publisher.avatar;
            vc.name = taskMd.publisher;
            
            vc.hidesPopNav=self.hidesPopNav;
            [self.delegateNav setNavigationBarHidden:NO animated:NO];
            [self.delegateNav pushViewController:vc animated:NO];
        }
            break;
        default:
            break;
    }
}

@end
