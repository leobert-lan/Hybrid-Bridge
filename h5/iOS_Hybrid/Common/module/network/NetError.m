//
//  NetError.m
//  CloudBox
//
//  Created by YAN Qingyang on 15/12/8.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "NetError.h"
@interface NetError ()

@end

@implementation NetError
- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict{
    if (self == [super initWithDomain:domain code:code userInfo:dict]) {
        self.errMessage=@"服务器访问错误!";
        [self errDescriptionsInit];
        return self;
    }
    return nil;
}

- (instancetype)init
{
    if (self == [super init]) {
        self.errMessage=@"服务器访问错误!";
        [self errDescriptionsInit];
        return self;
        
    }
    return nil;
}

- (void)errDescriptionsInit{
    self.errDescriptions = [@{
                              @"0":@"未知错误",
                              @"-1":@"网络请求未知错误",//NSURLErrorUnknown
                              @"-999":@"NSURLErrorCancelled",
                              @"-1000":@"网络链接错误",//NSURLErrorBadURL
                              @"-1001":@"网络访问超时",//NSURLErrorTimedOut
                              @"-1002":@"不支持的链接",//NSURLErrorUnsupportedURL
                              @"-1003":@"找不到主机",//NSURLErrorCannotFindHost
                              @"-1004":@"不能链接到主机",//NSURLErrorCannotConnectToHost
                              @"-1103":@"数据长度超过最大",//NSURLErrorDataLengthExceedsMaximum
                              @"-1005":@"网络连接丢失",//NSURLErrorNetworkConnectionLost
                              @"-1006":@"DNS查找失败",//NSURLErrorDNSLookupFailed
                              @"-1007":@"HTTP重定向过多",//NSURLErrorHTTPTooManyRedirects
                              @"-1008":@"资源不可用",//NSURLErrorResourceUnavailable
                              @"-1009":@"无法连接网络",//
                              @"-1010":@"重定向到非存在的位置",//NSURLErrorRedirectToNonExistentLocation
                              @"-1011":@"服务器响应错误",//NSURLErrorBadServerResponse
                              @"-1012":@"用户取消认证",//NSURLErrorUserCancelledAuthentication
                              @"-1013":@"用户认证要求",//NSURLErrorUserAuthenticationRequired
                              @"-1014":@"零字节资源",//NSURLErrorZeroByteResource
                              @"-1015":@"不能解码原始数据",//NSURLErrorCannotDecodeRawData
                              @"-1016":@"不能解码内容数据",//NSURLErrorCannotDecodeContentData
                              @"-1017":@"不能解析响应",//NSURLErrorCannotParseResponse
                              @"-1018":@"国际漫游关闭",//NSURLErrorInternationalRoamingOff
                              @"-1019":@"调用活动",//NSURLErrorCallIsActive
                              @"-1020":@"数据不允许",//NSURLErrorDataNotAllowed
                              @"-1021":@"请求体数据流耗尽",//NSURLErrorRequestBodyStreamExhausted
                              @"-1100":@"文件不存在",//NSURLErrorFileDoesNotExist
                              @"-1101":@"文件目录",//NSURLErrorFileIsDirectory
                              @"-1102":@"没有权限阅读文件",//NSURLErrorNoPermissionsToReadFile
                              @"-1200":@"安全连接失败",//NSURLErrorSecureConnectionFailed
                              @"-1201":@"服务器证书有错误的日期",//NSURLErrorServerCertificateHasBadDate
                              @"-1202":@"服务器证书不受信任",//NSURLErrorServerCertificateUntrusted
                              @"-1203":@"服务器证书具有未知根",//NSURLErrorServerCertificateHasUnknownRoot
                              @"-1204":@"服务器证书尚未生效",//NSURLErrorServerCertificateNotYetValid
                              @"-1205":@"被拒绝的客户端证书",//NSURLErrorClientCertificateRejected
                              @"-1206":@"所需的客户端证书",//NSURLErrorClientCertificateRequired
                              @"-2000":@"无法从网络加载",//NSURLErrorCannotLoadFromNetwork
                              @"-3000":@"无法创建文件",//NSURLErrorCannotCreateFile
                              @"-3001":@"无法打开文件",//NSURLErrorCannotOpenFile
                              @"-3002":@"无法关闭文件",//NSURLErrorCannotCloseFile
                              @"-3003":@"无法写入文件",//NSURLErrorCannotWriteToFile
                              @"-3004":@"无法删除文件",//NSURLErrorCannotRemoveFile
                              @"-3005":@"无法移动文件",//NSURLErrorCannotMoveFile
                              @"-3006":@"下载解码中途失败",//NSURLErrorDownloadDecodingFailedMidStream
                              @"-3007":@"下载解码未能完成",//NSURLErrorDownloadDecodingFailedToComplete
                              } copy];

}

- (NSDictionary*)toDictionary{
    NSMutableDictionary *dd=[[NSMutableDictionary alloc]initWithCapacity:2];
    dd[@"errMessage"]=StrFromObj(self.errMessage);
    dd[@"errStatusCode"]=StrFromInt(self.errStatusCode);
    return dd;
}
@end
