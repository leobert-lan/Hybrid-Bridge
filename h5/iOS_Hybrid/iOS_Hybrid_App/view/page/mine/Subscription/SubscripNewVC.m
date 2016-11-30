//
//  SubscripNewVC.m
//  cyy_task
//
//  Created by Qingyang on 16/9/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SubscripNewVC.h"
#import "MineAPI.h"
static int numSel=150;
@interface SubscripNewVC ()

@end

@implementation SubscripNewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dataSourceInit];
    [self getList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    colType.height-=vFooter.height;
    
    [self setCollHeader];
    
    
    
//    [colType bringSubviewToFront:vHeader];
    
//    DLog(@"%@ %@",vHeader,[vHeader superview]);
}

- (void)getList{
    if (self.arrData==nil) {
        [self showLoading];
        [OtherAPI getIndustryList:NO success:^(NSMutableArray *arr) {
            self.arrData=[OtherAPI collItemsFromSubIndustryList:arr canAll:NO];
            dsChoose.arrData=self.arrData;
            
            [colType reloadData];
            
            //注册过来的
            if (!_canJump) {
                [MineAPI MySubscripListWithSuccess:^(NSString *indus_id, NSString *indus_name) {
                    DLog(@">>>> %@ %@",indus_id,indus_name);
                    [self checkSelected:indus_id];
                    [colType reloadData];
                    [self didLoad];
                } failure:^(NetError *err) {
                    [self didLoad];
                    if (err.errStatusCode==13862) {
                        DLog(@">>> 无数据 ");
                        return ;
                    }
                    [self showText:err.errMessage];
                }];
            }
            else {
                [self didLoad];
            }
            
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
        }];
    }
}

- (void)checkSelected:(NSString*)ids{
    NSArray *arrIds=[ids componentsSeparatedByString:NSLocalizedString(@",", nil)];
    for (CollectionItemTypeModel * model in self.arrData) {
        for (CollectionItemTypeModel * mm in model.list) {
            for (NSString *num in arrIds) {
                if (mm.oid.intValue==num.intValue) {
                    [arrSel addObject:mm];
                    mm.selected=YES;
                }
            }
            
        }
    }
}

- (void)UIGlobal{
    [super UIGlobal];
    
//    btnOK.hidden=YES;
//    btnClose.y=15;
    
    if (self.title==nil)
        [self naviTitle:@"设置订阅标签"];
    

    
    
    colType.backgroundColor=RGBHex(kColorW);
    
    
    vFooter.backgroundColor=RGBHex(kColorMain001);
    
    
    
//
//    [btnClose setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    
//    CGRect frm;
//    frm=CGRectMake(0, vHeader.height-0.5, APP_W, 0.5);
//    spLine=[[UIView alloc]initWithFrame:frm];
//    spLine.backgroundColor=RGBHex(kColorGray206);
//    [vHeader addSubview:spLine];
    
    

}

- (void)setCollHeader{
    vHeader.backgroundColor=RGBAHex(kColorMain001,0);
    lblTTL.textColor=RGBHex(kColorAuxiliary101);
    lblTTL.font=fontSystem(kFontS26);
    lblTTL.text=@"根据设置的订阅内容为您推荐精确需求";
    
    vHeader.frame = CGRectMake(0, -30, APP_W-kSearchColleMargin*2, 30);
    [colType setContentInset:UIEdgeInsetsMake(30, kSearchColleMargin, kSearchColleMargin, kSearchColleMargin)];
    
    [colType addSubview: vHeader];
}
#pragma mark - 筛选条件 数据初始化
- (void)dataSourceInit{
    arrSel=[[NSMutableArray alloc]initWithCapacity:numSel];
    
    dsChoose=[[SearchColleDataSource alloc]init];
    dsChoose.delegate=self;
   
    [dsChoose setColWidth:APP_W cellMinWidth:130 margin:kSearchColleMargin sectionHeaderDisabled:NO];
    
//    [colType setContentInset:UIEdgeInsetsMake(0, kSearchColleMargin, kSearchColleMargin, kSearchColleMargin)];
    
    colType.delegate=dsChoose;
    colType.dataSource=dsChoose;
    

}

#pragma mark - action
- (IBAction)okAction:(id)sender{
    if (arrSel.count) {
        NSString *str=nil;
        for (CollectionItemTypeModel* mm in arrSel) {
            if (str==nil) {
                str=[NSString stringWithFormat:@"%@",StrFromObj(mm.oid)];
            }
            else
                str=[NSString stringWithFormat:@"%@,%@",str,StrFromObj(mm.oid)];
        }
        [MobClick event:UMSubscrSuccess];
        
        [self showLoading];
        [MineAPI SubscripIndusIds:str success:^(id model) {
            [self didLoad];
            DLog(@"用户订阅成功 %@",model);
            
            [self showText:@"用户订阅成功!"];
            
            [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
        }];
    }
    else {
        [self showText:@"您还没有选择标签!"];
    }
}


- (void)popVCAction:(id)sender{
    if (_canJump) {
        [MobClick event:UMSubscrLeave];
        
        //没有返回页直接重启项目
        if (self.delegatePopVC==nil) {
            [APPDelegate mainInit];
            return;
        }
        [self jumpToPopVCAction:nil];
    }
    else {
        [super popVCAction:nil];
    }
}
#pragma mark - BaseCollectionDataSourceDelegate
- (void)BaseCollectionDataSourceDelegate:(SearchColleDataSource*)delegate didSelectItemModel:(CollectionItemTypeModel*)model{
    
    
    if (model.selected==false) {
        if (arrSel.count<numSel) {
            NSInteger ii=[arrSel indexOfObject:model];
            if (ii == NSNotFound) {
                [arrSel addObject:model];
            }
        }
        else {
            //alert num
            [self showText:[NSString stringWithFormat:@"最多%i个标签",numSel]];
            return;
        }
        
    }
    else {
        [arrSel removeObject:model];
    }
    
    model.selected=!model.selected;
    [colType reloadData];
}
@end
