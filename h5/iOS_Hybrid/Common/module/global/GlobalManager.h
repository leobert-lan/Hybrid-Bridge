//
//  GlobalManager.h
//  APP
//
//  Created by carret on 15/1/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Reachability.h"


#define  YGLOBAL [GlobalManager sharedInstance]



@interface GlobalManager : NSObject
@property(nonatomic ,assign)NetworkStatus netStatus;

+ (instancetype)sharedInstance;

#pragma mark apple store
- (void)openAppStoreLink;
- (void)checkAppStore:(void(^)(NSString* version, NSString* releaseNotes))result;
- (BOOL)isNewVersion:(NSString*)aVersion;

- (BOOL)console ;
- (BOOL)iPhone ;
- (BOOL)iPad;

#pragma mark - 判断
/**
 *  判断是不是某类
 *
 *  @param obj    判断对象
 *  @param aClass 类类型
 *
 *  @return 返回BOOL
 */
- (BOOL)object:(id)obj isClass:(Class)aClass;

/**
 *  判断字符串是空
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isStringEmpty:(id)obj;

/**
 *  判断是不是电话号码
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isPhoneNumber:(NSString*)text;

/**
 *  判断邮件格式是否正确
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isEmailAddress:(NSString*)text;

- (BOOL)isPassword:(NSString*)text;

//判断字符串是否带表情
- (BOOL)isContainsEmoji:(NSString *)string;
#pragma mark -

/**
 *  发出全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param object  通知来源对象，填self
 *  @return @{type:,data:,object:}
 */
- (NSDictionary *)postNotif:(NSInteger)type data:(id)data object:(id)object;

/**
 *  文字限宽下高度计算
 *
 *  @param text  文字内容
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回高度,如果带emoji表情，要加2
 */
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width;
/**
 *  返回文字的size
 *
 *  @param text 内容
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeText:(NSString*)text font:(UIFont*)font;

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)size;
//- (CGSize)sizeText:(NSString*)text font:(UIFont*)font attributes:(NSAttributedString*)attributes;
/**
 *  设置边距
 *
 *  @param object UI控件
 *  @param margin 边距
 *  @param edge   方位
 */
//- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge;

/**
 *  @brief 判断键盘当前是否是表情输入模式
 *
 *  @param inputControl 传入调出键盘的控件对象 例如:UITextField UITextView
 *
 *  @return YES表示是表情输入模式, NO表示不是表情模式
 */
- (BOOL)judgeTheKeyboardInputModeIsEmojiOrNot:(id)inputControl;

- (id)toJsonObj:(id)obj;
- (NSString *)toJSONStr:(id)theData;

#pragma mark - 文件大小
- (NSString *)stringFromFileSize:(double)theSize;
- (unsigned long long)sizeOfFolder:(NSString*)folderPath;
#pragma mark - 每次产生一个唯一标示
- (NSString *)generateUUID;

#pragma mark - devices
- (NSString*)deviceType;

#pragma mark - 检查网络
- (void)checkConnection;
#pragma mark - class
- (id)viewControllerName:(NSString*)vcName storyboardName:(NSString*)sbName;

#pragma mark 时间格式
- (NSString*)dateToStr:(NSDate*)date format:(NSString*)format;
- (NSString*)dateToTimeInterval:(NSDate*)date;
- (NSDate*)dateFromTimeInterval:(NSString*)timestamp;
@end
