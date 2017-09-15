//
//  XDYCurrentTime.h
//  XDYSDK
//
//  Created by lyy on 16/9/18.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDYCurrentTime : NSObject
/**
 *获取当前时间戳
 **/
+ (NSString *)getTimeInterval;

/**
 *获取当前时间（格式：YYYY-M-d-h-m-s）
 **/
+ (NSString *)getCurrentTime;
/**
 *获取聊天时间（格式：hh:mm）
 **/
+ (NSString *)getChatTime;
@end
