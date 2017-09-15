//
//  XDYCurrentTime.m
//  XDYSDK
//
//  Created by lyy on 16/9/18.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import "XDYCurrentTime.h"

@implementation XDYCurrentTime
+ (NSString *)getTimeInterval{
    NSDate *senddate = [NSDate date];
 
    NSString *date = [NSString stringWithFormat:@"%f",[senddate timeIntervalSince1970]];
    return date;
}
+ (NSString *)getCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd-h-m-s"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    return [ dateFormatter stringFromDate:currentDate];
}

+ (NSString *)getChatTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    return [ dateFormatter stringFromDate:currentDate];
}
@end
