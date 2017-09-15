//
//  XDYRePlayToolView.h
//  XDYRePlay
//
//  Created by lyy on 2016/12/10.
//  Copyright © 2016年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDYRePlayToolView;

@protocol XDYRePlayToolDelegate <NSObject>
@optional
/**
 拖动Slider时获取它的value值
 */
- (void)SliderValueChange:(UISlider *)slider;
- (void)rePlayBegining:(XDYRePlayToolView *)view;

@end

@interface XDYRePlayToolView : UIView

@property (nonatomic, weak) id<XDYRePlayToolDelegate> delegate;

/**
 *是否正在播放
 */
@property (nonatomic, assign) BOOL rePlaying;

/**
 *更改播放按钮状态
 */
@property (nonatomic, assign, getter = isRePlay) BOOL rePlay;

/**
 *播放暂停按钮
 */
@property (nonatomic, strong) UIButton *startEndMark;

/**
 *开始时间
 */
@property (nonatomic, strong) UILabel *startTime;

/**
 *结束时间
 */
@property (nonatomic, strong) UILabel *endTime;

/**
 *时间条
 */
@property (nonatomic, retain) UISlider *slider;

/**
 slider最大值
 */
@property (nonatomic, assign) float maximumValue;

/**
 slider最小值
 */
@property (nonatomic, assign) float minimumValue;

/**
 *显示RePlayTool
 */
- (void)showRePlayTool;


- (void)setSliderMinAndMax:(float)min Max:(float)max;

@end
