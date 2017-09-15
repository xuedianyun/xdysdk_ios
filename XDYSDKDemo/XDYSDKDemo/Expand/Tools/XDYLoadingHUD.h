//
//  HCLoadingHUD.h
//  HelperCar
//
//  Created by Jentle on 16/8/9.
//  Copyright © 2016年 Jentle. All rights reserved.
//  加载动画的显示与隐藏，需主动隐藏动画。

#import <UIKit/UIKit.h>

@interface XDYLoadingHUD : UIView
/**
 * 显示加载动画到根视图上
 */
+ (void)showLoadingAnimationWithStatus:(NSString *)status;
/**
 *  显示加载动画
 *
 *  @param status 加载提示文字
 *  @param view   动画父视图
 */
+ (void)showLoadingAnimationForView:(UIView *)view withStatus:(NSString *)status;
/**
 *  移除加载动画
 */
+ (void)hiddenLoadingAnimation;

@end
