//
//  XDYBottomView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/24.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYBottomView.h"

@interface XDYBottomView ()

@end


@implementation XDYBottomView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconBtn= [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_iconBtn];
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _iconBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_iconBtn setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/doc.png"] forState:(UIControlStateNormal)];
    [self sendSubviewToBack:_iconBtn];
    
    
}

- (UIImage *)setImageOriginal:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
