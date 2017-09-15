//
//  XDYClient.h
//  XDYSDK
//
//  Created by lyy on 2017/1/20.
//  Copyright © 2017年 liyanyan. All rights reserved.
//  学点云客户端

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^Success) (id response);
typedef void(^Failer) (id type,id error);
typedef void(^BLOCK)(id type, id message);

@interface XDYClient : NSObject

@property (nonatomic, copy) BLOCK  XDYBlock;

@property (nonatomic, copy) BLOCK XDYRemoteVideo;

/**
 * 获取实例
 */
+ (XDYClient *)sharedClient;

/**
 * 初始化学点云SDK
 */
- (void)initXDY;


/**
 发送消息
 @param type 消息类型 （publish推流 play播流  unpublish停止推流 unplay停止播流）
 @param message  消息（所有消息都为NSDictionary）
 */
- (NSString *)api:(NSString *)type message:(NSDictionary *)message;
/**
 发送消息
 @param type 推流消息
 @param message  消息（所有消息都为NSDictionary）
 */
- (NSString *)RTCApi:(NSString *)type message:(NSDictionary *)message;

/**
 发送图片聊天消息
 @param image        图片
 @param DOCServerIP  文档服务地址
 @param siteId       客户表示
 @param timestamp    当前时间戳
 @param classId      课堂号
 @param succss       成功回调
 @param fail         失败回调
 */
- (void)sendChatPictrueMsg:(UIImage*)image
               DOCServerIP:(NSString *)DOCServerIP
                    siteId:(NSString *)siteId
                 timestamp:(NSString *)timestamp
                   classId:(NSString *)classId
                   Success:(Success)succss
                    Failer:(Failer)fail;

/**
 获取课堂中所有消息的回调 （返回消息也为json格式）
 */
- (void)getMessageXDYBlock:(BLOCK)XDYBlock;
/**
 监听课堂中远端视频
 */
- (void)XDYRemoteVideo:(BLOCK)XDYRemoteVideo;

/**
 获取日志并打印
 */
- (void)catchJsLog;

@end

