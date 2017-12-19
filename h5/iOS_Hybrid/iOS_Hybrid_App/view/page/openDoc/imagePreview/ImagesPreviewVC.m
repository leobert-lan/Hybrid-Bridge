//
//  ImagesPreviewVC.m
//  cyy_task
//
//  Created by Qingyang on 16/11/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ImagesPreviewVC.h"
#import "BaseCollectionCell.h"
#import "ImagesPreviewCell.h"

static int kMaxLoadSize = 2*1024*1024;
@interface ImagesPreviewVC ()

@end

@implementation ImagesPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dataInit];
//    [self showLoading];
}

- (void)dataInit{
//    queueOpenPhoto=dispatch_queue_create("QPhotoViewer", NULL);
    
    loadIndex=-1;
    curIndex=-1;
    lastIndex=-1;
    enabledBtn=YES;
    
//    [self showNum];
    [self show:_indexSelected];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    vTop.backgroundColor=RGBAHex(kColorGray201, 0.3);

    self.view.backgroundColor=RGBHex(kColorB);
    
    self.navigationController.navigationBarHidden=YES;
    
    CGRect frm=self.view.bounds;
    self.collectMain.frame=frm;
    
    self.collectMain.pagingEnabled=YES;
    self.collectMain.backgroundColor=RGBHex(kColorB);
    
    //在显示状态栏时，防止内部控件抖动
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)show:(NSInteger)index{
    if (index>=0 && index<self.arrPhotos.count) {
        lastIndex=index;
        SyncBegin
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [self.collectMain scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [self checkInfos:index];
        [self loadImageForCell:indexPath];
        SyncEnd
    }
    
}

#pragma mark - 打断下载退出界面
- (void)stopDownload{
    [HTTPDownload downloadFileCancel:httpDownload];
}
#pragma mark - Action
- (void)popVCAction:(id)sender  {
    self.navigationController.navigationBarHidden=NO;
    [self stopDownload];
    [super popVCAction:sender];
}
#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPhotos.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString * CellID = @"ImagesPreviewCell";
//    BaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:CellID bundle:[NSBundle mainBundle]];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:CellID];
    
    BaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    
    cell.delegate=self;
    
    if (row<self.arrPhotos.count) {
        id obj=self.arrPhotos[row];
        if ([obj isKindOfClass:[UIImage class]]) {
            [cell setCell:obj];
        }
        else if([obj isKindOfClass:[ImagesPreviewModel class]]){
//            ImagesPreviewModel *mm=obj;
            [cell setCell:nil];
            [cell setCell:obj];
            
//            lblTTL.text=mm.title;
            
        }
        
        return  cell;
        
        
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size;
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollDidEnd];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self isScrolling];
}

#pragma mark - self scroll
- (void)scrollDidEnd {
//    enabledBtn=YES;
    
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (ImagesPreviewCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];
        
        [self loadImageForCell:indexPath];
    }
}

- (void)isScrolling {
    
    
    float mm = CGRectGetWidth(self.collectMain.frame)/2;
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (ImagesPreviewCell *cell in visibleCells) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect frm=[cell convertRect:cell.bounds toView:window];
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];
        
        if (frm.origin.x <= mm && frm.origin.x >= -mm) {
            //滑动状态检查图片对应状态
            [self checkInfos:indexPath.row];
//            [self checkSelected:indexPath.row];
        }
        if (frm.origin.x==0) {
            lastIndex=indexPath.row;
            enabledBtn=YES;
        }
        else enabledBtn=NO;
    }
}

#pragma mark - 滑动停止,加载
- (void)checkInfos:(NSInteger)row{
    if (curIndex==row) {
        return;
    }
    
    curIndex=row;
    if (curIndex<self.arrPhotos.count) {
        ImagesPreviewModel *mm=[self.arrPhotos objectAtIndex:curIndex];
        lblTTL.text=mm.title;
    }
}

- (void)loadImageForCell:(NSIndexPath *)indexPath{
    if (loadIndex==indexPath.row) {
        return;
    }
    
    loadIndex=indexPath.row;
    if (loadIndex>=self.arrPhotos.count) {
        return;
    }
    /*
    ALAsset *ass=self.arrPhotos[loadIndex];
    
    curPhoto=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
    if (curPhoto) {
        [self cellIndexPath:indexPath loadImage:curPhoto];
        return;
    }
    
    //    DLog(@"isOpening %i",PhotosAlbum.isOpening);
    [ASSETS_Album cleanPhotosQueue];
    [ASSETS_Album getFullImageByAsset:ass photoBlock:^(UIImage *fullResolutionImage) {
        [self invokeAsyncQueueBlock:^id{
            curPhoto = fullResolutionImage;
            //            DLog(@"%@",NSStringFromCGSize(curPhoto.size));
            if (curPhoto.size.width*curPhoto.size.height>1200*1200) {
                curPhoto = [self imageByScalingToMinSize:curPhoto];
            }
            
            [self setCacheImage:curPhoto key:ass.defaultRepresentation.url.absoluteString];
            
            return curPhoto;
        } success:^(id obj){
            [self cellIndexPath:indexPath loadImage:obj];
        }];
        
        
    } failure:^(NSError *error) {
        //
    }];
    */
    
}
#pragma mark - PhotoViewerDelegate



