//
//  NavigationView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "NavigationView.h"

@interface NavigationView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NavigationView
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)backClick:(UIButton *)sender {
    if (self.blockBack) {
        self.blockBack();
    }
}

- (void)setTitle:(NSDictionary *)message{
    
    _titleLabel.text = message[@"className"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
