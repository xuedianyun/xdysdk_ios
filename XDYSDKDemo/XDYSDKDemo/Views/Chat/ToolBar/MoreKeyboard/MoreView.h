//
//  MoreView.h
//  emotionDemo
//
//  Created by 3mang on 16/1/14.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreButton.h"
@interface MoreView : UIView
@property (nonatomic, strong) MoreButton *button;
@property (nonatomic, strong) MoreButton *shareButton;
@property (nonatomic, strong) MoreButton *feedbackButton;
@property (nonatomic, strong) MoreButton *reportButton;


@property (nonatomic, assign) CGFloat space;
@end
