//
//  XDYDicJson.h
//  XDYSDK
//
//  Created by lyy on 2017/2/7.
//  Copyright © 2017年 liyanyan. All rights reserved.
//  json字符串转字典

#import <Foundation/Foundation.h>

@interface XDYDicJson : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)JsonStringWithdictionary:(NSDictionary *)dic;

@end
