//
//  EBTPayActivityAlertView.m
//  EBTPayActivityWithTimerView
//
//  Created by ebaotong on 16/7/12.
//  Copyright © 2016年 com.csst. All rights reserved.
//

#import "XDYActivityAlertView.h"

@implementation XDYActivityAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.f;
}


@end
