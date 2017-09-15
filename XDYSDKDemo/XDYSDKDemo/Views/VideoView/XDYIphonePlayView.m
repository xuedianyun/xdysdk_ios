//
//  XDYIphonePlayView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/1.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYIphonePlayView.h"

@interface XDYIphonePlayView ()
@property (weak, nonatomic) IBOutlet UIImageView *layerView;


@end
@implementation XDYIphonePlayView

- (void)hiddenLayer{
    _layerView.hidden = YES;
}
- (void)showLayer{
    _layerView.hidden = NO;
}
- (IBAction)backClick:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
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
