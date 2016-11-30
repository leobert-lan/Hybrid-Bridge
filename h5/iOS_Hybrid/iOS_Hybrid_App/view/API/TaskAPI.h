//
//  TaskAPI.h
//  cyy_task
//
//  Created by Qingyang on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskAPI : NSObject
typedef NS_ENUM(NSInteger, TaskListStyle){
    TaskListStyleNone = 0,
    TaskListStyleRich,
    TaskListStyleHot
};

/*
createTime => 发布时间
endTime => 交稿截止时间
totalBids => 投稿数
maxCash => 金额
*/
typedef NS_ENUM(NSInteger, TaskListSearchOrder){
    TaskListSearchOrderNone = 0,
    TaskListSearchOrderCreateTime,
    TaskListSearchOrderEndTime,
    TaskListSearchOrderTotalBids,
    TaskListSearchOrderMaxCash,
};

//1=>发布，2=>投稿，3=>选稿，4=>公示，5=>制作，6=>结束 1=> release, 2=> submission, 3=> draft, 4=> publicity, 5=> production, 6=> end
typedef NS_ENUM(NSInteger, TaskStepType){
    TaskStepTypeNone = 0,
    TaskStepTypeRelease,
    TaskStepTypeSubmission,
    TaskStepTypeDraft,
    TaskStepTypePublicity,
    TaskStepTypeProduction,
    TaskStepTypeEnd,
};

//（all=>全部，bidding=>已投标，selected=>已中标，deliver=>交付中，to_evaluate=>待评价）
typedef NS_ENUM(NSInteger, TaskUndertakeType){
    TaskUndertakeTypeAll = 0,
    TaskUndertakeTypeBidding,
    TaskUndertakeTypeSelected,
    TaskUndertakeTypeDelive,
    TaskUndertakeTypeTo_evaluate,
};

//投稿状态（1=>未中标，2=>备选，3=>中标，4=>被举报）(1=> did not win the bid, 2=> alternative, 3=> won the bid, 4=> was reported)
typedef NS_ENUM(NSInteger, TaskWorkStatusType){
    TaskWorkStatusTypeNone = 0,
    TaskWorkStatusTypeNoBind = 1,
    TaskWorkStatusTypeAlternative,
    TaskWorkStatusTypeBind,
    TaskWorkStatusTypeReported,
};



#pragma mark - 最火／壕任务 10条
+ (void)TaskListStyle:(TaskListStyle)style success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;

#pragma mark - 搜索
+ (void)SearchTaskList:(NSString*)keyword indus_id:(NSString*)indus_id model:(int)model hosted_fee:(int)hosted_fee order:(TaskListSearchOrder)order page:(NSInteger)page pageSize:(int)pageSize
               success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 热门搜索
+ (void)SearchTaskHotHistory:(NSString*)keyword limit:(int)limit success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;

#pragma mark - 任务详情
+ (void)TaskDetailsWithTaskbn:(NSString *)taskbn html2text:(BOOL)html2text success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 稿件列表
+ (void)TaskDetailWorkListWithTaskbn:(NSString *)taskbn offset:(int)offset success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 我承接的需求列表
+ (void)TakeTaskList:(NSString*)username type:(TaskUndertakeType)type offset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 我收藏的需求列表
+ (void)FavoTaskList:(NSString*)username offset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 添加收藏
+ (void)FavorAddTaskBn:(NSString *)taskBn success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 取消收藏
+ (void)FavorDeleteTaskBn:(NSArray *)taskBns success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 猜你喜欢需求列表
+ (void)PreferTaskList:(NSString*)username offset:(NSInteger)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 获取评价配置项
+ (void)EvaluateConfigTaskbn:(NSString *)taskbn success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 评价
+ (void)EvaluateTaskbn:(NSString *)taskbn items:(id)items content:(NSString *)content success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 需求承接校验
+ (void)SubmissionCheckSuccess:(void (^)(id model))success failure:(void (^)(NetError* err))failure;
#pragma mark - 需求承接
+ (void)SubmissionTaskbn:(NSString *)taskbn description:(NSString *)description attachments:(NSString *)attachments attachment_name:(NSString *)attachment_name days:(NSString *)days price:(NSString *)price isMArk:(NSString *)isMark type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure;
#pragma mark - 签署协议
+ (void)ProtocolTaskbn:(NSString *)taskbn flagAgree:(BOOL)flagAgree success:(void (^)(id))success failure:(void (^)(id))failure;
@end
