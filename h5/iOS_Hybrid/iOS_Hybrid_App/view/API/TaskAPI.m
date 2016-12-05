//
//  TaskAPI.m
//  cyy_task
//
//  Created by Qingyang on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskAPI.h"

@implementation TaskAPI
#pragma mark - hot/rich
+ (void)TaskListStyle:(TaskListStyle)style success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    NSString *url;
    switch (style) {
        case TaskListStyleRich:
            url=API_TaskListRich;
            break;
        case TaskListStyleHot:
            url=API_TaskListHot;
            break;
        default:
            break;
    }
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"limit"] = @"10";//固定10条
    dd[@"lang"] = @"zh-CN";
    /*
    可选，语言，默认zh-CN
    zh-CN => 简体中文
    zh-TW => 繁体中文
    en => 英文
    */
    [HTTPConnecting post:url params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[TaskModel arrayOfModelsFromDictionaries:responseObj error:&err];
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
                
        }

        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - search
+ (void)SearchTaskList:(NSString*)keyword indus_id:(NSString*)indus_id model:(int)model hosted_fee:(int)hosted_fee order:(TaskListSearchOrder)order page:(NSInteger)page pageSize:(int)pageSize
                  success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    /*
    可选，招标类型（1=>明标，2=>暗标），这个参数传了就不要传model参数 indus_id 	Number
    
    可选，赏金额度最小值 minCash 	Number
    
    可选，赏金额度最大值 maxCash 	Number
    
    可选，交稿截止时间，秒级时间戳 endTime 	Number

    可选，需求状态（1=>进行中，2=>已选标，3=>已结束）status 	Number
    进行中对应投稿阶段
    已选标包含如下阶段：选稿，公示，制作
    */
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
    
    [MobClick event:UMSearchCondition attributes:dd];
    
    [HTTPConnecting post:API_SearchTaskList params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[TaskModel arrayOfModelsFromDictionaries:responseObj error:&err];

            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
//        if (success) {
//            success (nil);
//        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 热门搜索
+ (void)SearchTaskHotHistory:(NSString*)keyword limit:(int)limit success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (!StrIsEmpty(keyword)) {
        //可选，搜索关键词，搜索范围：需求名称or描述
        dd[@"keyword"]=StrFromObj(keyword);
    }
    //可选，每页返回多少条数据，默认6
    if (limit>0) {
        dd[@"limit"]=StrFromInt(limit);
    }
    else {
        dd[@"limit"]=@"6";
    }
 
    dd[@"lang"] = @"zh-CN";
    
    [HTTPConnecting get:API_SearchTaskHistory params:dd success:^(id responseObj) {
//                DLog(@"%@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[SearchHistoryHotModel arrayOfModelsFromDictionaries:responseObj error:&err];

            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}



#pragma mark - 需求详情
+ (void)TaskDetailsWithTaskbn:(NSString *)taskbn html2text:(BOOL)html2text success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"task_bn"] = StrFromObj(taskbn);
    dd[@"html2text"] = StrFromInt(html2text);
    [HTTPConnecting get:API_TaskDetail params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSDictionary *dict = responseObj;
        NSError* err = nil;
        TaskDetailModel *mm = [[TaskDetailModel alloc] initWithDictionary:dict error:&err];
        if (success) {
            success(mm);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark - 稿件列表
+ (void)TaskDetailWorkListWithTaskbn:(NSString *)taskbn offset:(int)offset success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"task_bn"] = StrFromObj(taskbn);
    //可选，每页返回多少条数据
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    dd[@"limit"]=StrFromInt(kPageSize);
    [HTTPConnecting get:API_TaskWorkList params:dd success:^(id responseObj) {
        NSDictionary *dict = responseObj;
//        DLog(@"%@",dict);
        NSError* err = nil;
        TaskWorkListModel *mm = [[TaskWorkListModel alloc] initWithDictionary:dict error:&err];
        if (success) {
            success(mm);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}


#pragma mark - 我承接的需求列表
+ (void)TakeTaskList:(NSString*)username type:(TaskUndertakeType)type offset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (StrIsEmpty(username)) {
        //可选，搜索关键词，搜索范围：需求名称or描述
        dd[@"username"]=StrFromObj(QGLOBAL.auth.username);
    }
    //默认all （all=>全部，bidding=>已投标，selected=>已中标，deliver=>交付中，to_evaluate=>待评价）
    switch (type) {
        case TaskUndertakeTypeAll:
            dd[@"type"]=@"all";
            break;
        case TaskUndertakeTypeBidding:
            dd[@"type"]=@"bidding";
            break;
        case TaskUndertakeTypeSelected:
            dd[@"type"]=@"selected";
            break;
        case TaskUndertakeTypeDelive:
            dd[@"type"]=@"deliver";
            break;
        case TaskUndertakeTypeTo_evaluate:
            dd[@"type"]=@"to_evaluate";
            break;
        default:
            dd[@"type"]=@"all";
            break;
    }
    
    //可选，每页返回多少条数据，默认6
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    
    dd[@"limit"]=StrFromInt(kPageSize);
    dd[@"lang"] = @"zh-CN";
    
    [HTTPConnecting get:API_MyTakeTask params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[TaskModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark - 我收藏的需求列表
+ (void)FavoTaskList:(NSString*)username offset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (StrIsEmpty(username)) {
        //可选，搜索关键词，搜索范围：需求名称or描述
        dd[@"username"]=StrFromObj(QGLOBAL.auth.username);
    }
    //可选，数据偏移量，默认0
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    
    dd[@"limit"]=StrFromInt(kPageSize);
    dd[@"lang"] = @"zh-CN";
    
    [HTTPConnecting get:API_MyFavoTask params:dd success:^(id responseObj) {
//                        DLog(@"FFF %@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[TaskModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 添加收藏
+ (void)FavorAddTaskBn:(NSString *)taskBn success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"task_bn"] = StrFromObj(taskBn);
    [HTTPConnecting post:API_FavorAdd params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark - 取消收藏
+ (void)FavorDeleteTaskBn:(NSArray *)taskBns success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
        //可选，搜索关键词，搜索范围：需求名称or描述
    dd[@"username"]=QGLOBAL.auth.username;
    NSString *str=nil;
    for (id obj in taskBns) {
        if (str==nil) {
            str=[NSString stringWithFormat:@"%@",StrFromObj(obj)];
        }
        else
            str=[NSString stringWithFormat:@"%@,%@",str,StrFromObj(obj)];
    }
    dd[@"task_bn"] = StrFromObj(str);
    [HTTPConnecting get:API_FavorDelete params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 猜你喜欢需求列表
+ (void)PreferTaskList:(NSString*)username offset:(NSInteger)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure
{
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (StrIsEmpty(username)) {
        //可选，搜索关键词，搜索范围：需求名称or描述
        dd[@"username"]=StrFromObj(QGLOBAL.auth.username);
    }
    else dd[@"username"]=StrFromObj(username);
    
    //可选，数据偏移量，默认0
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    
    dd[@"limit"]=StrFromInt(kPageSize);
    dd[@"lang"] = @"zh-CN";
    
    [HTTPConnecting get:API_TaskPrefer params:dd success:^(id responseObj) {
//                        DLog(@"%@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[TaskModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 获取评价配置项
+ (void)EvaluateConfigTaskbn:(NSString *)taskbn success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"task_bn"] = StrFromObj(taskbn);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_EvaluateConfig params:dd success:^(id responseObj) {
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[EvaluateModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark - 评价
+ (void)EvaluateTaskbn:(NSString *)taskbn items:(id)items content:(NSString *)content success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"task_bn"] = StrFromObj(taskbn);
    dd[@"items"] = items;
    dd[@"content"] = StrFromObj(content);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting post:API_Evaluate params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 需求承接校验
+ (void)SubmissionCheckSuccess:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_SubmissionCheck params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 需求承接
+ (void)SubmissionTaskbn:(NSString *)taskbn description:(NSString *)description attachments:(NSString *)attachments attachment_name:(NSString *)attachment_name days:(NSString *)days price:(NSString *)price isMArk:(NSString *)isMark type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"task_bn"] = StrFromObj(taskbn);
    dd[@"description"] = StrFromObj(description);
    if ([attachments isEqualToString:@""] || attachments == nil || [attachments isEqualToString:@"null"]) {
    }else{
        dd[@"attachments"] = StrFromObj(attachments);
        dd[@"attachment_name"] = StrFromObj(attachment_name);
    }
    
    dd[@"is_mark"] = StrFromObj(isMark);
    dd[@"lang"] = @"zh-CN";
    switch (type) {
        case 1:
            dd[@"days"] = StrFromObj(days);
            break;
        case 2:
            dd[@"days"] = StrFromObj(days);
            dd[@"price"] = StrFromObj(price);
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    [HTTPConnecting post:API_Submission params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 签署协议
+ (void)ProtocolTaskbn:(NSString *)taskbn flagAgree:(BOOL)flagAgree success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"]=QGLOBAL.auth.username;
    dd[@"task_bn"] = StrFromObj(taskbn);
    dd[@"flag_agree"] = StrFromInt(flagAgree);
    [HTTPConnecting post:API_Protocol params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
