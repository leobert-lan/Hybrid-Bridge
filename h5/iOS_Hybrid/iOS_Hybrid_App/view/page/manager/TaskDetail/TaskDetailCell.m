//
//  TaskDetailCell.m
//  cyy_task
//
//  Created by zhchen on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskDetailCell.h"

@interface TaskDetailCell ()
{
    IBOutlet UIView *fileV;
    IBOutlet UIButton *btnFile;
    IBOutlet UILabel *lblFile;
}
@end

@implementation TaskDetailCell

+ (float)getCellHeight:(TaskDetailWorksModel *)data
{
    CGFloat height = [[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f];
    CGFloat vDownH;
        if (height > 51) {
            vDownH = 199;
            if (data.isSelct.boolValue) {
                height+=20;
            }else{
            height = 80;
            }
        }else if (height < 20){
            vDownH = 159;
            height = 35;
        }
        else{
            vDownH = 159;
            height = height+20;
        }
    NSArray *pathArr = [data.attachments componentsSeparatedByString:@"path="];
    NSString *path = [pathArr lastObject];
    if (StrIsEmpty(path) || StrIsEmpty(data.attachments)){
        vDownH-=60;
    }
    
    if ([QGLOBAL.detailTaskWorkType isEqualToString:@"2"] && QGLOBAL.isEmployer == YES && [QGLOBAL hadAuthToken]){
        NSString *str = [NSString stringWithFormat:@"报价：¥%@   工期：%@天",data.price,data.days];
        CGFloat lblPriceheight = [[self alloc] getTextHeightWithString:str withFontSize:14.0f];
        if (lblPriceheight < 20) {
            lblPriceheight = 20+10;
        }else{
            lblPriceheight+=10;
        }
        /*
        CGFloat height = [[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f];
        CGFloat vDownH;
        if (QGLOBAL.TaskDetailis) {
            height = [[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f];
            vDownH = 199;
        }else{
            if ([[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f] > 80) {
                vDownH = 199;
                height = 80;
            }else if ([[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f] < 20){
                vDownH = 159;
                height = 20;
            }
            else{
                vDownH = 159;
                height = [[self alloc] getTextHeightWithString:data.worksdescription withFontSize:14.0f]+20;
            }
        }
        NSArray *pathArr = [data.attachments componentsSeparatedByString:@"path="];
        NSString *path = [pathArr lastObject];
        if (StrIsEmpty(path) || StrIsEmpty(data.attachments)){
            vDownH-=60;
        }
         */
        return vDownH + height+lblPriceheight;
    }else{
        return vDownH + height;
    }

}


- (void)setCell:(TaskDetailWorksModel *)model
{
    self.modItem = model;    
    _lblName.font = fontSystemBold(kFontS28);
    _lblName.textColor = RGBHex(kColorGray201);
    _lblData.textColor = RGBHex(kColorGray203);
    _lblContent.textColor = RGBHex(kColorGray201);
    _lblDown.textColor = RGBHex(kColorGray203);
    _lblPrice.textColor = RGBHex(kColorAuxiliary105);
    _lblPrice.backgroundColor = RGBAHex(kColorAuxiliary105, 0.05);
    _lblName.text = model.nickname;
    _lblData.text = [QGLOBAL dateTimeIntervalToStr:model.create_time];
    if (self.modItem.isSelct.boolValue) {
        self.lblDown.text = @"收起";
        self.imgDown.image = [UIImage imageNamed:@"Submission_drop_top"];
    }else{
        self.lblDown.text = @"展开";
        self.imgDown.image = [UIImage imageNamed:@"Submission_drop_down"];
    }
    [self workListDaysAndPrice:model];
    _lblContent.text = model.worksdescription;
    [self getlblcontentHeight:model];
    
    _imgHeader.clipsToBounds = YES;
    _imgHeader.layer.cornerRadius = 50/2;
    [_imgHeader setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    NSArray *pathArr = [model.attachments componentsSeparatedByString:@"path="];
    NSString *path = [pathArr lastObject];
    if (StrIsEmpty(path) || StrIsEmpty(model.attachments)) {
        _imgphoto.hidden = YES;
        fileV.hidden = YES;
    }else{
        NSArray *arr=[model.work_ext.mime componentsSeparatedByString:@"/"];
        NSString *ss=arr.firstObject;
        if ([ss isEqualToString:@"image"]) {
            if (StrIsEmpty(model.work_ext.url_thumbnail) && StrIsEmpty(model.work_ext.url_preview)) {
                [self creatbtnFile:model];
            }else{
            [self creatbtnImg:model];
            }
        }else{
            [self creatbtnFile:model];
        }
        
    }
    [self workStatus:model];
}
// 工期和报价
- (void)workListDaysAndPrice:(TaskDetailWorksModel *)model
{
    if ([QGLOBAL.detailTaskWorkType isEqualToString:@"2"] && QGLOBAL.isEmployer == YES && [QGLOBAL hadAuthToken]){
        _lblPrice.hidden = NO;
        NSString *str;
        if ([QGLOBAL.detailTaskWorkBid isEqualToString:@"1"]) {
            str = [NSString stringWithFormat:@" 工期：%@天",model.days];
        }else if ([QGLOBAL.detailTaskWorkBid isEqualToString:@"2"]){
            str = [NSString stringWithFormat:@" 报价：¥%@   工期：%@天",model.price,model.days];
        }
        CGFloat height = [self getTextHeightWithString:str withFontSize:14.0f];
        if (height < 20) {
            _lblPriceH.constant = 20;
        }else{
            _lblPriceH.constant = height;
        }
        _lblPrice.text = str;
        
    }else{
        _lblPriceH.constant = 0;
        _lblPriceT.constant = 0;
        _lblPrice.hidden = YES;
    }
}
// 附件文件按钮
- (void)creatbtnFile:(TaskDetailWorksModel *)model
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@(%@)",model.work_ext.file_name,[QGLOBAL stringFromFileSize:model.work_ext.file_size.doubleValue]]];
    NSRange range = [[NSString stringWithFormat:@"  %@(%@)",model.work_ext.file_name,[QGLOBAL stringFromFileSize:model.work_ext.file_size.doubleValue]] rangeOfString:model.work_ext.file_name];
    [str addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorMain001) range:range];
    NSRange range2 = [[NSString stringWithFormat:@"  %@(%@)",model.work_ext.file_name,[QGLOBAL stringFromFileSize:model.work_ext.file_size.doubleValue]] rangeOfString:[NSString stringWithFormat:@"(%@)",[QGLOBAL stringFromFileSize:model.work_ext.file_size.doubleValue]]];
    [str addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray201) range:range2];
    
    _imgphoto.hidden = YES;
    fileV.hidden = NO;
    
    lblFile.font = fontSystem(kFontS28);
    lblFile.textColor = RGBHex(kColorGray201);
    
    [btnFile setAttributedTitle:str forState:UIControlStateNormal];
    NSMutableAttributedString *strHighlighted = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@(%@)",model.work_ext.file_name,[QGLOBAL stringFromFileSize:model.work_ext.file_size.doubleValue]]];
    [strHighlighted addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray211) range:range];
    [strHighlighted addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray211) range:range2];
    [btnFile setAttributedTitle:strHighlighted forState:UIControlStateHighlighted];

    btnFile.titleLabel.font = fontSystem(kFontS28);
    [btnFile addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}
