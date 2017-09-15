//
//  LoginTagView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/4/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "LoginTagView.h"

@implementation LoginTagView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _nameLabel = [[UILabel alloc]init];
        [self addSubview:_nameLabel];
        _textField = [[UITextField alloc]init];
        [self addSubview:_textField];
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _nameLabel.frame = CGRectMake(0, 0, 80, self.frame.size.height-1);
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = kUIColorFromRGB(0x333333);
    
    
    _textField.frame = CGRectMake(80, 0, self.frame.size.width-80, self.frame.size.height-1);
    _textField.textColor = kUIColorFromRGB(0x333333);
    _textField.font = [UIFont systemFontOfSize:15];
    
    
    _lineView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    
    _lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
