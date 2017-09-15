//
//  ViewController.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RePlayViewController : UIViewController

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
 * 课堂类型   true代表直播课堂    false代表1v1课堂
 */
@property (nonatomic, assign) int classType;


@end
