//
//  CNIDCheck.m
//  resource
//
//  Created by Qingyang on 16/6/21.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "CNIDCheck.h"

@implementation CNIDCheck
//是否大陆身份证
+ (BOOL)isChineseIdNo:(NSString*)idNumber
{
    if (StrIsEmpty(idNumber)) {
        return  false;
    }
    
    BOOL isMainLandIdNo = true;//
    //
    NSArray* factorArr = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2, @1]; //系数因子
    NSArray* parityBit = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"]; //校验位
    NSMutableArray* varArray = [NSMutableArray new]; //
    NSInteger lngProduct = 0; //前17位数字和对应的系数因子相乘，累加后的结果
    NSInteger intCheckDigit; //
    NSInteger intStrLen = idNumber.length; //
    if ((intStrLen != 15) && (intStrLen != 18)) {
        isMainLandIdNo = false;
    }
    
    for (NSInteger i = 0; i < intStrLen; i++) {
        varArray[i] = [idNumber substringWithRange:NSMakeRange(i, 1)];
        if (([varArray[i] intValue] < 0 || [varArray[i] intValue] > 9) && (i != 17)) {
            isMainLandIdNo =  false;
        }
        //将前17位数字和对应的系数因子相乘
        else if (i < 17) {
            varArray[i] =[ NSNumber numberWithInteger:[varArray[i] intValue] * [factorArr[i] intValue] ];
        }
    }
    
    // 18位身份证
    if (intStrLen == 18) {
        // 校验生日是否正确
        NSString* date8 = [idNumber substringWithRange:NSMakeRange(6, 8)];
        if ([CNIDCheck isDate8:date8] == false) {
            isMainLandIdNo =  false;
        }
        // 将前17位数字和系数因子相乘的结果累加
        for (int i = 0; i < 17; i++) {
            lngProduct = lngProduct + [varArray[i] intValue];
        }
        // 计算校验位，累加和对11取余
        intCheckDigit = [parityBit[lngProduct % 11] integerValue];
        // 校验最后一位是否合法
        if ([varArray[17] integerValue] != intCheckDigit) {
            isMainLandIdNo =  false;
        }
    }
    // 15位身份证
    else if (intStrLen == 15){
        // 校验生日是否正确
        NSString* date6 = [idNumber substringWithRange:NSMakeRange(6, 6)];
        if ([CNIDCheck isDate6:date6] == false) {
            isMainLandIdNo =  false;
        }
    }
    else {
        return false;
    }

    return isMainLandIdNo;
}


// 15位身份证，校验生日是否正确
+ (bool )isDate6:(NSString* )sDate {
//    if (!/^[0-9]{6}$/.test(sDate)) {
//        return false;
//    }
    if (sDate.length != 8 || ![CNIDCheck isNumberByStr:sDate]) {
        return false;
    }
    NSString* year, *month;
    year = [sDate substringWithRange:NSMakeRange(0, 4)];
    month = [sDate substringWithRange:NSMakeRange(4, 2)];
    if (year.intValue < 1700 || year.intValue > 2500)
        return false;
    if (month.intValue < 1 || month.intValue > 12)
        return false;
    return true;
}


// 18位身份证，校验生日是否正确
+ (bool )isDate8:(NSString* )sDate {
    if (sDate.length != 8 || ![CNIDCheck isNumberByStr:sDate]) {
        return false;
    }
    NSString* year, *month, *day;
    year = [sDate substringWithRange:NSMakeRange(0, 4)];
    month = [sDate substringWithRange:NSMakeRange(4, 2)];
    day = [sDate substringWithRange:NSMakeRange(6, 2)];
    NSMutableArray* iaMonthDays =[ @[@31, @28, @31, @30, @31, @30, @31, @31, @30, @31, @30, @31] mutableCopy];
    if (year.intValue < 1700 || year.intValue > 2500)
        return false;
    if (((year.intValue % 4 == 0) && (year.intValue % 100 != 0)) || (year.intValue % 400 == 0))
        iaMonthDays[1] = @29;
    if (month.intValue < 1 || month.intValue > 12)
        return false;
    if (day.intValue < 1 || day.intValue > [iaMonthDays[month.intValue - 1] intValue])
        return false;
    return true;
}

+ (BOOL)isNumberByStr:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]*$";//!/^[0-9]{8}$/.test(sDate)
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

@end
