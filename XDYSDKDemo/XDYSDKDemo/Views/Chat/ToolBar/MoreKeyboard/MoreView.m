//
//  MoreView.m
//  emotionDemo
//
//  Created by 3mang on 16/1/14.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import "MoreView.h"

@implementation MoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _button = [[MoreButton alloc]init];
        [self addSubview:_button];
        
        _shareButton = [[MoreButton alloc]init];
        [self addSubview:_shareButton];
        
        _feedbackButton = [[MoreButton alloc]init];
        [self addSubview:_feedbackButton];
        
        _reportButton = [[MoreButton alloc]init];
        [self addSubview:_reportButton];
        
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.space = (self.frame.size.width - 60*4)/5;
    
    self.button.frame = CGRectMake(self.space, 5, 60, 90);
//    [self setMoreButton:self.button setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/night"] setTitle:@"夜间模式"];
    
    self.shareButton.frame = CGRectMake(self.space*2+60, 5, 60, 90);
//    [self setMoreButton:self.shareButton setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/share-"] setTitle:@"分享"];
    
    self.feedbackButton.frame = CGRectMake(self.space*3+60*2, 5, 60, 90);
//    [self setMoreButton:self.feedbackButton setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/feedback"] setTitle:@"反馈"];
    
    self.reportButton.frame = CGRectMake(self.space*4+60*3, 5, 60, 90);
//    [self setMoreButton:self.reportButton setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/report"] setTitle:@"举报"];
}

- (void)setMoreButton:(MoreButton *)button setImage:(UIImage *)image setTitle:(NSString *)title{
    button.moreImageView.image = image;
    button.moreTitleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
