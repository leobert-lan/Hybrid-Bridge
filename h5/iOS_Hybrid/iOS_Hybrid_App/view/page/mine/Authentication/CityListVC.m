//
//  CityListVC.m
//  cyy_task
//
//  Created by zhchen on 16/9/2.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CityListVC.h"
#import "CityListCell.h"
#import "MineAPI.h"
@interface CityListVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *provinceArr;
    NSMutableArray *cityArr;
    NSMutableArray *sArr;
    BOOL isExP;
    BOOL isExC;
    BOOL isExS;
    BOOL isScroll;
    NSInteger indexP,indexP2,indexC,indexC2;
    NSString *strP,*strC,*strS;
    CGFloat scrollindex;
}
@end

@implementation CityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoading];
    [self refreshList];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"城市列表"];
}

#pragma mark - 获取数据
- (void)refreshList
{
    [MineAPI CityListsuccess:^(NSArray *arr) {
        
        provinceArr = [NSMutableArray array];
        provinceArr = [arr mutableCopy];
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        [self didLoad];
        [self showText:err.errMessage];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return provinceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableID;
    tableID = @"CityListCell";
    BaseTableCell *cell;
    cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil)
        cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
    
    if (isExP) {
        if (isExC) {
            AuthAreaListModel *model = provinceArr[indexPath.row];
            if (model.isEx) {
                AuthCityModel *cityModel = provinceArr[indexPath.row];
                if (cityModel.isEx) {
                    AuthCountyModel *CountyModel = provinceArr[indexPath.row];
                    [cell setCell:CountyModel];
                }else{
                    AuthCityModel *cityModel = provinceArr[indexPath.row];
                    [cell setCell:cityModel];
                }
                
                
            }else{
                AuthAreaListModel *listModel = provinceArr[indexPath.row];
                [cell setCell:listModel];
            }
        }else{
        
        AuthAreaListModel *model = provinceArr[indexPath.row];
        if (model.isEx) {
            AuthCityModel *cityModel = provinceArr[indexPath.row];
            [cell setCell:cityModel];
        }else{
            AuthAreaListModel *listModel = provinceArr[indexPath.row];
            [cell setCell:listModel];
        }
        }
    }else{
        AuthAreaListModel *ListModel = provinceArr[indexPath.row];
        
        [cell setCell:ListModel];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isExP) {
        for (id model in provinceArr) {
            if ([model isKindOfClass:[AuthCityModel class]]) {
                AuthCityModel *cityModel = model;
                cityModel.isEx = [NSNumber numberWithBool:NO];
                
            }
        }
        DLog(@"%ld,%ld,%ld",indexP,indexPath.row,indexP2);
        if (indexPath.row < indexP || indexPath.row > indexP2-1) {
            if (isExC && indexPath.row<(indexC2-indexC)+indexP2 && indexPath.row > indexP) {
                DLog(@"%ld,%ld",indexPath.row,indexC2);
                if (indexPath.row < indexC || indexPath.row > indexC2-1) {
                    if (indexPath.row == indexC - 1) {
                        AuthCityModel *model = provinceArr[indexPath.row];
                        BOOL st=model.isEx.boolValue;
                        model.isEx = [NSNumber numberWithBool:!st];
                        isExC = !isExC;
                        [provinceArr removeObjectsInArray:sArr];
                        
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < sArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexC + i inSection:0];
                            [indexPaths addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        
                    }else{
                        [self removeWithArr:sArr fromBaseArr:provinceArr];
                        
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < sArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexC + i inSection:0];
                            [indexPaths addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        
                        //                        isExC = !isExC;
                        AuthCityModel *model;
                        if (indexPath.row > indexC2-1) {
                            model = provinceArr[indexPath.row-(indexC2-indexC)];
                        }else{
                            model = provinceArr[indexPath.row];
                        }
                        
                        
                        
                        BOOL st=model.isEx.boolValue;
                        model.isEx = [NSNumber numberWithBool:!st];
                        
                        sArr = [NSMutableArray array];
                        sArr = [model.a mutableCopy];
                        strC = model.n;
                        if (model.a.count < 1) {
                            isExC = !isExC;
                            BOOL st=model.isEx.boolValue;
                            model.isEx = [NSNumber numberWithBool:!st];
                            strS = @"";
                            [self popVC];
                            return;
                        }
                        if (indexPath.row > indexC2-1) {
                            [self insertWithArr:sArr toBaseArr:provinceArr cityModel:model index:indexPath.row-(indexC2-indexC)+1];
                            
                        }else{
                            [self insertWithArr:sArr toBaseArr:provinceArr cityModel:model index:indexPath.row+1];
                        }
                        
                        
                        indexC = [provinceArr indexOfObject:sArr[0]];
                        indexC2 = indexC + [sArr count];
                    }
                    [self.tableMain reloadData];
                }else{
                    AuthCountyModel *model = provinceArr[indexPath.row];
                    strS = model.s;
                    [self popVC];
                    
                }
            }else{
                for (AuthAreaListModel *model in provinceArr) {
                    model.isEx = [NSNumber numberWithBool:NO];
                }
                if (indexPath.row == indexP-1) {
//                    AuthAreaListModel *model = provinceArr[indexPath.row];
//                    BOOL st=model.isEx.boolValue;
//                    model.isEx = [NSNumber numberWithBool:!st];
                    isExP = !isExP;
                    [self removeWithArr:cityArr fromBaseArr:provinceArr];
                    
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < cityArr.count; i++) {
                        NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexP + i inSection:0];
                        [indexPaths addObject: indexPa];
                    }
                    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    DLog(@"%d",isExC);
                    if (sArr.count > 0 && isExC) {
                        isExC = !isExC;
                        [self removeWithArr:sArr fromBaseArr:provinceArr];
                        [self removeWithArr:cityArr fromBaseArr:provinceArr];
                        NSMutableArray *indexPathssArr = [[NSMutableArray alloc] init];
                        for (int i = 0; i < sArr.count+cityArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexP + i inSection:0];
                            [indexPathssArr addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPathssArr withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        [self removeWithArr:cityArr fromBaseArr:provinceArr];
                        
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < cityArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexP + i inSection:0];
                            [indexPaths addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    }
                    //            isExP = !isExP;
                    AuthAreaListModel *model;
                    if (indexPath.row > indexP2-1) {
                        model = provinceArr[indexPath.row-(indexP2-indexP)-(indexC2-indexC)];
                    }else{
                        model = provinceArr[indexPath.row];
                    }
                    
                    BOOL st=model.isEx.boolValue;
                    model.isEx = [NSNumber numberWithBool:!st];
                    cityArr = [NSMutableArray array];
                    cityArr = [model.c mutableCopy];
                    strP = model.p;
                    if (model.c.count < 1) {
                        isExP = !isExP;
                        BOOL st=model.isEx.boolValue;
                        model.isEx = [NSNumber numberWithBool:!st];
                        strC = @"";
                        strS = @"";
                        [self popVC];
                        return;
                    }
                    if (indexPath.row > indexP2-1) {
                        [self insertWithArr:cityArr toBaseArr:provinceArr cityModel:model index:indexPath.row-(indexP2-indexP)-(indexC2-indexC)+1];
                        
                    }else{
                        
                        [self insertWithArr:cityArr toBaseArr:provinceArr cityModel:model index:indexPath.row+1];
                    }
                    
                    DLog(@"%ld",indexPath.row);
                    
                    indexP = [provinceArr indexOfObject:cityArr[0]];
                    indexP2 = indexP + [cityArr count];
                }
            }
                        [self.tableMain reloadData];
        }else{
            if (isExC) {
                DLog(@"%ld,%ld",indexPath.row,indexC2);
                if (indexPath.row < indexC || indexPath.row > indexC2-1) {
                    if (indexPath.row == indexC - 1) {
//                        AuthCityModel *model = provinceArr[indexPath.row];
//                        BOOL st=model.isEx.boolValue;
//                        model.isEx = [NSNumber numberWithBool:!st];
                        isExC = !isExC;
                        [provinceArr removeObjectsInArray:sArr];
                        
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < sArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexC + i inSection:0];
                            [indexPaths addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        [self removeWithArr:sArr fromBaseArr:provinceArr];
                        
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < sArr.count; i++) {
                            NSIndexPath *indexPa = [NSIndexPath indexPathForRow:indexC + i+1 inSection:0];
                            [indexPaths addObject: indexPa];
                        }
                        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        
                        isExC = !isExC;
                        AuthCityModel *model;
                        if (indexPath.row > indexC2-1) {
                            model = provinceArr[indexPath.row-(indexC2-indexC)];
                        }else{
                            model = provinceArr[indexPath.row];
                        }
                        
                        BOOL st=model.isEx.boolValue;
                        model.isEx = [NSNumber numberWithBool:!st];
                        
                        sArr = [NSMutableArray array];
                        sArr = [model.a mutableCopy];
                        strC = model.n;
                        if (model.a.count < 1) {
                            isExC = !isExC;
                            BOOL st=model.isEx.boolValue;
                            model.isEx = [NSNumber numberWithBool:!st];
                            strS = @"";
                            [self popVC];
                            return;
                        }
                        if (indexPath.row > indexC2-1) {
                            [self insertWithArr:sArr toBaseArr:provinceArr cityModel:model index:indexPath.row-(indexC2-indexC)+1];
                            
                        }else{
                            [self insertWithArr:sArr toBaseArr:provinceArr cityModel:model index:indexPath.row+1];
                            
                        }
                        
                        indexC = [provinceArr indexOfObject:sArr[0]];
                        indexC2 = indexC + [sArr count];
                    }
                    //                    [self.tableMain reloadData];
                }else{
                    AuthCountyModel *model = provinceArr[indexPath.row];
                    strS = model.s;
                    [self popVC];
                    
                }
                //                [self.tableMain reloadData];
            }else{
                
                isExC = !isExC;
                AuthCityModel *model = provinceArr[indexPath.row];
                BOOL st=model.isEx.boolValue;
                model.isEx = [NSNumber numberWithBool:!st];
                sArr = [NSMutableArray array];
                sArr = [model.a mutableCopy];
                strC = model.n;
                if (model.a.count < 1) {
                    isExC = !isExC;
                    BOOL st=model.isEx.boolValue;
                    model.isEx = [NSNumber numberWithBool:!st];
                    strS = @"";
                    [self popVC];
                    return;
                }
                
                [self insertWithArr:sArr toBaseArr:provinceArr cityModel:model index:indexPath.row+1];
                
                indexC = [provinceArr indexOfObject:sArr[0]];
                indexC2 = indexC + [sArr count];
            }
        }
                [self.tableMain reloadData];
    }else{
        isExP = !isExP;
        AuthAreaListModel *model = provinceArr[indexPath.row];
        BOOL st=model.isEx.boolValue;
        model.isEx = [NSNumber numberWithBool:!st];
        cityArr = [NSMutableArray array];
        cityArr = [model.c mutableCopy];
        strP = model.p;
        if (model.c.count < 1) {
            isExP = !isExP;
            BOOL st=model.isEx.boolValue;
            model.isEx = [NSNumber numberWithBool:!st];
            strC = @"";
            strS = @"";
            [self popVC];
            return;
        }
        
        
        [self insertWithArr:cityArr toBaseArr:provinceArr cityModel:model index:indexPath.row+1];
        indexP = [provinceArr indexOfObject:cityArr[0]];
        
        indexP2 = indexP + [cityArr count];
        DLog(@"%ld,%ld,%ld",indexP,indexP2,cityArr.count);
        [self.tableMain reloadData];
        
        
    }    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}
- (void)popVC{
    if (self.cityListBlock) {
        self.cityListBlock(strP,strC,strS);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)removeWithArr:(NSMutableArray *)arr fromBaseArr:(NSMutableArray *)baseArr
{
    [baseArr removeObjectsInArray:arr];
//    [arr removeAllObjects];
}

- (void)insertWithArr:(NSMutableArray *)arr toBaseArr:(NSMutableArray *)baseArr cityModel:(id)cityModel index:(NSInteger)index
{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i=0; i<arr.count; i++) {
        
        if ([cityModel isKindOfClass:[AuthAreaListModel class]]) {
            AuthCityModel *model = arr[i];
            [baseArr insertObject:model atIndex:index+i];
        }else if([cityModel isKindOfClass:[AuthCityModel class]]){
            AuthCountyModel *model = arr[i];
            [baseArr insertObject:model atIndex:index+i];
        }
//        AuthCityModel *model = cityArr[i];
        
        NSIndexPath *indexPa = [NSIndexPath indexPathForRow:index+i inSection:0];
        [indexPaths addObject: indexPa];
    }
    [self.tableMain insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    
//    [baseArr insertObjects:arr atIndexes:index];
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
