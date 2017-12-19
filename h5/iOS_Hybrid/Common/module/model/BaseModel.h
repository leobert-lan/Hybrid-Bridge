
/*!
 @header BaseModel.h
 @abstract BaseModel是用来处理网络数据传输中的ORM的model基类
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"
#import "JSONModelLib.h"

/*!
 @protocol
 @brief model基类可以将数据直接转换成对象同时支持将对象转换成字典进行数据交互
 @discussion
 */


@interface BaseModel : JSONModel<NSCopying>






//+ (NSDictionary*)dataTOdic:(id)obj;



//+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//+ (void)print:(id)obj;

//- (BOOL)setToUserDefault:(NSString *)objId;
//+ (id)getFromUserDefault:(NSString *)objId;


//- (NSDictionary*)dictionaryModel;



 
@end



@interface BasePrivateModel : BaseModel

+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName;
@end