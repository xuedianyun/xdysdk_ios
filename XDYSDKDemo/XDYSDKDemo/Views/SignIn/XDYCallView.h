//
//  EBTPayActivityWithTimerView.h
//  EBTPayActivityWithTimerView
//
//  Created by ebaotong on 16/7/12.
//  Copyright © 2016年 com.csst. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XDYCallViewCompleteHandler)(NSString *answer);

@interface XDYCallView : UIView
{
    XDYCallViewCompleteHandler  activityCompleteHandler;
}
/**
 *  显示倒计时支付活动指示器
 *
 *  @param timerCountDown           倒计时时间
 *  @param alertViewCompleteHandler 参数回调
 */
+ (void)showPayActivityAlertViewWithTimer:(NSInteger)timerCountDown withAlertViewCompleteHandler:(XDYCallViewCompleteHandler)alertViewCompleteHandler;

+ (void)showCallTimer:(NSInteger)timerCountDown;

+ (void)closeAlertView;



@end
