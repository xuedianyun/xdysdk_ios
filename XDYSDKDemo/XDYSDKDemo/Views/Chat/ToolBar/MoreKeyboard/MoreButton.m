//
//  MoreButton.m
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import "MoreButton.h"

@implementation MoreButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.moreImageView = [[UIImageView alloc]init];
        [self addSubview:self.moreImageView];
        
        self.moreTitleLabel = [[UILabel alloc]init];
        [self addSubview:self.moreTitleLabel];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.moreImageView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height- 50);
    self.moreTitleLabel.frame = CGRectMake(0, self.frame.size.height- 30, self.frame.size.width, 30);
    self.moreTitleLabel.font = [UIFont systemFontOfSize:14];
    self.moreTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.moreTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
