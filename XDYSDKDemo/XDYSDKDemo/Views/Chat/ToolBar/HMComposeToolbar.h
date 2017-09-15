//
//  HMComposeToolbar.h
//  黑马微博
//
//  Created by apple on 14-7-10.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HMComposeToolbarButtonTypeEmotion, // 表情
    HMComposeToolbarButtonTypePictrue, // 图片
    HMComposeToolbarButtonTypeMention // 更多
    
} HMComposeToolbarButtonType;

@class HMComposeToolbar;

@protocol HMComposeToolbarDelegate <NSObject>

@optional
- (void)composeTool:(HMComposeToolbar *)toolbar didClickedButton:(HMComposeToolbarButtonType)buttonType;
@end

@interface HMComposeToolbar : UIView
@property (nonatomic, weak) id<HMComposeToolbarDelegate> delegate;
/**
 *  设置某个按钮的图片
 *
 *  @param image      图片名
 *  @param buttonType 按钮类型
 */
//- (void)setButtonImage:(NSString *)image buttonType:(HMComposeToolbarButtonType)buttonType;

/**
 *  是否要显示表情按钮
 */
@property (nonatomic, assign, getter = isShowEmotionButton) BOOL showEmotionButton;
/**
 *  是否是举手状态
 */
@property (nonatomic, assign, getter = isShowPictrueButton) BOOL showPictrueButton;

//@property (nonatomic, strong) UIButton *handButton;



@end
