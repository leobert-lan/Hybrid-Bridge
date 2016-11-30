//
//  TaskModel.m
//  cyy_task
//
//  Created by Qingyang on 16/8/9.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskModel.h"
@implementation SearchHistoryModel
+ (NSString *)getPrimaryKey{
    return @"keyword";
}

@end



@implementation SearchHistoryHotModel


@end

//////////////////////
@implementation TaskSimpleModel
@end

@implementation TaskModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"selected"]) return YES;
//    if ([propertyName isEqualToString: @"selectionEnabled"]) return YES;
    return NO;
}
@end

@implementation TaskDetailWorksModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"worksdescription",@"id":@"WorksId"}];
}
@end

@implementation TaskDetailModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"taskDescription"}];
}


@end
@implementation publisherModel

@end
@implementation favoredModel

@end

@implementation TaskFileModel

@end
@implementation TaskWorkListModel

@end
@implementation EvaluateModel

@end