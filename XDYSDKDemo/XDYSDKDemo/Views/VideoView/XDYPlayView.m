//
//  XDYPlayView.m
//  AgoraiOS
//
//  Created by lyy on 2017/8/30.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import "XDYPlayView.h"

@interface XDYPlayView ()
@property (weak, nonatomic) IBOutlet UIImageView *layerView;

@end

@implementation XDYPlayView

- (void)isStudent{
    [_layerView setImage:[XDYCommonTool setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
    
}
- (void)hiddenLayer{
    _layerView.hidden = YES;
    _isPlaying = YES;
}
- (void)showLayer{
    _layerView.hidden = NO;
    _isPlaying = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
