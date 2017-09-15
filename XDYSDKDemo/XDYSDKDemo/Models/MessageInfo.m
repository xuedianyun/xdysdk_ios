//
//  MessageInfo.m
//  XDY
//
//  Created by 3mang on 16/3/7.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo
- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.icon = dict[@"icon"];
    self.time = dict[@"time"];
    self.content = dict[@"content"];
    self.type = [dict[@"type"] intValue];
    self.userName = dict[@"userName"];
    self.isSuccess = [dict[@"isSuccess"] boolValue];
    
}
@end
