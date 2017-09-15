//
//  XDYRePlayToolView.m
//  XDYRePlay
//
//  Created by lyy on 2016/12/10.
//  Copyright © 2016年 liyanyan. All rights reserved.
//

#import "XDYRePlayToolView.h"

@interface XDYRePlayToolView ()

@property (nonatomic, strong) UIImageView *toolView;

@end

@implementation XDYRePlayToolView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //1.设置背景
//        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.7;
        _toolView = [[UIImageView alloc]init];
        [self addSubview:_toolView];
        
        _startEndMark = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolView addSubview:_startEndMark];
        
        _startTime = [[UILabel alloc]init];
        _startTime.textColor = [UIColor whiteColor];
        
        [_toolView addSubview:_startTime];
        _slider = [[UISlider alloc]init];
        [_toolView addSubview:_slider];
        
        _endTime = [[UILabel alloc]init];
        [_toolView addSubview:_endTime];
        _endTime.textColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    
    _toolView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    _toolView.image = [UIImage imageNamed:@"toolBack.png"];
    _toolView.userInteractionEnabled = YES;

    
    _rePlaying = NO;
    //开始暂停按钮
    _startEndMark.frame = CGRectMake(5, 0, 40, 40);
    [_startEndMark setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_startEndMark addTarget:self action:@selector(startOrEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    //开始播放时间  00:00
    _startTime.frame = CGRectMake(CGRectGetMaxX(_startEndMark.frame), 0, 50, self.frame.size.height);
    _startTime.text = @"00:00";
    
    //拖动条
    _slider.frame = CGRectMake(CGRectGetMaxX(_startTime.frame), 0, self.frame.size.width-165, self.frame.size.height);
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    //设置UISlider的最大值
    self.slider.maximumValue = 1;
    //设置UISlider的最小值
    self.slider.minimumValue = 0;
    [self.slider addTarget:self action:@selector(valueChange) forControlEvents:(UIControlEventValueChanged)];
    
    self.slider.continuous = NO;//手指离开的时候触发一次valueChange事件
    
    //停止时间
    _endTime.frame = CGRectMake(CGRectGetMaxX(_slider.frame), 0, 50, self.frame.size.height);
    _endTime.text = @"00:00";
    
    [self performSelector:@selector(hideRePlayTool) withObject:nil afterDelay:5];
    
}
- (void)setSliderMinAndMax:(float)min Max:(float)max{
    self.endTime.text = [self formatDuration:max];
    self.maximumValue = max;
    self.minimumValue = min;
    
}
//时间转换
- (NSString *)formatDuration:(NSTimeInterval)duration {
    
    int minute = 0, secend = duration;
    minute = (secend % 3600) / 60;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}
- (void)showRePlayTool{
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0.9f;
    } completion:^(BOOL finished) {
        //每五秒自动隐藏工具条
        [self performSelector:@selector(hideRePlayTool) withObject:nil afterDelay:5];
    }];
}
- (void)hideRePlayTool{
    
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0.0f;
    } completion:nil];
}
- (void)setRePlay:(BOOL)rePlay{
    _rePlay = rePlay;
    if (rePlay) {
        [self.startEndMark setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }else{
        [self.startEndMark setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
/**
 监听startEndMark开始暂停播放事件
 */
- (void)startOrEnd:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(rePlayBegining:)]) {
        [self.delegate rePlayBegining:self];
    }
}
/**
  监听slider改变事件
 */
- (void)valueChange{
    
    if ([self.delegate respondsToSelector:@selector(SliderValueChange:)]) {
        [self.delegate SliderValueChange:_slider];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
