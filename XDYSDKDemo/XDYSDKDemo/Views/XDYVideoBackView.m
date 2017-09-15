//
//  XDYVideoBackView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/24.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYVideoBackView.h"


@interface XDYVideoBackView ()

@property (nonatomic, strong) UIButton *videoBtn;

@end

@implementation XDYVideoBackView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _videoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [self addSubview:_videoBtn];
        
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
//    _isPlay = @"-1";
    _videoBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _videoBtn.backgroundColor = kUIColorFromRGB(0xf5f9fc);
    
}

- (void)setVideoIcon:(UIImage *)image{
    
    [_videoBtn setImage:image forState:(UIControlStateNormal)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
