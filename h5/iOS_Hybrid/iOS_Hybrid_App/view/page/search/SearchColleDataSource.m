//
//  SearchColleDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchColleDataSource.h"
static CGFloat kMinWidth = 98;
static CGFloat kMargin = 6;
static CGFloat kSectionHeaderHeight = 35; //头高
static CGFloat kItemHeight = 30; //高度
static CGFloat kLineSpacing = 10;//行间距
//static CGFloat kSpec = 24;
@interface SearchColleDataSource(){
    int numItem;
    CGFloat cellWidth;
    CGFloat cellMargin;
    CGFloat edgeMargin;
}
@end

@implementation SearchColleDataSource
- (id)init{
    self = [super init];
    if (self) {
        edgeMargin=kSearchColleMargin;
        numItem=1;
    }
    return self;
}

- (CGSize)getSizeWithCollectionView:(UICollectionView *)collectionView{
    
    CGFloat totalW=(_width-edgeMargin*2);
    CGSize sz=CGSizeMake(totalW, 0);

    CGFloat hh=0;
    if (_sectionHeaderDisabled==false) {
        hh=kSectionHeaderHeight*self.arrData.count;
    }
    
    for (CollectionItemTypeModel *mm in self.arrData) {
        int nn= (int)mm.list.count/numItem;
        if (mm.list.count%numItem != 0) {
            nn++;
        }
        hh += kItemHeight*nn;
        hh += kLineSpacing*(nn-1);
    }
    
    hh += collectionView.contentInset.bottom;
    sz.height=hh;
    
    return sz;
}

- (void)setColWidth:(CGFloat)width margin:(CGFloat)margin sectionHeaderDisabled:(BOOL)sectionHeaderDisabled{
    edgeMargin=(margin>=0)?margin:kSearchColleMargin;
    self.width=width;
    self.sectionHeaderDisabled=sectionHeaderDisabled;
}

- (void)setColWidth:(CGFloat)width cellMinWidth:(CGFloat)cellMinWidth margin:(CGFloat)margin sectionHeaderDisabled:(BOOL)sectionHeaderDisabled{
    edgeMargin=(margin>=0)?margin:kSearchColleMargin;
    self.cellMinWidth=cellMinWidth;
    self.width=width;
    self.sectionHeaderDisabled=sectionHeaderDisabled;
}

- (void)setWidth:(CGFloat)width{
    _width=width;
    _cellMinWidth=(_cellMinWidth>0)?_cellMinWidth:kMinWidth;
    
    CGFloat totalW=(_width-edgeMargin*2);
    numItem=(int)floorf(totalW/_cellMinWidth);
    if (numItem<=0) {
        numItem=1;
    }
    
    cellWidth=_cellMinWidth;
    cellMargin=kMargin;
    CGFloat ww=_cellMinWidth*numItem+kMargin*(numItem-1);
    if (ww<totalW) {
        cellWidth=(totalW-(numItem-1)*kMargin)/numItem;
    }
    else {
        cellMargin=(totalW-numItem*_cellMinWidth)/(numItem-1);
    }
    
    if (cellMargin<=0) {
        cellMargin=0;
    }
//    DLog(@">>>度:%f ww:%f num:%i cw:%f m:%f",_width,ww,numItem,cellWidth,cellMargin);
//    cellMargin=0;
}
#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section<self.arrData.count) {
        CollectionItemTypeModel *mm=[self.arrData objectAtIndex:section];
//        DLog(@">>> %li-%li",self.arrData.count,mm.list.count);
        return mm.list.count;
    }
    return 0;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.arrData.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    NSInteger sec=indexPath.section;
    
    
    static NSString * CellID = @"SearchConditionCell";

    //注册cell
//    NSBundle * classBundle = [NSBundle bundleForClass:[SearchConditionSection class]];
    UINib *cellNib = [UINib nibWithNibName:CellID bundle:[NSBundle mainBundle]];//[NSBundle mainBundle]
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:CellID];

    SearchConditionCell *cell = (SearchConditionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];

    cell.delegate=self;

    if (sec<self.arrData.count) {
        CollectionItemTypeModel *mm=[self.arrData objectAtIndex:sec];
        if (row<mm.list.count) {
            CollectionItemTypeModel *m2=[mm.list objectAtIndex:row];
            [cell setCell:m2];
        }
    }
//    if (row<arrPhotos.count) {
//        ALAsset *ass=[arrPhotos objectAtIndex:row];
//        cell.imgPhoto.image=[UIImage imageWithCGImage:ass.thumbnail];
//        cell.url=[ass.defaultRepresentation.url absoluteString];
//        cell.index=row;
//        cell.btnSelect.selected=NO;
//        for (PhotoModel *mode in arrSelected) {
//            if ([mode.url isEqualToString:cell.url]) {
//                cell.btnSelect.selected=YES;
//                break;
//            }
//        }
//    }
    
    return cell;
//    return [[UICollectionViewCell alloc] init];
}

#pragma mark --UICollectionView section
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSInteger sec=indexPath.section;
    if (kind == UICollectionElementKindSectionHeader)
    {
        // 注册footer和header类型的重用标识符
        static NSString * CellID = @"SearchConditionSection";


        [collectionView registerClass:[SearchConditionSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellID];
//        NSBundle * classBundle = [NSBundle bundleForClass:[SearchConditionSection class]];
        UINib * nib = [UINib nibWithNibName:@"SearchConditionSection" bundle:[NSBundle mainBundle]];
        [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:CellID];
        SearchConditionSection *vv = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellID forIndexPath:indexPath];
 
//        SearchConditionSection *vv = [SearchConditionSection collectionReusableViewForCollectionView:collectionView forIndexPath:indexPath withKind:UICollectionElementKindSectionHeader];
        if (sec<self.arrData.count) {
            CollectionItemTypeModel *mm=[self.arrData objectAtIndex:sec];
            [vv setCell:mm];
        }
        
        reusableview = vv;
    }
    
    //    if (kind == UICollectionElementKindSectionFooter)
    //    {
    //
    //    }
    
    reusableview.backgroundColor = [UIColor clearColor];
    
    return reusableview;
}

#pragma mark 设置header和footer高度

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section

{
    if (_sectionHeaderDisabled) {
        return CGSizeMake(_width, 0);
    }
    return CGSizeMake(_width, kSectionHeaderHeight);
    
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, kItemHeight);//AutoSize(100, 30);
}

//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
////    float ss=AutoValue(5);//kMargin*AUTOSIZE.autoSizeScale;
//    return UIEdgeInsetsMake(3, cellMargin, 3, cellMargin);
//}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kLineSpacing;//AutoValue(5);
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return cellMargin;
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec=indexPath.section;
    NSInteger row=indexPath.row;
    if (sec<self.arrData.count) {
        CollectionItemTypeModel *mm=[self.arrData objectAtIndex:sec];
        if (row<mm.list.count) {
            CollectionItemTypeModel *m2=[mm.list objectAtIndex:row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BaseCollectionDataSourceDelegate:didSelectItemModel:)]) {
                [self.delegate BaseCollectionDataSourceDelegate:self didSelectItemModel:m2];
            }
        }
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;

}
@end
