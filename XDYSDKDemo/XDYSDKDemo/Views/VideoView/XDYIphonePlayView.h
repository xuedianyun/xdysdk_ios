//
//  XDYIphonePlayView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/1.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYIphonePlayView : UIView
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property(nonatomic,copy)void (^backBlock)();

- (void)hiddenLayer;
- (void)showLayer;

@end
