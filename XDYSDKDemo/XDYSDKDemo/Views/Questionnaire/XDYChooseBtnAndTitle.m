//
//  XDYChooseBtnAndTitle.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/2.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYChooseBtnAndTitle.h"

@interface XDYChooseBtnAndTitle()

@property(nonatomic,strong)UIButton *button;

@property(nonatomic,strong)UILabel *label;



@end

@implementation XDYChooseBtnAndTitle

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubViews];
        
    }
    return self;

}
-(void)addSubViews{
 
    _button  = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(5,0,30, 30);
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    [self addSubview:_button];
   
    _label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_button.frame), 0, self.bounds.size.width - 30, self.bounds.size.height)];
    
    _label.textColor = kUIColorFromRGB(0x3498db);
    _label.font = [UIFont systemFontOfSize:17];
    _label.numberOfLines = 0;
    [self addSubview:_label];

}
-(void)buttonClick:(UIButton *)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBtn:)]) {
        
        [self.delegate selectBtn:sender];
        
    }

}
-(void)setTitle:(NSString*)title{
   
    _label.text = title;
    _button.tag = self.tag;
}
-(void)setIsSelect:(BOOL)isSelect{
    
    _button.selected = isSelect;
    
}
@end
