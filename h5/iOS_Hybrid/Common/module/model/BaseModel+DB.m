//
//  BaseModel+DB.m
//  resource
//
//  Created by Yan Qingyang on 15/9/22.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseModel+DB.h"

@implementation BaseModel (DB)

#pragma mark - 数据库
//主键
+ (NSString *)getPrimaryKey
{
    return @"";
}

//获取db instance
+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSString* dbpath = [LKDBHelper getDBPathWithDBName:@"public"];
        
        db = [[LKDBHelper alloc] initWithDBPath:dbpath];
        
    });
    [db createTableWithModelClass:[self class] tableName:[[self class] getTableName]];
    return db;
}

#pragma mark add
+ (BOOL)insertModelToDB:(id)Obj
{
    if (Obj == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    if (![globalHelper insertToDB:Obj]) {
        return NO;
    }
    
    return YES;
    
}

//批量+
+ (void)insertModelListToDB:(NSArray *)models filter:(void (^)(id model, BOOL inseted, BOOL * rollback))filter
{
//    [super insertToDBWithArray:list filter:filter];
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return ;
    }

    [globalHelper executeForTransaction:^BOOL(LKDBHelper *helper) {
        
        BOOL isRollback = NO;
        for (int i=0; i<models.count; i++)
        {
            id obj = [models objectAtIndex:i];
            BOOL inseted = [helper insertToDB:obj];
            if(filter)
            {
                filter(obj,inseted,&isRollback);
            }
            if(isRollback)
            {
                break;
            }
        }
        return (isRollback == NO);
    }];
}

#pragma mark update
//单一数据反复保存用
+ (BOOL)updateModelToDB:(id)Obj
{
    if (Obj == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    JSONModel *mm=[[self class] getModelFromDB];
    if (mm) {
        return [globalHelper updateToDB:Obj where:[NSString stringWithFormat:@" rowid=%ld", (long)mm.rowid]];
    }
    else {
        return [globalHelper insertToDB:Obj];
    }
    
}

//要有PrimaryKey，且唯一
+ (BOOL)updateModelToDB:(id)Obj key:(NSString *)akey
{
    NSString *key=StrFromObj(akey);
    
    if (Obj == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", [[self class] getPrimaryKey], key];
    
    if (key && [[self class] getModelFromDBWithKey:key]) {
        return [globalHelper updateToDB:Obj where:where];
    }
    else
    {
        return [globalHelper insertToDB:Obj];
    }
}

+ (BOOL)updateModelToDB:(id)Obj where:(NSString *)where
{
    if (Obj == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    if (where && [[self class] getModelFromDBWithWhere:where]) {
        return [globalHelper updateToDB:Obj where:where];
    }
    else
    {
        //插入新数据
        return [globalHelper insertToDB:Obj];
    }
}

+ (BOOL)updateModelSetToDB:(NSString*)set key:(NSString *)akey
{
    NSString *key=StrFromObj(akey);
    
    if (key.length == 0)
        return NO;
    if (set == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", [[self class] getPrimaryKey], key];
    
    if (key && [[self class] getModelFromDBWithKey:key]) {
        return [globalHelper updateToDB:[self class] set:set where:where];
    }
    else {
        return NO;
    }
}

+ (BOOL)updateModelSetToDB:(NSString*)set where:(NSString *)where
{
    if (where.length == 0)
        return NO;
    
    if (set == nil)
        return NO;
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    
    if (globalHelper == nil) {
        return NO;
    }
    
    return [globalHelper updateToDB:[self class] set:set where:where];
}

#pragma mark select
+ (NSInteger)getCountFromDBWithWhere:(NSString *)where
{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return 0;
    }
    return [globalHelper rowCount:[self class] where:where];
}

+ (id)getModelFromDB
{
    return [self getModelFromDBWithWhere:nil orderBy:nil];
}

//没有key，返回数据库内一条数据
+ (id)getModelFromDBWithKey:(NSString *)akey
{
    NSString *key=StrFromObj(akey);
    
    NSString *where = nil;
    if (akey && key.length)
        where = [NSString stringWithFormat:@"%@ = '%@'", [[self class] getPrimaryKey], key];
    
    return [self getModelFromDBWithWhere:where orderBy:nil];
}

+ (id)getModelFromDBWithWhere:(NSString *)where
{
    return [self getModelFromDBWithWhere:where orderBy:nil];
}

+ (id)getModelFromDBWithWhere:(NSString *)where orderBy:(NSString*)value
{
    id object = [[self alloc] init];
    
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return nil;
    }
    
    if (where == nil || where.length == 0)
    {
        object = [globalHelper searchSingle:[self class] where:nil orderBy:value];
    }
    else
    {
        object = [globalHelper searchSingle:[self class] where:where orderBy:value];
    }
    

    return object;
}

#pragma mark 多条数据
+ (NSArray *)getModelListFromDBWithWhere:(NSString *)where
{
    return [self getModelListFromDBWithWhere:where orderBy:nil];
}

+ (NSArray *)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)orderBy
{
    return [self getModelListFromDBWithWhere:where orderBy:orderBy offset:0 count:0];
}

+ (NSArray*)getModelListFromDBWithWhere:(NSString *)where
                            orderBy:(NSString*)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return nil;
    }
    NSInteger noffset = offset>0?offset:0;
    NSInteger ncount = count>0?count:0;
    
    NSString *wh = where.length?where:nil;
    NSString *ob = orderBy.length?orderBy:nil;
    
    return [globalHelper search:[self class] where:wh orderBy:ob offset:noffset count:ncount];
}

+ (void)getModelListFromDBWithWhere:(NSString *)where callback:(void (^)(NSMutableArray *))block
{
    return [self getModelListFromDBWithWhere:where orderBy:nil callback:block];
}

+ (void)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)orderBy callback:(void (^)(NSMutableArray *))block
{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return;
    }
    
    NSString *wh = where.length?where:nil;
    NSString *ob = orderBy.length?orderBy:nil;
    
    [globalHelper search:[self class] where:wh orderBy:ob offset:0 count:0 callback:block];
}

+ (void)getModelListFromDBWithWhere:(NSString *)where orderBy:(NSString*)orderBy count:(NSInteger)count callback:(void (^)(NSMutableArray *))block
{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return;
    }
    
    NSString *wh = where.length?where:nil;
    NSString *ob = orderBy.length?orderBy:nil;
    
    [globalHelper search:[self class] where:wh orderBy:ob offset:0 count:count callback:block];
}
#pragma mark del
+ (BOOL)deleteModelFromDB
{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return  NO;
    }
    return [globalHelper dropTableWithClass:[self class]];
}

+ (BOOL)deleteModelFromDBWithKey:(NSString *)akey
{
    NSString *key=StrFromObj(akey);

    if (akey == nil || key.length == 0)
        return NO;
    
    NSString * where = [NSString stringWithFormat:@"%@ = '%@'", [[self class] getPrimaryKey], key];
    return [self deleteModelFromDBWithWhere:where];
}

+ (BOOL)deleteModelFromDBWithWhere:(NSString *)where
{
    LKDBHelper *globalHelper = [[self class] getUsingLKDBHelperEx:nil];
    if (globalHelper == nil) {
        return NO;
    }
    
    if (where == nil || where.length == 0)
        return NO;
    
    return [globalHelper deleteWithClass:[self class] where:where];
}


#pragma mark - UserDefault
- (BOOL)setToUserDefault:(NSString *)objId
{
    return [QYUserDefault setObject:self key:objId];
}

+ (id)getFromUserDefault:(NSString *)objId
{
    return [QYUserDefault getObjectBy:objId];
}

@end
