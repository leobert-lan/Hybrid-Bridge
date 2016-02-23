//
//  BaseModel+DB.h
//  resource
//
//  Created by Yan Qingyang on 15/9/22.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseModel.h"

@interface BaseModel (DB)
//主键
+ (NSString *)getPrimaryKey;

//获取db
+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName;

#pragma mark add
+ (BOOL)insertModelToDB:(id)Obj;
//批量+
+ (void)insertModelListToDB:(NSArray *)list filter:(void (^)(id model, BOOL inseted, BOOL * rollback))filter;

#pragma mark update
+ (BOOL)updateModelToDB:(id)Obj;//只更新第一条
+ (BOOL)updateModelToDB:(id)Obj key:(NSString *)key;//key为空，默认主键是key
+ (BOOL)updateModelToDB:(id)Obj where:(NSString *)where;
+ (BOOL)updateModelSetToDB:(NSString*)set key:(NSString *)key;
+ (BOOL)updateModelSetToDB:(NSString*)set where:(NSString *)where;

#pragma mark select
+ (NSInteger)getCountFromDBWithWhere:(NSString *)where;
+ (id)getModelFromDB;//只取第一条
+ (id)getModelFromDBWithKey:(NSString *)akey;//参数不要空
+ (id)getModelFromDBWithWhere:(NSString *)where;//参数不要空
+ (id)getModelFromDBWithWhere:(NSString *)where orderBy:(NSString*)value;

#pragma mark 多条数据
+ (NSArray *)getModelListFromDBWithWhere:(NSString *)where;
+ (NSArray *)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)value;
//分页数据
+ (NSArray*)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)orderBy offset:(NSInteger)offset count:(NSInteger)count;
//异步请求
+ (void)getModelListFromDBWithWhere:(NSString *)where callback:(void (^)(NSMutableArray *list))block;
+ (void)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)value callback:(void (^)(NSMutableArray *list))block;
+ (void)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)orderBy count:(NSInteger)count callback:(void (^)(NSMutableArray *))block;
#pragma mark del
+ (BOOL)deleteModelFromDB;
+ (BOOL)deleteModelFromDBWithKey:(NSString *)key;
+ (BOOL)deleteModelFromDBWithWhere:(NSString *)where;

- (BOOL)setToUserDefault:(NSString *)objId;
+ (id)getFromUserDefault:(NSString *)objId;
@end
