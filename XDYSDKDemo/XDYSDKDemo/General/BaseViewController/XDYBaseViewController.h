//
//  XDYBaseViewController.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XDYJoinSuccessModel.h"

@interface XDYBaseViewController : UIViewController
{
    XDYJoinSuccessModel            *_joinSuccessModel;//加入课堂成功消息
}
/**
 * 课堂号
 */
@property (nonatomic, strong) NSString *classId;

/**
 * 用户角色
 */
@property (nonatomic, strong) NSString *userRole;

/**
 * 课堂服务地址
 */
@property (nonatomic, strong) NSString *portal;

/**
 * 用户标识  0：游客
 */
@property (nonatomic, strong) NSString *userId;



/**
 *初始化课堂
 */
- (void)initXDY:(NSDictionary *)message;
/**
 *加入课堂成功消息
 */
- (void)joinXDYSuccess:(NSDictionary *)message;

/**
 *用户名密码验证
 */
- (void)userXDYVerify:(BOOL)flag
              confirm:(void(^)(id data))confirmMessage
               cancel:(void(^)(id data))cancelMessage;

/**
 *退出课堂
 */
- (void)classExitXDY:(NSDictionary *)message
             confirm:(void(^)(id data))confirmMessage;

- (void)erorEventXDY:(NSDictionary *)message
             confirm:(void(^)(id data))confirmMessage;

/**
 *获取类型数组
 */
- (NSArray *)returnTypeArray;

/**
 * 申请摄像头麦克风
 */
- (void)applyMicOrCamera;

/**
 * 网络链接变化的通知   子类实现
 * @param note 通知
 * 网络链接状态
 */
- (void)AFNetworkingReachabilityDidChang:(NSNotification *)note;

/**
 *设置图片显示为原始显示
 */
- (UIImage *)setImageOriginal:(NSString *)imageName;

@end
