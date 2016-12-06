//
//  WebTaskAPI.m
//  HybridApp
//
//  Created by Qingyang on 16/12/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "WebTaskAPI.h"

@implementation WebTaskAPI
#pragma mark - 监听web

#pragma mark - 调取web
+ (void)TaskSearchCall:(WKWebViewJavascriptBridge *)bridge keyword:(NSString*)keyword indus_id:(NSString*)indus_id model:(int)model hosted_fee:(int)hosted_fee order:(TaskListSearchOrder)order page:(NSInteger)page pageSize:(int)pageSize callback:(void (^)(id bridge, id data, NetError *err))callback {
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    
    /*
     可选，语言，默认zh-CN
     zh-CN => 简体中文
     zh-TW => 繁体中文
     en => 英文
     */
    dd[@"lang"] = @"zh-CN";
    
    if (!StrIsEmpty(keyword)) {
        //可选，搜索关键词，搜索范围：需求名称or描述
        dd[@"keyword"]=StrFromObj(keyword);
    }
    
    if (indus_id.integerValue>0) {
        //可选，新版行业编号，用户选一级就传一级的，选二级就传二级的
        dd[@"indus_id"]=StrFromObj(indus_id);
    }
    if (model>=1 && model<=2) {
        //可选，需求类型（1=>悬赏，2=>招标）
        dd[@"model"]=StrFromInt(model);
    }
    if (hosted_fee>=0 && hosted_fee<=1) {
        //可选，是否已托管（0=>未托管，1=>已托管，无默认值，不传该参数则查询所有数据）
        dd[@"hosted_fee"]=StrFromInt(hosted_fee);
    }
    
    //可选，排序规则（ASC或DESC，不区分大小写），默认ASC direction
    dd[@"direction"]=@"DESC";
    
    //可选，排序字段，默认endTime
    switch (order) {
        case TaskListSearchOrderNone:
            dd[@"order"]=@"sub_end_time";
            dd[@"direction"]=@"ASC";
            break;
        case TaskListSearchOrderCreateTime:
            dd[@"order"]=@"create_time";
            break;
        case TaskListSearchOrderEndTime:
            dd[@"order"]=@"sub_end_time";
            dd[@"direction"]=@"ASC";
            break;
        case TaskListSearchOrderTotalBids:
            dd[@"order"]=@"total_bids";
            break;
        case TaskListSearchOrderMaxCash:
            dd[@"order"]=@"max_cash";
            break;
        default:
            dd[@"order"]=@"sub_end_time";
            dd[@"direction"]=@"ASC";
            break;
    }
    
    
    
    //可选，当前搜索第几页，从0开始，默认0
    if (page>=0) {
        dd[@"pno"]=StrFromInt(page);
    }
    
    //可选，每页返回多少条数据，默认10
    if (pageSize>0) {
        dd[@"pageSize"]=StrFromInt(pageSize);
    }
    
    __weak id weakSelf=bridge;
    [bridge callHandler:APP_W_REQ_SEARCH_LIST data:[QGLOBAL toJSONStr:dd] responseCallback:^(id response) {
        if (callback) {
            callback(weakSelf,response,nil);
//            callback(weakSelf,[H5DataCheck checkData:response],nil);
        }
    }];
}

/*
+ (void)TaskSearchCall:(WKWebViewJavascriptBridge *)bridge data:(id)data callback:(H5Callback)callback {
    __weak id weakSelf=bridge;
    [bridge callHandler:APP_W_REQ_SEARCH_LIST data:data responseCallback:^(id response) {
        if (callback) {
            callback(weakSelf,[H5DataCheck checkData:response],nil);
        }
    }];
}
*/
@end
