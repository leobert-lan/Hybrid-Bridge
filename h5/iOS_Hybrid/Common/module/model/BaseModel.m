//
//  BaseModel.m
//  APP
//
//  Created by carret on 15/1/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//
// NSString *nameGetter=[self getProperty:property attributeType:@"G"];

#import "BaseModel.h"
#import <objc/runtime.h>
//#import "DCKeyValueObjectMapping.h"
//#import "DCArrayMapping.h"
//#import "DCParserConfiguration.h"
//#import "QWSandbox.h"
//#import "NSObject+DCKeyValueObjectMapping.h"
//#import "DrugModel.h"

@interface BaseModel()
{
    
}
@end

@implementation BaseModel

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
//    NSLog(@"attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
             //if you want a list of what will be returned for these primitives, search online for
             //"objective-c" "Property Attribute Description Examples"
             //apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
 
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

- (NSString *)getProperty:(objc_property_t)property attributeType:(NSString*)attributeType{
    if (attributeType==nil) {
        return nil;
    }
    NSString *at=[attributeType uppercaseString];
    
    const char *attributes = property_getAttributes(property);
    NSString *atts=[NSString stringWithUTF8String:attributes];
    NSArray *arr=[atts componentsSeparatedByString:@","];
    for (NSString *ss in arr) {
        NSString *attName=[ss substringToIndex:1];
        if ([attName isEqualToString:at]) {
            return [ss substringFromIndex:1];
        }
    }
    return nil;
}


#pragma mark - init
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        [self codeWithCoder:coder decodeEnabled:YES];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self codeWithCoder:coder decodeEnabled:NO];
}



