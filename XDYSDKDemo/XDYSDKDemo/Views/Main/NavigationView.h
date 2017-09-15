//
//  NavigationView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//  ipad端  导航条

#import <UIKit/UIKit.h>

@interface NavigationView : UIView


@property (nonatomic ,strong) void (^blockBack)();

- (void)setTitle:(NSDictionary *)message;

@end
