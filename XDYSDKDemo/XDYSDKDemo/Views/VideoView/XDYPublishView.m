//
//  XDYPublishView.m
//  AgoraiOS
//
//  Created by lyy on 2017/8/30.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import "XDYPublishView.h"

@interface XDYPublishView ()
{
    BOOL hidden;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *layerView;
@property (weak, nonatomic) IBOutlet UIButton *publish;

@property (weak, nonatomic) IBOutlet UIButton *hangup;
@end

@implementation XDYPublishView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    hidden = NO;
}

- (IBAction)publishClick:(UIButton *)sender {
    if (self.publishBlock) {
        _publishView.hidden = NO;
        _layerView.hidden = YES;
//        if (hidden != YES) {
            _hangup.hidden = hidden;
//        }
        self.publishBlock();
    }
    
}
- (IBAction)unPublishClick:(UIButton *)sender {
    if (self.unPublishBlock) {
        _publishView.hidden = YES;
       
//        if (hidden!= YES) {
             _layerView.hidden = hidden;
//        }
        _hangup.hidden = YES;
        self.unPublishBlock();
    }
}

- (void)hiddenCamera:(BOOL)flag isMax:(BOOL)max{
    if (max) {
        
        [_layerView setImage:[XDYCommonTool setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        
    }
    hidden = flag;
    _publish.hidden = flag;
    
    
}

- (void)publishVideo{
    
    _publishView.hidden = NO;
    _layerView.hidden = YES;
    _hangup.hidden = hidden;
    
}
- (void)unpublishVideo{
    
    _publishView.hidden = YES;
    _layerView.hidden = NO;
    _hangup.hidden = hidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