// 附件图片按钮
- (void)creatbtnImg:(TaskDetailWorksModel *)model
{
    _imgphoto.hidden = NO;
    fileV.hidden = YES;
    __block UIImageView *_selfImgv=_imgphoto;
    [_imgphoto setImageWithURL:[NSURL URLWithString:model.work_ext.url_thumbnail] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error!=nil) {
            _selfImgv.image=[UIImage imageNamed:@"tulie"];
        }
    }];
}
// 具体要求高度
- (void)getlblcontentHeight:(TaskDetailWorksModel *)model
{
    _lblContent.numberOfLines = 3;
    CGFloat height = [self getTextHeightWithString:model.worksdescription withFontSize:14.0f];
    if (height > 51) {
        if (self.modItem.isSelct.boolValue) {
            AsyncBegin
            _vDown.hidden = NO;
            AsyncEnd
            _lblContent.numberOfLines = 0;
            _lblContentH.constant =  height+20;
        }else{
        _vDown.hidden = NO;
        _lblContentH.constant = 80;
        }
    }else if (height < 20){
        _vDown.hidden = YES;
        _lblContentH.constant = 35;
    }else{
        _vDown.hidden = YES;
        _lblContentH.constant = height+20;
    }
}
// 稿件状态
- (void)workStatus:(TaskDetailWorksModel *)model
{
    if ([model.status integerValue] == 3) {
        _imgSucc.image = [UIImage imageNamed:@"Successful"];
        _imgSucc.hidden = NO;
    }else if([model.status integerValue] == 2){
        _imgSucc.image = [UIImage imageNamed:@"Alternate"];
        _imgSucc.hidden = NO;
        
    }else{
        _imgSucc.hidden = YES;
    }
}
- (CGFloat)getTextHeightWithString:(NSString *)text withFontSize:(CGFloat)fontSize
{
    // 计算高度,必须对宽度进行限定
    // 第三个参数字体的大小必须和label上的字体保持一致,否则计算不准确
    CGRect rect = [text boundingRectWithSize:CGSizeMake(APP_W - 30, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    return rect.size.height;
}

- (IBAction)btnDownAction:(id)sender {
    BOOL st=self.modItem.isSelct.boolValue;
    self.modItem.isSelct=[NSNumber numberWithBool:!st];
    
    QGLOBAL.TaskDetailis = self.modItem.isSelct;
    if (self.modItem.isSelct.boolValue) {
        self.lblDown.text = @"收起";
        self.imgDown.image = [UIImage imageNamed:@"Submission_drop_top"];
    }else{
        self.lblDown.text = @"展开";
        self.imgDown.image = [UIImage imageNamed:@"Submission_drop_down"];
    }
    if ([self.delegate respondsToSelector:@selector(TaskDetailCellDelegateOpenOrClose)]) {
        [self.delegate TaskDetailCellDelegateOpenOrClose];
    }
}
- (void)btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(TaskDetailFileDelegate:model:)]) {
        [self.delegate TaskDetailFileDelegate:self model:self.modItem];
    }
}
- (IBAction)btnImgAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TaskDetailImageDelegate:model:)]) {
        [self.delegate TaskDetailImageDelegate:self model:self.modItem];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
