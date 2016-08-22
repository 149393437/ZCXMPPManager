//
//  UMComTools.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComTools.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]


@implementation UMComTools

+ (NSInteger)getStringLengthWithString:(NSString *)string
{
    __block NSInteger stringLength = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10;
                 if (0x1d <= uc && uc <= 0x1f77f)
                 {
                     stringLength += 1;
                 }
                 else
                 {
                     stringLength += 1;
                 }
             }
             else
             {
                 stringLength += 1;
             }
         } else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3)
             {
                 stringLength += 1;
             }
             else
             {
                 stringLength += 1;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 stringLength += 1;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 stringLength += 1;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 stringLength += 1;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 stringLength += 1;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 stringLength += 1;
             }
             else
             {
                 stringLength += 1;
             }
         }
     }];
    
    return stringLength;
}


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (NSError *)errorWithDomain:(NSString *)domain Type:(NSInteger)type reason:(NSString *)reason
{
    if([reason length])
    {
        return [NSError errorWithDomain:domain code:(NSInteger)type userInfo:@{NSLocalizedFailureReasonErrorKey:reason}];
    }
    else
    {
        return [NSError errorWithDomain:domain code:(NSInteger)type userInfo:nil];
    }
}


/*
NSString * createTimeString(NSString * create_time)
{
    if (![create_time isKindOfClass:[NSString class]] || create_time.length == 0) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar =
    [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *createDate= [dateFormatter dateFromString:create_time];
    if (createDate == nil) {
        return @"";
    }
    NSTimeInterval timeInterval = -[createDate timeIntervalSinceNow];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [currentCalendar components:NSCalendarUnitYear fromDate:createDate];
    NSDateComponents *currentDateComponent = [currentCalendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateFormatter *showFormatter = [[NSDateFormatter alloc] init];
    if (dateComponent.year == currentDateComponent.year) {
        [showFormatter setDateFormat:@"MM-dd HH:mm"];
    }else{
        [showFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString * showDate = [showFormatter stringFromDate:createDate];
    NSString *timeDescription = nil;
    float timeValue = timeInterval/60;
    if (timeValue < 1) {
        timeDescription = nil;//[NSString stringWithFormat:@"0 秒前"];
        if (timeValue <= 0) {
            timeDescription = @"0秒前";
            return timeDescription;
            
        }else{
            timeDescription = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
            return timeDescription;
        }
    }
    if(timeValue >= 1 && timeValue < 60){
        timeDescription = [NSString stringWithFormat:@"%d分钟前",(int)timeValue];
        return timeDescription;
    }
    timeValue = timeValue/60;
    
    if ( timeValue >= 1 && timeValue < 24) {
        timeDescription = [NSString stringWithFormat:@"%d小时前 ",(int)timeValue];
        return timeDescription;
    }
    timeValue = timeValue/24;
    if (timeValue >= 1 && timeValue < 2) {
        timeDescription = [NSString stringWithFormat:@"昨天"];
        return timeDescription;
    }
    else if (timeValue >= 2 && timeValue < 3){
        timeDescription = [NSString stringWithFormat:@"前天"];
        return timeDescription;
    }
    
    timeDescription = showDate;
    
    return timeDescription;
}
 */

/*2.4版本的时间显示*/
static NSCalendar* g_UMCalendar = nil;
static NSCalendar* g_UMCurrentCalendar = nil;
NSString* const g_UMNullDateFormat = @"";
NSString* const g_UMFullDateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString* const g_UMTodayDateFormat = @"HH:mm";
NSString* const g_UMCurYearDateFormat = @"MM-dd";
NSString* const g_UMBeforeCurYearDateFormat = @"yy-MM-dd";
NSString* const g_UMAfterCurYearDateFormat = @"yy-MM-dd";
/*
 //目前先屏蔽，此函数还存在功能缺陷(在月份和年份的临界值的时候)
NSString* createTimeString(NSString * create_time)
{
    
    if (![create_time isKindOfClass:[NSString class]] || create_time.length == 0) {
        return g_UMNullDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!g_UMCalendar) {
        g_UMCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    [dateFormatter setCalendar:g_UMCalendar];
    [dateFormatter setDateFormat:g_UMFullDateFormat];
    NSDate *createDate= [dateFormatter dateFromString:create_time];
    if (createDate == nil) {
        return g_UMNullDateFormat;
    }
    
    if (!g_UMCurrentCalendar) {
        g_UMCurrentCalendar = [NSCalendar currentCalendar];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        if (zone) {
            g_UMCurrentCalendar.timeZone = zone;
        }
    }
    
    //当前的时间
    NSDate *today = [NSDate date];
    
    NSDateComponents *todayComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:today];
    
    NSDateComponents *createComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:createDate];
    if (!todayComponents || !createComponents) {
        return g_UMNullDateFormat;
    }
    
    NSString* reslutString = g_UMNullDateFormat;
    
    NSInteger yearsOffsetSinceNow =  createComponents.year - todayComponents.year;
    if (yearsOffsetSinceNow > 0) {
        //创建时间大于当前的时间，此处就直接显示日期(yyyy-MM-dd)
        [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
        reslutString = [dateFormatter stringFromDate:createDate];
    }
    else if (yearsOffsetSinceNow == 0)
    {
        //在当年
        NSInteger monthOffsetSinceNow = createComponents.month - todayComponents.month;
        if (monthOffsetSinceNow > 0) {
            //创建时间大于当前的时间，此处就直接显示日期(yyyy-MM-dd)
            [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
        else if (monthOffsetSinceNow == 0)
        {
            NSInteger dayOffsetSinceNow = createComponents.day - todayComponents.day;
            if (dayOffsetSinceNow > 0) {
                //创建时间大于当前的时间，此处就直接显示日期(yyyy-MM-dd)
                [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == 0)
            {
                //今天（HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == -1)
            {
                //昨天（昨天 HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                NSString* tempString = [dateFormatter stringFromDate:createDate];
                if (!tempString) {
                    return reslutString;
                }
                reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
            }
            else
            {
                //今年（MM-dd）
                [dateFormatter setDateFormat:g_UMCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
        }
        else if (monthOffsetSinceNow < 0)
        {
            //今年（MM-dd）
            [dateFormatter setDateFormat:g_UMCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
        else{}
    }
    else if (yearsOffsetSinceNow < 0)
    {
        //往年(yy-MM-dd)
        [dateFormatter setDateFormat:g_UMBeforeCurYearDateFormat];
        reslutString = [dateFormatter stringFromDate:createDate];
    }
    
    return reslutString;
}
 */
