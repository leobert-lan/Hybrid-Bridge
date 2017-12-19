//
//  OpenFileDetailVC.m
//  CloudBox
//
//  Created by zhchen on 16/3/15.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "OpenFileDetailVC.h"
#import <QuickLook/QuickLook.h>
#import "OtherAPI.h"
//大于等于
#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)

@interface OpenFileDetailVC ()<QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate>


{
    QLPreviewController *previewController;
//    UIProgressView *fileProgress;
    NSURLSessionDownloadTask *httpDownload;
    BOOL isFirst;
}

@property (nonatomic,strong)UIDocumentInteractionController *documentController;
@end

@implementation OpenFileDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = NO;
    if (self.filePath) {
        [self creatPreviewController];
    }
    else if(self.fileModel!=nil){
        [self openFileOnline];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    //[self naviRightBotton:@"操作" action:@selector(rightAction:)];
    self.title = self.FileTitle;
}



#pragma mark - Action
- (void)rightAction:(UIBarButtonItem *)sender
{
    //创建实例
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:self.filePath];
    
    //设置代理
    self.documentController.delegate = self;
    CGRect navRect = self.navigationController.navigationBar.frame;
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    [self.documentController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
    
}
#pragma mark - 打断下载退出界面
- (void)stopDownload{
//    DLog(@">>>stopDownload");
    [HTTPDownload downloadFileCancel:httpDownload];
}
- (void)popVCAction:(id)sender{
    
    
    [self didLoad];
    [self stopDownload];
    [super popVCAction:nil];
}

#pragma mark - 打开本地文件
- (void)creatPreviewController{
    //添加按钮
//    [self naviRightBotton:@"操作" action:@selector(rightAction:)];
    //检查编码格式
    [self checkTxtCode];
    
    //启动预览
    previewController=nil;
    self.view.clipsToBounds = YES;
    previewController = [[QLPreviewController alloc]init];
//    [fileProgress setProgress:1 animated:YES];
    previewController.dataSource = self;
    if (isFirst && IOS_VERSION_10) {
        [self addChildViewController:previewController];
    }
    previewController.view.frame = CGRectMake(0, 0, APP_W, APP_H);
    [self.view addSubview:previewController.view];
    [previewController reloadData];
}

- (void)checkTxtCode{
    if (![self checkTextType:self.contentType]) {
        return;
    }
    
    NSData *fileData = [NSData dataWithContentsOfURL:self.filePath];
    //判断是UNICODE编码
    NSString *isUNICODE = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    //还是ANSI编码
    NSString *isANSI = [[NSString alloc] initWithData:fileData encoding:-2147482062];
    if (isUNICODE) {
        NSString *retStr = [[NSString alloc]initWithCString:[isUNICODE UTF8String] encoding:NSUTF8StringEncoding];
        NSData *data = [retStr dataUsingEncoding:NSUTF16StringEncoding];
        [data writeToURL:self.filePath atomically:YES];
    }
    else if(isANSI){
        NSData *data = [isANSI dataUsingEncoding:NSUTF16StringEncoding];
        [data writeToURL:self.filePath atomically:YES];
    }
}

//text/plain application/rtf
- (BOOL)checkTextType:(NSString*)type{
    if (type==nil) {
        return NO;
    }
    //text/x-settings-ini
    NSArray *arr=[type componentsSeparatedByString:@"/"];
    NSString *ss=arr.firstObject;
    if ([ss compareInsensitive:@"text"]) {
        NSString *ls = arr.lastObject;
        if ([ls rangeOfString:@"plain"].location != NSNotFound) {
            return YES;
        }
        if ([ls rangeOfString:@"x-settings-ini"].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - QLPreviewControllerDataSource 代理
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.filePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - 打开在线文件
- (void)openFileOnline{
    
    NSString *path ;
    NSString *fileName,*fileDir;
    NSString *fileSize;
    fileDir=[NSString stringWithFormat:@"%@+%@",self.fileModel.filePath,self.fileModel.fileSize];
    fileName=self.fileModel.fileName;
    fileSize=StrFromObj(self.fileModel.fileSize);
    path = self.fileModel.urlDownload;
    
//    fileProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 10)];
//    fileProgress.progressViewStyle = UIProgressViewStyleDefault;
//    fileProgress.progressTintColor = RGBHex(kColorAuxiliary103);//kColorAuxiliary102
//    fileProgress.progress = 0.01;
//    [self.view addSubview:fileProgress];
    
    //检查 path＋size
    fileDir=[fileDir MD5];
    NSString *floder=[NSString stringWithFormat:@"preview/%@/%@",self.taskBn,fileDir];
    NSString* pathFloder = [[FileManager getCachePath] stringByAppendingPathComponent:floder];
    NSString *pathFile=[pathFloder stringByAppendingPathComponent:fileName];
    if ([FileManager isExist:pathFile]) {
        //文件存在,直接打开
        [self didLoad];
        self.filePath = [NSURL fileURLWithPath:pathFile];
        isFirst = YES;
        [self creatPreviewController];
    }else if (QGLOBAL.netStatus != ReachableViaWiFi) { //检查网络，非Wi-Fi状态
        //检查文件大小
        if (fileSize.doubleValue>2*1024*1024) {
            //文件过大
            NSString *ss=[NSString stringWithFormat:Msg_Is4G,self.fileModel.fileSizeAlias];
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ss preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //下载文件＋打开
                [self downloadFile:path toLoaclPath:pathFile];
                
            }];
            [alt addAction:ok];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self popVCAction:nil];
            }];
            [alt addAction:cancel];
            [self presentViewController:alt animated:YES completion:nil];
        }else {
            //下载文件＋打开
            [self downloadFile:path toLoaclPath:pathFile];
        }
    }else {
        //下载文件＋打开
        [self downloadFile:path toLoaclPath:pathFile];
    }
}

//下载文件到cache文件夹，并根据md5值创建文件夹存放文件
- (void)downloadFile:(NSString*)path toLoaclPath:(NSString*)pathFile{
    NSString *url=path;
    DLog(@">>>下载并打开文档   :%@",url);
    [self showLoadingWithMessage:@"正在加载 (0%)"];
    httpDownload=[OtherAPI downloadFileForAuth:url diskPath:pathFile completion:^(NSURLResponse *response, NSString *filePath, NetError *err) {
        if (err) {
            //载入失败
            DLog(@"载入失败%@",err);
            [self didLoad];
            [self showInfoRefreshView:@"加载失败,点击重新加载" image:@"bg_badFile" btnHidden:YES sel:@selector(openFileOnline)];
        }else {
            [self didLoad];
            //打开文件
            [self removeInfoView];
            
            self.filePath = [NSURL fileURLWithPath:pathFile];
            [self creatPreviewController];
        }
    } writeDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (totalBytesExpectedToWrite > 0) {
//            DLog(@"DDD:%lld",totalBytesWritten);
            [self showLoadingWithMessage:[NSString stringWithFormat:@"正在加载 (%.1f%%)",100*((Float64)totalBytesWritten/totalBytesExpectedToWrite)]];
            
//            [fileProgress setProgress:(Float64)totalBytesWritten/totalBytesExpectedToWrite+0.01 animated:YES];
        }
    }];
}

@end
