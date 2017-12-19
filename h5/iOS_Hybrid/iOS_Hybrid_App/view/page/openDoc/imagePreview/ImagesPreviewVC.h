//
//  ImagesPreviewVC.h
//  cyy_task
//
//  Created by Qingyang on 16/11/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "ImagesPreviewCell.h"
@interface ImagesPreviewVC : BaseViewController
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ImagesPreviewCellDelegate>
{
    BOOL barHide;
    BOOL enabledBtn;//图片选择状态激活
    IBOutlet UIView *vTop;
    IBOutlet UILabel *lblTTL;
    NSInteger loadIndex,curIndex,lastIndex;
    NSURLSessionDownloadTask *httpDownload;
}
@property (nonatomic,assign) NSInteger indexSelected;//选择照片位置
@property (nonatomic,strong) NSMutableArray *arrPhotos;
@property (nonatomic,strong) IBOutlet UICollectionView *collectMain;
@end
