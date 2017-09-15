//
//  HCLoadingHUD.m
//  HelperCar
//
//  Created by Jentle on 16/8/9.
//  Copyright © 2016年 Jentle. All rights reserved.
//

#import "XDYLoadingHUD.h"


static XDYLoadingHUD *loadingHUD;

@implementation XDYLoadingHUD

+ (void)showLoadingAnimationWithStatus:(NSString *)status{
    [self showLoadingAnimationForView:kWindow withStatus:status];
}

+ (void)showLoadingAnimationForView:(UIView *)view withStatus:(NSString *)status{
    
    BOOL isAddSuperView = NO;
    for (UIView *item in view.subviews) {
        if ([item isKindOfClass:[XDYLoadingHUD class]]) {
            isAddSuperView = YES;
        }
    }
    if (isAddSuperView) return;
    loadingHUD = [[XDYLoadingHUD alloc] init];
    loadingHUD.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    
//    CGFloat loadingHudHeight = kScreenHeight-kUpSpare-kTabBarHeight;
    loadingHUD.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //动画父视图
    CGFloat loadBgDefaultW = ALDHeight(240);
    CGFloat loadBgDefaultH = ALDHeight(200);
    UIView *loadBackgroundView = [[UIView alloc] init];
//    UIColor *loadBgColor = [UIColor blackColor];
//    loadBackgroundView.backgroundColor = [loadBgColor colorWithAlphaComponent:0.8];
    loadBackgroundView.backgroundColor = [UIColor clearColor];
    loadBackgroundView.layer.cornerRadius = 8.f;
    loadBackgroundView.layer.masksToBounds = YES;
    [view addSubview:loadingHUD];
    [loadingHUD addSubview:loadBackgroundView];
    
    //动态计算文字的宽度
  CGSize statusSize = [XDYCommonTool sizeForString:status font:HCFontWithPixel(28) size:CGSizeMake(CGFLOAT_MAX, ALD(28))];
    
    //复制图层
    CGFloat replicatorLWH = ALDHeight(120);
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [loadBackgroundView.layer addSublayer:replicatorLayer];
    
    //加载框宽度动态适应
    CGFloat ststusMargin = ALD(20);
    CGFloat otherMargin = ALD(28);
    statusSize.width += otherMargin;
    if (statusSize.width > loadBgDefaultW-2*ststusMargin) {
        //限制最大宽度
        if (statusSize.width > kScreenWidth - ALD(180)*2) {
            statusSize.width = kScreenWidth - ALD(180)*2;
        }
        [loadBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(loadingHUD);
            make.size.equalTo(CGSizeMake(statusSize.width + 2*ststusMargin, loadBgDefaultH));
        }];
        
        replicatorLayer.frame = CGRectMake((statusSize.width + 2*ststusMargin - replicatorLWH)*0.5, ststusMargin, replicatorLWH, replicatorLWH);

    }else{
        [loadBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(loadingHUD);
            make.size.equalTo(CGSizeMake(loadBgDefaultW, loadBgDefaultH));
        }];
        replicatorLayer.frame = CGRectMake((loadBgDefaultW-replicatorLWH)*0.5, ststusMargin, replicatorLWH,replicatorLWH);

    }
    
    //闪动点
    CALayer *dot = [CALayer layer];
    dot.bounds = CGRectMake(0, 0, 10, 10);
    dot.cornerRadius = 5;
    dot.masksToBounds = YES;
    dot.position = CGPointMake(ALDHeight(60),ALDHeight(10));
    dot.backgroundColor = XDYHexColor(@"#ffffff").CGColor;
    [replicatorLayer addSublayer:dot];
    
    NSInteger count = 12;
    replicatorLayer.instanceCount = count;
    CGFloat angel  = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    //添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CFTimeInterval duration = 1.5;
    animation.duration = duration;
    animation.fromValue = @1.0;
    animation.toValue = @0.1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [dot addAnimation:animation forKey:nil];
    replicatorLayer.instanceDelay = duration/ count;
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    //添加提示
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = XDYHexColor(@"#ffffff");
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = HCFontWithPixel(28);
    statusLabel.text = status;
    [loadBackgroundView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loadBackgroundView);
        make.bottom.equalTo(loadBackgroundView).offset(-ALDHeight(10));
        make.size.equalTo(CGSizeMake(statusSize.width, statusSize.height));
    }];
    
}


+ (void)hiddenLoadingAnimation{
    [loadingHUD removeFromSuperview];
}

@end