- (void)ImagesPreviewCellTapDelegate:(ImagesPreviewCell*)cell{
    [self oneTap];
}

- (void)ImagesPreviewCellDelegate:(ImagesPreviewCell*)cell saveImage:(UIImage*)image model:(ImagesPreviewModel*)model{
    [self saveImageWithURL:model];
}
#pragma mark 单击屏幕
- (void)oneTap{
    [self barStatus];
}

#pragma mark 下载保存图片
- (void)saveImageWithURL:(ImagesPreviewModel*)mm {
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSString *ss=[NSString stringWithFormat:@"保存到相册(%@)",mm.imgSizeString];
    UIAlertAction *save = [UIAlertAction actionWithTitle:ss style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //下载图片
        DLog(@"saveImageWithURL:%@",[mm toDictionary]);
        
        
        [self checkImages:mm];
        
    }];
    
  
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alt addAction:save];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}


- (void)checkImages:(ImagesPreviewModel*)mm{
    
    //检查 path＋size+oid＋datetime
    NSString *url=!StrIsEmpty(mm.imgURL)?StrFromObj(mm.imgURL):StrFromObj(mm.imgPreviewURL);
    NSString *fileDir=[NSString stringWithFormat:@"%@+%@+%@",url,mm.imgSize,mm.oid];
    fileDir=[fileDir MD5];
    
    NSString *floder=[NSString stringWithFormat:@"images/%@",fileDir];
    NSString* pathFloder = [[FileManager getCachePath] stringByAppendingPathComponent:floder];
    
    NSString *fName = [url fileNameOfURL];
    if (fName==nil) {
        fName=fileDir;
    }
    NSString *pathFile=[pathFloder stringByAppendingPathComponent:fName];
    if ([FileManager isExist:pathFile]) {
        //文件存在,直接打开
        [self didLoad];
        [self saveToAlbum:pathFile];

    }
    else if (QGLOBAL.netStatus != ReachableViaWiFi) { //检查网络，非Wi-Fi状态
        //检查文件大小
        if (mm.imgSize.doubleValue > kMaxLoadSize) {
            //文件过大
            NSString *ss=[NSString stringWithFormat:Msg_Is4G,mm.imgSizeString];
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ss preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //下载文件＋打开
                [self downloadFile:url toLoaclPath:pathFile];
                
            }];
            [alt addAction:ok];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alt addAction:cancel];
            [self presentViewController:alt animated:YES completion:nil];
            
            
        }
        else {
            //下载文件＋打开
            [self downloadFile:url toLoaclPath:pathFile];
        }
    }
    else {
        //下载文件＋打开
        [self downloadFile:url toLoaclPath:pathFile];
    }
    
}

//下载文件到cache文件夹，并根据md5值创建文件夹存放文件
- (void)downloadFile:(NSString*)path toLoaclPath:(NSString*)pathFile{
    [self showLoading];
//    [self showLoadingWithMessage:@"正在加载 (0%)"];
    httpDownload=[OtherAPI downloadFileForAuth:path diskPath:pathFile completion:^(NSURLResponse *response, NSString *filePath, NetError *err) {
        [self didLoad];
        if (err) {
            //已取消
            if (err.errStatusCode==-999) {
                [self showText:Msg_FileDownloadCancel];
                return ;
            }
            //失败
            [self showText:Msg_FileDownloadFailure];
        }
        else {
//            DLog(@":downloadFile:%@",filePath);
            [self saveToAlbum:filePath];
        }
    } writeDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        /*
        if (totalBytesExpectedToWrite > 0) {
            //DLog(@"DDD:%lld",totalBytesWritten);
            [self showLoadingWithMessage:[NSString stringWithFormat:@"正在加载 (%.1f%%)",100*((Float64)totalBytesWritten/totalBytesExpectedToWrite)]];
        }
        */
    }];
   
}

#pragma mark - 保存到相册
- (void)saveToAlbum:(NSString*)fullPath{
    UIImage *img=[UIImage imageWithContentsOfFile:fullPath];;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL)
    {
        [self showText:Msg_FileDownloadNoDiskSpace];
    }
    else  // No errors
    {
        [self showText:Msg_FileDownloadSuccess];
    }
}
#pragma mark - hud
//有触摸到hud
- (void)hudCenterTouch:(MBProgressHUD *)hud{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:@"是否停止下载?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"放弃下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //放弃下载
        [self stopDownload];
        
    }];
    [alt addAction:ok];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}

//触摸取消hud
- (void)hudStopByTouchNavLeft:(MBProgressHUD *)hud{
    
}
#pragma mark - Bar
- (void)barStatus{
    barHide=!barHide;
    [self barHidden:barHide];
}

- (void)barHidden:(BOOL)enabled{
    barHide=enabled;
    if (enabled) {
        vTop.hidden=YES;

        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    else {
        vTop.hidden=NO;
  
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

#pragma mark - 滑动返回上一页
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    //禁止，防止误操作
}

@end
