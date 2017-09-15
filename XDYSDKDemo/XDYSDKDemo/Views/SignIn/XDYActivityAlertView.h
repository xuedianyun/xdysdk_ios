//
//  EBTPayActivityAlertView.h
//  EBTPayActivityWithTimerView
//
//  Created by ebaotong on 16/7/12.
//  Copyright © 2016年 com.csst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYActivityAlertView : UIView
/**
 *  弹框显示内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lbl_RemindDescript;
@property (weak, nonatomic) IBOutlet UIButton *btn_sign;
@property (weak, nonatomic) IBOutlet UILabel *lbl_RemindSign;


@end
