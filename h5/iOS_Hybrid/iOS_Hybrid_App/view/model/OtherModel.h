//
//  OtherModel.h
//  cyy_task
//
//  Created by Qingyang on 16/8/26.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"
/*
id 	Number 分类编号
root 	Number 所属根父级编号
name 	Number 分类名称
lft 	Number 左侧节点
rgt 	Number 右侧节点
lvl 	Number 级别(0=>一级 1=>二级 …)
icon 	Number 分类图标
 */
@interface IndustryModel : BaseModel
@property (nonatomic,retain,getter=oid) NSString<Optional> *id;
@property (nonatomic,retain) NSString<Optional> *root;
@property (nonatomic,retain) NSString<Optional> *name;
@property (nonatomic,retain) NSString<Optional> *lft;
@property (nonatomic,retain) NSString<Optional> *rgt;
@property (nonatomic,retain) NSString<Optional> *lvl;
@property (nonatomic,retain) NSString<Optional> *icon;
@property (nonatomic,retain) NSMutableArray<Optional> *list;
@end

//搜索类型 条件筛选菜单数据
@interface CollectionItemTypeModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *oid;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,retain) NSString<Optional> *tag;
@property (nonatomic,retain) NSMutableArray<Optional> *list;
@end

//广告
@interface BannerModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *link;
@property (nonatomic,retain) NSString<Optional> *target;
@property (nonatomic,retain) NSString<Optional> *image;

@end
// 上传
@interface UploadModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *file_id;
@property (nonatomic,retain) NSString<Optional> *file_url;
@end