NSString* createTimeString(NSString * create_time)
{
    if (![create_time isKindOfClass:[NSString class]] || create_time.length == 0) {
        return g_UMNullDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!g_UMCalendar) {
        g_UMCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    [dateFormatter setCalendar:g_UMCalendar];
    [dateFormatter setDateFormat:g_UMFullDateFormat];
    NSDate *createDate= [dateFormatter dateFromString:create_time];
    if (createDate == nil) {
        return g_UMNullDateFormat;
    }
    
    if (!g_UMCurrentCalendar) {
        g_UMCurrentCalendar = [NSCalendar currentCalendar];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        if (zone) {
            g_UMCurrentCalendar.timeZone = zone;
        }
    }
    
    //当前的时间
    NSDate *today = [NSDate date];
    
    NSDateComponents *todayComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:today];
    
    NSDateComponents *createComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:createDate];
    if (!todayComponents || !createComponents) {
        return g_UMNullDateFormat;
    }
    
    //计算创建时间的段一个月的最大天数
    NSRange createDateMaxDaysInCurMonth = [g_UMCurrentCalendar rangeOfUnit:NSDayCalendarUnit
                                                                    inUnit:NSMonthCalendarUnit
                                                                   forDate:createDate];
    if (createDateMaxDaysInCurMonth.length == NSNotFound) {
        //如果计算不出来当前的最大值，说明字符串给出的时间格式或者日期有问题
        return g_UMNullDateFormat;
    }
    
    
    NSString* reslutString = g_UMNullDateFormat;
    NSInteger yearsOffsetSinceNow =  createComponents.year - todayComponents.year;
    if (yearsOffsetSinceNow > 0) {
        //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
        [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
        reslutString = [dateFormatter stringFromDate:createDate];
    }
    else if (yearsOffsetSinceNow == 0)
    {
        //在当年
        NSInteger monthOffsetSinceNow = createComponents.month - todayComponents.month;
        if (monthOffsetSinceNow > 0) {
            //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
            [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
        else if (monthOffsetSinceNow == 0)
        {
            //在当月
            NSInteger dayOffsetSinceNow = createComponents.day - todayComponents.day;
            if (dayOffsetSinceNow > 0) {
                //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
                [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == 0)
            {
                //今天（HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == -1)
            {
                //昨天（昨天 HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                NSString* tempString = [dateFormatter stringFromDate:createDate];
                if (!tempString) {
                    return reslutString;
                }
                reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
            }
            else
            {
                //今年（MM-dd）
                [dateFormatter setDateFormat:g_UMCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
        }
        else
        {
            if ((monthOffsetSinceNow == -1) &&
                (createDateMaxDaysInCurMonth.length == createComponents.day)) {
                
                //昨天（昨天 HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                NSString* tempString = [dateFormatter stringFromDate:createDate];
                if (!tempString) {
                    return reslutString;
                }
                reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
            }
            else
            {
                //今年（MM-dd）
                [dateFormatter setDateFormat:g_UMCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
        }
    }
    else
    {
        //在去年或者以前的某一天
        if ((yearsOffsetSinceNow == -1) &&
            (createComponents.day == createDateMaxDaysInCurMonth.length) &&
            (createComponents.month == 12)&&(todayComponents.month == 1) && (todayComponents.day == 1))
        {
            //昨天（昨天 HH:mm）
            [dateFormatter setDateFormat:g_UMTodayDateFormat];
            NSString* tempString = [dateFormatter stringFromDate:createDate];
            if (!tempString) {
                return reslutString;
            }
            reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
        }
        else
        {
            //往年(yy-MM-dd)
            [dateFormatter setDateFormat:g_UMBeforeCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
    }
    
    return reslutString;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

NSString *countString(NSNumber *count)
{
    NSInteger displayCount = [count integerValue];
    NSString *countString = @"";
    if (displayCount >= 10000) {
        displayCount = 9999;
    }
    countString = [NSString stringWithFormat:@"%ld",displayCount];
    return countString;
}

@end
