//
//  LanguageManager.m
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "LanguageManager.h"
#import "NSBundle+Language.h"

static NSString * const LanguageCodes[] = { @"iphone",@"en", @"de", @"fr", @"ar",@"zh-Hans" };
static NSString * const LanguageStrings[] = { @"设备语言",@"English", @"German", @"French", @"Arabic",@"Chinese" };
static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageManager
+ (instancetype)sharedInstance
{
    static LanguageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LanguageManager alloc] init];
    });
    return manager;
}
+ (void)LanguageAppDelegate
{
    NSString *languageStr = [LanguageManager currentLanguageCode];
        if ([[[LanguageManager sharedInstance] getCurrentLanguage] isEqualToString:[NSString stringWithFormat:@"%@-US",languageStr]]) {
            [LanguageManager sharedInstance].language = [[LanguageManager sharedInstance] getCurrentLanguage];
        }else{
            [LanguageManager sharedInstance].language = languageStr;
        }
        NSInteger index = [[LanguageManager languageCodes] indexOfObject:[LanguageManager sharedInstance].language];
        [LanguageManager saveLanguageByIndex:index];
}
- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}
+ (void)setupCurrentLanguage
{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    if (!currentLanguage) {
        NSArray *languages = [LanguageManager languageCodes];
        if (languages.count > 0) {
            NSInteger index = [[LanguageManager languageCodes] indexOfObject:[[[LanguageManager sharedInstance] getCurrentLanguage] stringByReplacingOccurrencesOfString:@"-US" withString:@""]];
            BOOL result = [[LanguageManager languageCodes] containsObject:[[[LanguageManager sharedInstance] getCurrentLanguage] stringByReplacingOccurrencesOfString:@"-US" withString:@""]];
                    if (YES == result) {
                    } else {
                        index = 0;
                    }
            currentLanguage = languages[index];
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:LanguageSaveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }	
#ifndef USE_ON_FLY_LOCALIZATION
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [NSBundle setLanguage:currentLanguage];
#endif
}

+ (NSArray *)languageCodes
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        [array addObject:NSLocalizedString(LanguageCodes[i], @"")];
    }
    return [array copy];
}
+ (NSArray *)languageStrings
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        [array addObject:NSLocalizedString(LanguageStrings[i], @"")];
    }
    return [array copy];
}

+ (NSString *)currentLanguageString
{
    NSString *string = @"";
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]]) {
            string = NSLocalizedString(LanguageStrings[i], @"");
            break;
        }
    }
    return string;
}

+ (NSString *)currentLanguageCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
}

+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

+ (void)saveLanguageByIndex:(NSInteger)index
{
    if (index >= 0 && index < ELanguageCount) {
        NSString *code = LanguageCodes[index];
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LanguageSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef USE_ON_FLY_LOCALIZATION
        [NSBundle setLanguage:code];
#endif
    }
}

+ (BOOL)isCurrentLanguageRTL
{
	NSInteger currentLanguageIndex = [self currentLanguageIndex];
	return ([NSLocale characterDirectionForLanguage:LanguageCodes[currentLanguageIndex]] == NSLocaleLanguageDirectionRightToLeft);
}

@end
