//
//  XDYSelectColorView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//
#import <UIKit/UIKit.h>

#pragma mark - 定义块代码
typedef void(^SelectColorBlock)(UIColor *color);

@interface XDYSelectColorView:UIView

//扩展initWithFrame方法，增加块代码参数
//该块代码将在选择颜色按钮之后执行
-(id)initWithFrame:(CGRect)frame afterSelectColor:(SelectColorBlock)afterSelectColor;

@end
