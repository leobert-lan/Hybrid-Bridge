//
//  ActivityCmtModel.h
//  cyy_task
//
//  Created by Qingyang on 16/11/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityCmtModel : BaseModel
@property (nonatomic,retain,getter=oid) NSString<Optional> *id;
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *zans;
@property (nonatomic,retain) NSString<Optional> *content;
@property (nonatomic,retain) NSString<Optional> *already_zan;//当前访问者是否已经对该评论点赞（0=>未点赞，1=>已点赞）
@property (nonatomic,retain) NSString<Optional> *created_at;//评论提交日期
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSString<Optional> *ranking;//发表评论者排名
@property (nonatomic,retain) NSString<Optional> *status;//评论状态（0=>待处理，1=>通过，2=>驳回）

@property (nonatomic,retain) NSNumber<Optional> * isOpen;
@end
