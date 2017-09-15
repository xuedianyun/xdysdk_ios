//
//  ClassForPadViewController.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RePlayForPadViewController : UIViewController

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



@end
