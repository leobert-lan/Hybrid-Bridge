
#ifndef A_SystemMacro_h
#define A_SystemMacro_h

#define StrFromInt(IntValue)     [NSString stringWithFormat: @"%li", (long)IntValue]
#define StrFromFloat(FloatValue)     [NSString stringWithFormat: @"%f", FloatValue]
#define StrFromDouble(DoubleValue)     [NSString stringWithFormat: @"%f", DoubleValue]
#define StrFromObj(objValue)     [NSString stringWithFormat: @"%@", objValue]

#define StrIsEmpty(obj) [[GlobalManager sharedInstance] isStringEmpty:obj]
//version
#define	VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define	BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define	BUILD_COUNT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]
#define	APP_DISPLAYNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define	APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
//#define ChANNELID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ChannelID"]
#define OS_VERSION [[UIDevice currentDevice] systemVersion]
#define DEVICE_NAME [[UIDevice currentDevice] name]
#define DEVICE_MODEL [[UIDevice currentDevice] model]
#define USER_LANNGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]

#define DEVICE_ID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//#define AD_ID [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] //没有广告不要开启广告id的代码，会被拒

#define iOS_V               [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOSv9               (iOS_V >= 9.0)
#define iOSv8               (iOS_V >= 8.0)
#define iOSv7               (iOS_V >= 7)
/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define InstanceByBlock(block) \
static dispatch_once_t once = 0; \
static id _sharedObject = nil; \
dispatch_once(&once, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \



//同步到主线程
#define Dispatch_Main_Sync(block) dispatch_async(dispatch_get_main_queue(), ^{ block;});

//#define Dispatch_Main_Sync(block)\
//if ([NSThread isMainThread]) {\
//block;\
//}\
//else {\
//dispatch_async(dispatch_get_main_queue(), ^{ \
//block;                      \
//});   \
//}
//异步处理
#define Dispatch_Global_Async(block)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){ block; }); \

//异步处理
#define AsyncBegin dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(){
#define AsyncEnd });

//立刻同步到主线程，注意使用，小心死锁
#define SyncBegin dispatch_async(dispatch_get_main_queue(), ^{
#define SyncEnd });

#endif


/**
 *  输出日志宏
 *
 *  @param format
 *  @param ...
 *
 *  @return
 */
#ifndef QDEBUG
#define DLog(format, ...) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__]  \
lastPathComponent], __LINE__, [NSString stringWithFormat:(format),  ##__VA_ARGS__] )

#endif



#ifndef CONSOLE
   #define CONSOLE
#endif



#define checkNull(origin)           ((origin == nil)? @"":origin);






#define myFormat(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]



