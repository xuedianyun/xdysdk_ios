//
//  MoreButton.h
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmotionView;

@interface HMEmotionPopView : UIView
+ (instancetype)popView;

/**
 *  显示表情弹出控件
 *
 *  @param fromEmotionView 从哪个表情上面弹出
 */
- (void)showFromEmotionView:(HMEmotionView *)fromEmotionView;
- (void)dismiss;
@end
