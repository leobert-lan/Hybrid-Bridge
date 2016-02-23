//
//  GlobalManager.m
//  APP
//
//  Created by carret on 15/1/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "GlobalManager.h"
#import "SystemMacro.h"
#import "SDVersion.h"
//#import "SDiOSVersion.h"
#import <AudioToolbox/AudioToolbox.h>
@interface GlobalManager(){
    Reachability *reachability;
    
}

@end
@implementation GlobalManager
+ (instancetype)sharedInstance
{
    InstanceByBlock(^{
        return [[self alloc] init];
    });
}

- (BOOL)console {
#ifdef CONSOLE
    return YES;
#else
    return NO;
#endif
    
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (BOOL)iPhone {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? YES : NO;
}

- (BOOL)iPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? YES : NO;
}

#pragma mark 判断
- (BOOL)isNULL:(id)obj{
    if (obj==nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)object:(id)obj isClass:(Class)aClass {
    if (![self isNULL:obj] && [obj isKindOfClass:aClass]) {
        return YES;
    }
    return NO;
}

- (BOOL)isStringEmpty:(id)obj{
    if (obj==nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj length]==0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPhoneNumber:(NSString*)text
{
    NSString * regex = @"^([1])([0-9]{10})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmailAddress:(NSString*)text
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}
#pragma mark 文件
- (NSString *)stringFromFileSize:(double)theSize
{
    double floatSize = theSize;
    if (theSize<1023)
        return([NSString stringWithFormat:@"%iB",(int)theSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1fK",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1fM",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1fG",floatSize]);
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1fT",floatSize]);
}
#pragma mark 时间格式
- (NSString*)dateToStr:(NSDate*)date zone:(NSString*)zone local:(NSString*)local format:(NSString*)format{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone;
    
    //根据本地标识符创建本地化对象, 对于时间显示格式, 比如“星期一/Monday/Lundi”
    if (local!=nil)
        df.locale=[[NSLocale alloc] initWithLocaleIdentifier:local];//@"zh_CN"
    
    //获取并设置时间的时区,获取系统时间
    if (zone==nil)
        timeZone = [NSTimeZone systemTimeZone];
    else
        timeZone = [NSTimeZone timeZoneWithName:zone];//@"Asia/Shanghai"
    [df setTimeZone:timeZone];
    
    if (format==nil)
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//附加时区 @"yyyy-MM-dd'T'HH:mm:ssZ"
    else
        [df setDateFormat:format];
    
    return [df stringFromDate:date];
}

- (NSString*)dateToStr:(NSDate*)date format:(NSString*)format{
    return [self dateToStr:date zone:nil local:nil format:format];
}

#pragma mark 时间戳
- (NSString*)dateToTimeInterval:(NSDate*)date {
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

- (NSDate*)dateFromTimeInterval:(NSString*)timestamp {
    NSDate *date = nil;
    if (timestamp != nil) {
        double value = [timestamp doubleValue];
        //如果计数包含毫秒
        if (value>100000000000) {
            value/=1000;
        }
        if (value != 0) {
            date = [NSDate dateWithTimeIntervalSince1970:value];
        }
    }
    return date;
}
#pragma mark 时间比较
//+ (int)compareDayDate1:(NSDate *)date1 date2:(NSDate*)date2 {
//    if (date1==nil||date2==nil)  return NO;
//    
//    NSDate *aDt=[self dateFormatYearDay:date1];
//    NSDate *cDt=[self dateFormatYearDay:date2];
//    
//    //早于date2时返回NSOrderedAscending -1
//    //晚于date2时返回NSOrderedDescending 1
//    //NSOrderedSame 0
//    return (int)[aDt compare:cDt];
//}
//
//+ (BOOL)isSameDayDate1:(NSDate *)date1 date2:(NSDate*)date2 {
//    if (date1==nil||date2==nil)  return NO;
//    
//    NSDate *aDt=[self dateFormatYearDay:date1];
//    NSDate *cDt=[self dateFormatYearDay:date2];
//    
//    //晚于cDt时返回NSOrderedDescending
//    //早于cDt时返回NSOrderedAscending
//    if ([aDt compare:cDt]==NSOrderedSame) {
//        return YES;
//    }
//    return NO;
//}
//
//+ (NSDate*)dateFormatYearDay:(NSDate*)date{
//    if (date==nil) return nil;
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags=NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
//    NSDateComponents *components=[calendar components:unitFlags
//                                             fromDate:date];
//    NSDate *nyr=[calendar dateFromComponents:components];
//    return nyr;
//}

+ (NSDate*)dateFromString:(NSString*)str withFormat:(NSString*)format {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (format==nil)
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [df setDateFormat:format];
    
    return [df dateFromString:str];
}

+ (NSString *)dateDiff:(NSDate *)date{
    double ti = [date timeIntervalSince1970];
    double now = [[NSDate date] timeIntervalSince1970];
    
    ti=now-ti;
    if (ti < 60) {
        return @"刚刚";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d分钟前", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        
        return[NSString stringWithFormat:@"%d小时前", diff];
    } else {//if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d天前", diff];
    }
}

+ (NSString *)dateDiff:(NSString *)origDate now:(NSString *)nowDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //[df setTimeZone:timeZone];
    
    NSDate *convertedDate = [df dateFromString:origDate];
    double ti = [convertedDate timeIntervalSince1970];
    if (nowDate==nil) {
        convertedDate=[NSDate date];
    }
    else {
        convertedDate = [df dateFromString:nowDate];
    }
    double now = [convertedDate timeIntervalSince1970];
    
    ti=now-ti;
    if (ti < 60) {
        return @"Tout à l'heure";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        if (diff == 1)
            return [NSString stringWithFormat:@"il y a %d minute", diff];
        return [NSString stringWithFormat:@"il y a %d minutes", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if (diff == 1)
            return [NSString stringWithFormat:@"il y a %d heure", diff];
        return[NSString stringWithFormat:@"il y a %d heures", diff];
    } else {//if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        if (diff == 1)
            return [NSString stringWithFormat:@"il y a %d jour", diff];
        return[NSString stringWithFormat:@"il y a %d jours", diff];
    }
}

//+ (int)dayDiff:(NSDate *)dt1 otherDate:(NSDate *)dt2{
//    NSDate *aDt=[self dateFormatYearDay:dt1];
//    NSDate *cDt=[self dateFormatYearDay:dt2];
//    
//    double t1 = [aDt timeIntervalSince1970];
//    double t2 = [cDt timeIntervalSince1970];
//    
//    double ti=fabs(t1-t2);
//    
//    int diff = round(ti / 60 / 60 / 24);
//    return diff;
//    
//}

#pragma mark 发出全局通知
- (NSDictionary *)postNotif:(NSInteger)type data:(id)data object:(id)obj{
    NSMutableDictionary *info=[NSMutableDictionary dictionary];
    [info setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if (data) {
        [info setObject:data forKey:@"data"];
    }
    if (obj) {
        [info setObject:obj forKey:@"object"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kQGlobalNotification object:obj userInfo:info];
    return info;
}

#pragma mark 文字高度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
    
//    
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 5000)];
//    label.font = font;
//    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//    label.numberOfLines = 0;
//    label.text = text;
//    [label sizeToFit];
//    return label.frame.size;
    
    
    
}

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
}

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)size{
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
//    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
}
#pragma mark 设置边距
- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge{
    if (object && [object isMemberOfClass:[UIView class]]) {
        CGRect frm=object.frame;
        if (edge & EdgeLeft) {
            frm.size.width -= margin;
            frm.origin.x = margin;
        }
        if (edge & EdgeRight) {
            frm.size.width -= margin;
        }
        if (edge & EdgeTop) {
            frm.size.height -= margin;
            frm.origin.y = margin;
        }
        if (edge & EdgeBottom) {
            frm.size.height -= margin;
        }
        
        object.frame=frm;
    }
}

#pragma mark 判断键盘输入模式是否是表情模式

/**
 *  @brief 判断键盘当前是否是表情输入模式
 *
 *  @param inputControl 传入调出键盘的控件对象 例如:UITextField UITextView
 *
 *  @return YES表示是表情输入模式, NO表示不是表情模式
 */
- (BOOL)judgeTheKeyboardInputModeIsEmojiOrNot:(id)inputControl
{
    UITextInputMode *inputMode = nil;
    if ([inputControl isKindOfClass:[UIResponder class]]) {
        UIResponder *c = (UIResponder *)inputControl;
        inputMode = c.textInputMode;
    }
    if (inputMode == nil) {
        return YES;
    }
    return NO;
}


//TODO: 振动调用
+(void)invokeVibration
{
    //    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - json
- (id)toJsonObj:(id)obj{
    if (obj && [NSJSONSerialization isValidJSONObject:obj]) {
        return obj;
    }
    else if ([obj isKindOfClass:[NSString class]]){
        NSString *str=obj;
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err=nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if (err && jsonObject != nil) {
            DLog(@"%@ %@",[self class], jsonObject);
            return nil;
        }
        return jsonObject;
    }
    else if ([obj isKindOfClass:[NSData class]]){
        NSData *jsonData=obj;
        
        NSError *err=nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if (err && jsonObject != nil) {
            DLog(@"%@ %@",[self class], obj);
            return nil;
        }
        return jsonObject;
    }
    
    return nil;
}

- (NSString *)toJSONStr:(id)jsonObject{
    if(jsonObject && [NSJSONSerialization isValidJSONObject:jsonObject])
    {
        NSError *error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
        if(data.length > 0 && error == nil)
        {
            NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            return jsonString;
        }
    }
    return nil;
}

#pragma mark - 每次产生一个唯一标示
- (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

#pragma mark - devices
- (NSString*)deviceType{
    return stringFromDeviceVersion([SDVersion deviceVersion]);
}
#pragma mark - 检查网络
- (void)updateConnectionType:(NSNotification *)notification{
    Reachability *reach = notification.object;
    if (reach != nil && [reach isKindOfClass:[Reachability class]]){
        _netStatus = [reach currentReachabilityStatus];
    }
    [self postNotif:NotifNetworkReachabilityChanged data:[NSNumber numberWithInteger:_netStatus] object:nil];
}
- (void)checkConnection{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    _netStatus = [reachability currentReachabilityStatus];
    
    [self postNotif:NotifNetworkReachabilityChanged data:[NSNumber numberWithInteger:_netStatus] object:nil];
}
#pragma mark - class
- (id)viewControllerName:(NSString*)vcName storyboardName:(NSString*)sbName{
    UIViewController *vc=nil;
    if (sbName && vcName) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:vcName];
    }
    return vc;
}
@end
