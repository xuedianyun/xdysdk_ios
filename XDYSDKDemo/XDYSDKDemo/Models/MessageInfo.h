//
//  MessageInfo.h
//  XDY
//
//  Created by 3mang on 16/3/7.
//  Copyright © 2016年 sanmang. All rights reserved.
//  聊天消息model

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1, //别人发得
    MessageTypeTeacher = 2 //老师发送
    
} MessageType;

@interface MessageInfo : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UIImage *imgUrl;

@property (nonatomic, assign) int msgType;

@property (nonatomic, assign) MessageType type;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, strong) NSDictionary *dict;

@end
