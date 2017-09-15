//
//  XDYFillView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYFillView.h"

@implementation XDYFillView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)commonInit{
    [self addSubview:self.result];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _result.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    line3.backgroundColor = kUIColorFromRGB(0xd1d1d1);
    [self addSubview:line3];
}

- (UITextField *) result{
    if (!_result) {
        _result = [[UITextField alloc]init];
        _result.placeholder = @"输入答案";
        _result.textAlignment = NSTextAlignmentCenter;
        [_result setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14.00]];
    }
    return _result;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
