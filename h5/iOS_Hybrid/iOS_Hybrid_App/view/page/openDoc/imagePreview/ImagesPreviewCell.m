//
//  ImagesPreviewCell.m
//  cyy_task
//
//  Created by Qingyang on 16/11/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ImagesPreviewCell.h"

@interface ImagesPreviewCell()
<UIScrollViewDelegate,ScrollTouchesDelegate>
{
    //
}
@end

@implementation ImagesPreviewCell
+ (CGSize)getCellSize:(id)data{
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    return sz;
}

- (void)UIGlobal{
    [super UIGlobal];
    
    [btnReload setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
}

- (void)setCell:(id)data{
    btnReload.hidden=YES;
    self.contentView.backgroundColor=RGBHex(kColorB);
    self.scroll.backgroundColor=RGBAHex(kColorB, 0);
    
    self.scroll.minimumZoomScale = 1;
    self.scroll.maximumZoomScale = 3;//支持放大三倍
    self.scroll.zoomScale = 1;
    
    
    if (self.imgPhoto==nil) {
        self.imgPhoto = [[UIImageView alloc]init];
    }
    
    //添加长按保存图片
    [self removeGestureRecognizer:longPress];
    longPress=nil;
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    longPress.minimumPressDuration = 1.05;
    [self addGestureRecognizer:longPress];
    
    if (data==nil) {
        [self.imgPhoto setImage:nil];
        [self resize];
        return;
    }
    else if([data isKindOfClass:[UIImage class]]){
        self.photo=data;
        [self.imgPhoto setImage:data];
        [self resize];
    }
    else if([data isKindOfClass:[ImagesPreviewModel class]]){
        mmImage=data;
        [self loadImage:NO];
//        DLog(@"%@",[mmImage toDictionary]);
    }
    
}

- (void)loadImage:(BOOL)retry{
    btnReload.hidden=YES;
    NSString *url=mmImage.imgPreviewURL;
    
    
    if (act==nil) {
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        act.center = CGPointMake(APP_W/2, APP_H/2);
    }
    __block UIActivityIndicatorView *actSelf=act;//self.contentView.center;
    
    actSelf.alpha=1;
    [act startAnimating];
    [self.contentView addSubview:act];
    
    SDWebImageOptions op=retry?SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached:SDWebImageRetryFailed|SDWebImageProgressiveDownload;
    __weak typeof (self) weakSelf = self;
    [self.imgPhoto setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:op progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            weakSelf.imgPhoto.image=[UIImage imageNamed:@"bg_badImage"];
            [weakSelf resize];
            [weakSelf loadSuccess:NO];
        }
        else if (weakSelf) {
            
            [weakSelf resize];
            [weakSelf loadSuccess:YES];
        }
        
        
        [UIView animateWithDuration:.25 animations:^{
            actSelf.alpha=0;
        } completion:^(BOOL finished) {
            [actSelf removeFromSuperview];
        }];
    }];
}

//修改图片显示大小，图片大小不变
- (void)resize{
    CGSize sz=[self originSize:self.imgPhoto.image.size fitInSize:[UIScreen mainScreen].bounds.size];
    
    
    CGRect frm = [UIScreen mainScreen].bounds;
    frm.origin.x=(frm.size.width-sz.width)/2;
    frm.origin.y=(frm.size.height-sz.height)/2;
    frm.size=sz;
    self.imgPhoto.frame=frm;
    
    [self.scroll addSubview:self.imgPhoto];
    
    self.scroll.delegateTouch=self;
}

- (void)loadSuccess:(BOOL)success{
    if (success) {
        btnReload.hidden=YES;
    }
    else {
        btnReload.center=_imgPhoto.center;
        btnReload.hidden=NO;
    }
}
#pragma mark - Action
- (IBAction)reloadAction:(id)sender{
    [self loadImage:YES];
}

#pragma mark - save
- (void)saveImage:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        
        if ([self.delegate respondsToSelector:@selector(ImagesPreviewCellDelegate:saveImage:model:)]) {
            [self.delegate ImagesPreviewCellDelegate:self saveImage:self.imgPhoto.image model:mmImage];
        }
    }
}

#pragma mark - CGSize适配大小
//图片适配相框，过大的等比缩小，过小的不管
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    if (oSize.height<=fSize.height && oSize.width<=fSize.width) {
        return oSize;
    }
    
    float os=oSize.width/oSize.height;
    float fs=fSize.width/fSize.height;
    
    float ww,hh;
    if (os>fs) {
        ww=fSize.width;
        hh=oSize.height*fSize.width/oSize.width;
    }
    else {
        ww=oSize.width*fSize.height/oSize.height;
        hh=fSize.height;
    }
    
    
    //约等于floor()，ceil()四舍五入
    if (floor(os*100) / 100 == floor(fs*100) / 100 ) {
        //        DLog(@"%f %f",oSize.width/oSize.height,fSize.width/fSize.height);
        ww=fSize.width;
        hh=fSize.height;
        
    }
    
    return CGSizeMake(ww, hh);
}

//图片适配相框，过大的等比缩小，过小的等比放大
- (CGSize)originSize:(CGSize)oSize fitToSize:(CGSize)fSize{
    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    
    float os=oSize.width/oSize.height;
    float fs=fSize.width/fSize.height;
    
    float ww,hh;
    if (os>fs) {
        ww=fSize.width;
        hh=oSize.height*fSize.width/oSize.width;
    }
    else {
        ww=oSize.width*fSize.height/oSize.height;
        hh=fSize.height;
    }
    
    
    //约等于floor()，ceil()四舍五入
    if (floor(os*100) / 100 == floor(fs*100) / 100 ) {
        //        DLog(@"%f %f",oSize.width/oSize.height,fSize.width/fSize.height);
        ww=fSize.width;
        hh=fSize.height;
        
    }
    
    return CGSizeMake(ww, hh);
}
#pragma mark - ScrollTouchesDelegate
-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(id)scrollView{

    if ([self.delegate respondsToSelector:@selector(ImagesPreviewCellTapDelegate:)]) {
        [self.delegate ImagesPreviewCellTapDelegate:self];
    }
}

#pragma mark - UIScrollViewDelegate
//返回需要缩放对象
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imgPhoto;
}

//缩放时保持居中
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    [self.imgPhoto setCenter:CGPointMake(xcenter, ycenter)];
}



@end