#pragma mark - copy
- (id)copyWithZone:(NSZone*)zone{
    id copyInstance = [[[self class] allocWithZone:zone] init];
    
    Class class = [self class];
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            //get property
            objc_property_t property = properties[i];
            
//            const char *propertyType = getPropertyType(property);
            const char *propertyName = property_getName(property);
            
            NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
//            NSString *type = [NSString stringWithCString:propertyType encoding:NSUTF8StringEncoding];
            NSString *cName= [@"_" stringByAppendingString:name];
            
            //check if read-only
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"])
            {
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                if (iVarRange.location != NSNotFound)
                {
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    if ([iVarName isEqualToString:name] ||
                        [iVarName isEqualToString:cName])
                    {
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
            
            if (!readonly)
            {
        
                [copyInstance setValue:[self valueForKey:name] forKey:name];
            }
        }
        free(properties);
        class = [class superclass];
    }
    
    return copyInstance;
}
#pragma mark - conde & decode
-(void)codeWithCoder:(NSCoder *)coder decodeEnabled:(BOOL)decodeEnabled{
    Class class = [self class];
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            //get property
            objc_property_t property = properties[i];
            
            const char *propertyType = getPropertyType(property);
            const char *propertyName = property_getName(property);
            
            NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            NSString *type = [NSString stringWithCString:propertyType encoding:NSUTF8StringEncoding];
            NSString *cName= [@"_" stringByAppendingString:name];
            
            //check if read-only
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"])
            {
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                if (iVarRange.location != NSNotFound)
                {
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    if ([iVarName isEqualToString:name] ||
                        [iVarName isEqualToString:cName])
                    {
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
    
            if (!readonly)
            {
                //exclude read-only properties
                if ([type length]==1) {
                    if (strcmp(propertyType, @encode(NSInteger)) == 0) {//q,i,l
                        if (decodeEnabled){
                            NSInteger num=[coder decodeIntegerForKey:cName];
                            [self setValue:[NSNumber numberWithInteger:num] forKey:name];
                        }
                        else {
                            //[coder encodeInteger:_tag forKey:@"_tag"];
                            NSInteger value = [[self valueForKey:name]integerValue];
                            [coder encodeInteger:value forKey:cName];
                        }
                    }
                    else if (strcmp(propertyType, @encode(NSUInteger)) == 0) {//[type isEqualToString:@"Q"]
                        
                        if (decodeEnabled){
                            NSUInteger num=[coder decodeIntegerForKey:cName];
                            [self setValue:[NSNumber numberWithUnsignedInteger:num] forKey:name];
                        }
                        else {
                            NSUInteger value = [[self valueForKey:name]unsignedIntegerValue];

                            [coder encodeInteger:value forKey:cName];
                        }
                    }
//                    else if ([type isEqualToString:@"i"]) { //strcmp(propertyType, @encode(NSInteger))
//                        if (decodeEnabled){
//                            int num=[coder decodeIntForKey:cName];
//                            [self setValue:[NSNumber numberWithInt:num] forKey:name];
//                        }
//                        else {
//                            int value = [[self valueForKey:name]intValue];
//                            [coder encodeInt:value forKey:cName];
//                        }
//                    }
                    else if (strcmp(propertyType, @encode(double)) == 0) {//d
                        
                        if (decodeEnabled){
                            double num=[coder decodeDoubleForKey:cName];
                            [self setValue:[NSNumber numberWithDouble:num] forKey:name];
                        }
                        else {
                            double value = [[self valueForKey:name]doubleValue];
                            [coder encodeDouble:value forKey:cName];
                        }
                    }
                    else if ([type isEqualToString:@"f"]) {
                        
                        if (decodeEnabled){
                            float num=[coder decodeFloatForKey:cName];
                            [self setValue:[NSNumber numberWithFloat:num] forKey:name];
                        }
                        else {
                            float value = [[self valueForKey:name]floatValue ];
                            [coder encodeFloat:value forKey:cName];
                        }
                    }
//                    else if ([type isEqualToString:@"l"]) {
//                        
//                        if (decodeEnabled){
//                            NSInteger num=[coder decodeIntegerForKey:cName];
//                            [self setValue:[NSNumber numberWithInteger:num] forKey:name];
//                        }
//                        else {
//                            NSInteger value = [[self valueForKey:name]intValue];
//                            [coder encodeInteger:value forKey:cName];
//                        }
//                    }
                    else if (strcmp(propertyType, @encode(short)) == 0) {//s
                        
                        if (decodeEnabled){
                            short num=[coder decodeIntForKey:cName];
                            [self setValue:[NSNumber numberWithShort:num] forKey:name];
                        }
                        else {
                            int value = [[self valueForKey:name]intValue];
                            [coder encodeInt:value forKey:cName];
                        }
                    }
                    else if (strcmp(propertyType, @encode(BOOL)) == 0 || strcmp(propertyType, @encode(bool)) == 0) {
             
                        if (decodeEnabled){
                            BOOL num=YES;
                            @try {
                                num=[coder decodeBoolForKey:cName];
                            }
                            @catch (NSException *exception) {
                                @try {
                                    int value = [coder decodeIntForKey:cName];
                                    if (value<=0) {
                                        num=false;
                                    }
                                }
                                @catch (NSException *exception) {
                                    //
                                }
                                @finally {
                                    //
                                }
                            }
                            @finally {
                                
                            }
                            
                            [self setValue:[NSNumber numberWithBool:num] forKey:name];
                       
                        }
                        else {
                            BOOL value = YES;
                            @try {
                                value = [[self valueForKey:name]boolValue];
                            }
                            @catch (NSException *exception) {
                                //
                            }
                            @finally {
                                //
                            }
                            [coder encodeBool:value forKey:cName];
                        }
                    }
                    else if (strcmp(propertyType, @encode(char)) == 0) {
                     
                        
                    }
                    
                }
                else {
                    if (decodeEnabled){
                        //self.oid = [coder decodeObjectForKey:@"_oid"];
                        [self setValue:[coder decodeObjectForKey:cName] forKey:name];
                    }
                    else {
                        //[coder encodeObject:_oid forKey:@"_oid"];
                        id value = [self valueForKey:name];
                        [coder encodeObject:value forKey:cName];
                    }
                }
                
            }
        }
        free(properties);
        class = [class superclass];
    }
}

- (NSString *)description
{
    NSString *str=[NSString stringWithFormat:@"\nmodel :%@",[super description]];
//    NSString *str=[NSString stringWithFormat:@"\nmodel :%@ \ntoDictionary :%@",[super description],[[self toDictionary] description]];
    return str;
}

#pragma mark - 字典化
/*
- (NSDictionary*)dictionaryModel{

    return [self dictFromObj:self];
}

- (id)dictFromObj:(id)obj{
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t  *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        const char *propertyType = getPropertyType(prop);
        NSString *type=[NSString stringWithUTF8String:propertyType];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];

        id  value = [obj valueForKey:propName];
        if(value == nil)
        {
            if ([type isEqualToString:@"NSString"]) {
                value = @"";
            }
            else if ([type isEqualToString:@"NSNumber"]) {
                value = @"0";
            }
            else if ([type isEqualToString:@"NSDictionary"]) {
                value = [NSDictionary dictionary];
            }
            else if ([type isEqualToString:@"NSArray"]) {
                value = [NSArray array];
            }
            else
                value = [NSNull null];
        }
        else if([value isKindOfClass:[BaseModel class]])
        {
            value  = [self getValueFromObj:value];
        }
        
        if(![value isEqual:[NSNull null]])
            [dic setObject:value forKey:propName];
    }
    
    free(props);
    return dic;
}

- (id)getValueFromObj:(id)obj{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]])
    {
        return  obj;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getValueFromObj:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return  arr;
    }
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString  *key in  objdic.allKeys)
        {
            [dic setObject:[self getValueFromObj:[objdic objectForKey:key]] forKey:key];
        }
        return  dic;
    }
    return  [self dictFromObj:obj];
}
*/

@end

#pragma mark - 私有model

@implementation BasePrivateModel

+(LKDBHelper*)getUsingLKDBHelperEx:(NSString*)dbName
{
    //这里要用用户唯一id替代@"USER_ID"
    NSString* ret = QGLOBAL.auth.username;
    if ([ret length] > 0) {
        NSString* resultPath = [NSString stringWithFormat:@"private_%@",ret];
        static LKDBHelper* db=nil;
        static NSString* dbName = @"";
        static dispatch_once_t onceToken1;
        if (db) {
            if (![dbName isEqualToString:resultPath])
            {
                db = nil;
                dbName = resultPath;
                NSString* dbpath = [LKDBHelper getDBPathWithDBName:resultPath];
                db = [[LKDBHelper alloc] initWithDBPath:dbpath];
            }
            [db createTableWithModelClass:[self class] tableName:[[self class] getTableName]];
        }
        else
        {
            dbName = resultPath;
            dispatch_once(&onceToken1, ^{
                NSString* dbpath = [LKDBHelper getDBPathWithDBName:resultPath];
                db = [[LKDBHelper alloc] initWithDBPath:dbpath];
            });
            [db createTableWithModelClass:[self class] tableName:[[self class] getTableName]];
        }
        return db;
    }
    return nil;
}
 
@end
