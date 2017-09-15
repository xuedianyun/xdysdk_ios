//
//  XDYIphonePublishView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/2.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYIphonePublishView.h"

@interface XDYIphonePublishView ()

@property (weak, nonatomic) IBOutlet UIButton *hangup;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

@end

@implementation XDYIphonePublishView
- (IBAction)publishVideo:(UIButton *)sender {
    if (self.publishBlock) {
        [self publishVideo];
        self.publishBlock();
    }
    
}
- (IBAction)unPublishVideo:(UIButton *)sender {
    
    if (self.unPublishBlock) {
        [self unpublishVideo];
        self.unPublishBlock();
    }
}

- (void)publishVideo{
    _publishView.hidden = NO;
    _hangup.hidden = NO;
    _publishBtn.hidden = YES;
}
- (void)unpublishVideo{
    _publishView.hidden = YES;
    _hangup.hidden = YES;
    _publishBtn.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
