//
//  XDYMemberModel.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/25.
//  Copyright © 2017年 liyanyan. All rights reserved.
// 成员列表model

#import <Foundation/Foundation.h>

@interface XDYMemberModel : NSObject
/*
 用户唯一id
 */
@property (nonatomic, strong) NSString *userId;
/*
 用户唯一标识
 */
@property (nonatomic, assign) int nodeId;
/*
 用户角色
 */
@property (nonatomic, strong) NSString *userRole;
/*
 用户名称
 */
@property (nonatomic, strong) NSString *name;
/*
 是否举手状态
 */
@property (nonatomic, assign) int handUpTime;
/*
 是否开启摄像头
 */
@property (nonatomic, assign) int openCamera;
/*
 是否开启mic
 */
@property (nonatomic, assign) int openMicrophones;
/*
 是否禁言
 */
@property (nonatomic, assign) BOOL isBannedChat;
/*
 设备类型
 */
@property (nonatomic, assign) int deviceType;



@end
