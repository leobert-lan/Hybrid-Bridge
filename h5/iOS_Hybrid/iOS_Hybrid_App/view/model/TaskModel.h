//
//  TaskModel.h
//  cyy_task
//
//  Created by Qingyang on 16/8/9.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"
//历史搜索关键字，不分用户，共用，非BasePrivateModel
@interface SearchHistoryModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *keyword;
@property (nonatomic,retain) NSString<Optional> *datetime;
@end



//热门搜索
@interface SearchHistoryHotModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *search_key;
@property (nonatomic,retain) NSString<Optional> *count;
@end


@interface TaskSimpleModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *task_bn;
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *real_cash;
@property (nonatomic,retain) NSString<Optional> *title;
@end

//@protocol  NSString
//@end

@interface TaskModel : BaseModel
@property (nonatomic,assign) BOOL selected;

@property (nonatomic,retain) NSString<Optional> *create_time;
@property (nonatomic,retain) NSString<Optional> *model;
@property (nonatomic,retain) NSString<Optional> *model_name;
@property (nonatomic,retain) NSString<Optional> *status;
@property (nonatomic,retain) NSString<Optional> *sub_end_time;
@property (nonatomic,retain) NSString<Optional> *sub_end_time_alias;//交稿剩余时间格式转换
@property (nonatomic,retain) NSString<Optional> *task_bn;
@property (nonatomic,retain) NSString<Optional> *task_cash;
@property (nonatomic,retain) NSString<Optional> *max_cash;
@property (nonatomic,retain) NSString<Optional> *min_cash;
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *top;
@property (nonatomic,retain) NSString<Optional> *total_bids;
@property (nonatomic,retain) NSString<Optional> *urgent;
@property (nonatomic,retain) NSString<Optional> *mobile;//发布者联系方式
@property (nonatomic,retain) NSString<Optional> *publisher;//需求发布者用户名
@property (nonatomic,retain) NSString<Optional> *task_status;//需求状态
@property (nonatomic,retain) NSString<Optional> *work_status;//稿件状态
@property (nonatomic,retain) NSString<Optional> *is_mark;//招标类型（1=>明标，2=>暗标）
@property (nonatomic,retain) NSString<Optional> *step;//阶段（1=>发布，2=>投稿，3=>选稿，4=>公示，5=>制作，6=>结束）
@property (nonatomic,retain) NSString<Optional> *status_alias;//需求状态别名
@property (nonatomic,retain) NSArray<Optional>  *operate;//需求操作 数字数组
@end



@interface publisherModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *avatar;
@end
@interface favoredModel : BaseModel
@property (nonatomic,retain) NSNumber<Optional> *publisher;
@property (nonatomic,retain) NSNumber<Optional> *task;
@end

@interface TaskFileModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *file_ext;
@property (nonatomic,retain) NSString<Optional> *file_name;
@property (nonatomic,retain) NSString<Optional> *file_path;
@property (nonatomic,retain) NSString<Optional> *file_size;
@property (nonatomic,retain) NSString<Optional> *file_size_alias;
@property (nonatomic,retain) NSString<Optional> *mime;
@property (nonatomic,retain) NSString<Optional> *show_preview;
@property (nonatomic,retain) NSString<Optional> *url_preview;
@property (nonatomic,retain) NSString<Optional> *url_thumbnail;
@property (nonatomic,retain) NSString<Optional> *url_download;
@end
@protocol TaskFileModel <NSObject>


@end
@interface TaskDetailWorksModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *WorksId;
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *worksdescription;
@property (nonatomic,retain) NSString<Optional> *create_time;
@property (nonatomic,retain) NSString<Optional> *is_mark;
@property (nonatomic,retain) NSString<Optional> *attachments;
@property (nonatomic,retain) NSString<Optional> *status;
@property (nonatomic,retain) NSString<Optional> *status_alias;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSNumber<Optional> *isSelct;
@property (nonatomic,retain) NSString<Optional> *price;
@property (nonatomic,retain) NSString<Optional> *days;
@property (nonatomic,retain) TaskFileModel<Optional> *work_ext;
@end
@protocol TaskDetailWorksModel <NSObject>


@end

@interface TaskDetailModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *task_bn;
@property (nonatomic,retain) NSString<Optional> *is_mark;
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *task_cash;
@property (nonatomic,retain) NSString<Optional> *min_cash;
@property (nonatomic,retain) NSString<Optional> *max_cash;
@property (nonatomic,retain) NSString<Optional> *real_cash;
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *mobile;
@property (nonatomic,retain) NSString<Optional> *model;
@property (nonatomic,retain) NSString<Optional> *status;
@property (nonatomic,retain) NSString<Optional> *step;
@property (nonatomic,retain) NSString<Optional> *is_select;
@property (nonatomic,retain) NSString<Optional> *create_time;
@property (nonatomic,retain) NSString<Optional> *total_bids;
@property (nonatomic,retain) NSString<Optional> *taskDescription;
@property (nonatomic,retain) NSString<Optional> *sub_end_time;
@property (nonatomic,retain) NSString<Optional> *model_name;
@property (nonatomic,retain) NSString<Optional> *status_alias;
@property (nonatomic,retain) NSString<Optional> *sub_end_time_alias;
@property (nonatomic,retain) NSString<Optional> *deposit;
@property (nonatomic,retain) NSMutableArray<Optional,TaskFileModel> *attachment;
@property (nonatomic,retain) publisherModel<Optional> *publisher;
@property (nonatomic,retain) favoredModel<Optional> *favored;
@property (nonatomic,retain) NSMutableArray<Optional,TaskDetailWorksModel> *works;
@property (nonatomic,retain) NSMutableArray<Optional> *operate;
@property (nonatomic,retain) NSString<Optional> *link;
@end
@interface TaskWorkListModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *total_bids;
@property (nonatomic,retain) NSMutableArray<Optional,TaskDetailWorksModel> *works;
@end

@interface EvaluateModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *aid;
@property (nonatomic,retain) NSString<Optional> *name;
@end
