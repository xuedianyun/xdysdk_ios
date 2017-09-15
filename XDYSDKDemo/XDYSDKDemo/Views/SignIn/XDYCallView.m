//
//  EBTPayActivityWithTimerView.m
//  EBTPayActivityWithTimerView
//
//  Created by ebaotong on 16/7/12.
//  Copyright © 2016年 com.csst. All rights reserved.
//

#import "XDYCallView.h"
#import "XDYActivityAlertView.h"
#import "XDYRotateAnimation.h"

#define kWeakSelf(weakSelf)  __weak __typeof(self)weakSelf = self
//主屏宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define  XDYCallViewSize  CGSizeMake(290,199)

@interface XDYCallView ()
{
    XDYActivityAlertView *callAlertView;
    NSInteger countDown;
    UIButton *_closeBtn;
    XDYRotateAnimation *rotateA;
    
}

//@property(nonatomic,strong) NSTimer *alertViewTimer;

@end

@implementation XDYCallView

+ (XDYCallView *)sharedInstance{

    static  XDYCallView *callView = nil;
    static  dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        
        callView = [[XDYCallView alloc]init];
        
    });
    
    return callView;
}
- (instancetype)init{
    
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    
    self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.8];
    self.frame = [UIScreen mainScreen].bounds;
    
    _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeBtn.frame = CGRectMake(self.frame.size.width-50, 10, 40, 40);
   
    [_closeBtn setImage:[UIImage imageNamed:@"close-normal"] forState:(UIControlStateNormal)];
    [_closeBtn setImage:[UIImage imageNamed:@"close-press"] forState:(UIControlStateHighlighted)];
    [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:_closeBtn];
    
}



-(void)onTimerClick:(NSTimer*)timer
{
    if (countDown<=0) {
        [[XDYCallView sharedInstance] dismissAlertView];
    }
    else
    {
        callAlertView.lbl_RemindDescript.text = [NSString stringWithFormat:@"%ld",(long)countDown];
        countDown--;
    }
}

+ (void)showCallTimer:(NSInteger)timerCountDown{
    

    [[XDYCallView sharedInstance]startCountDownTimer:timerCountDown];
    
}
- (void)startCountDownTimer:(NSInteger)countTimers{
    
    callAlertView.lbl_RemindDescript.text = [NSString stringWithFormat:@"%ld",(long)countTimers];
   
 
}




/**
 *  弹出框
 */
- (void)showAlertView:(NSInteger)countTimers
{
    
    NSArray *xib_View = [[NSBundle mainBundle] loadNibNamed:@"XDYActivityAlertView" owner:self options:nil];
    callAlertView = [xib_View lastObject];
    callAlertView.frame = CGRectMake((SCREEN_WIDTH-XDYCallViewSize.width)/2.0, (SCREEN_HEIGHT-XDYCallViewSize.height)/2.0, XDYCallViewSize.width, XDYCallViewSize.height);
    
    [self addSubview:callAlertView];
    
    rotateA = [[XDYRotateAnimation alloc] initWithFrame:CGRectMake(CGRectGetWidth(callAlertView.frame)/2-35.5, CGRectGetHeight(callAlertView.frame)/2-35.5, 71, 71)];
    [rotateA setRotateAnimationBackgroundColor:[UIColor clearColor]];
    [callAlertView addSubview:rotateA];
    
    
//    callAlertView.lbl_RemindDescript.text = [NSString stringWithFormat:@"%ld",(long)countTimers];

    [callAlertView.btn_sign addTarget:self action:@selector(btn_sign_click) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [keyWindows addSubview:self];
    callAlertView.alpha = 0;
    callAlertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
   
//    self.countDownLabel.hidden = self.duration == 0 ? YES : NO;     //duration = 0 没有限制答题时间
   
//    [self.alertViewTimer fireTimer];
    
    if (countTimers == 100000) {
        
        callAlertView.lbl_RemindSign.text = @"请进行签到";
        rotateA.hidden = YES;
        callAlertView.lbl_RemindDescript.hidden = YES;
    }else{
        
        callAlertView.lbl_RemindSign.text = @"距点名结束还剩";
//        rotateA.hidden = NO;
        
//        callAlertView.lbl_RemindDescript.hidden = NO;
    }
    [UIView animateWithDuration:0 animations:^{
        
//        [weakSelf startCountDownTimer:countTimers];
        callAlertView.alpha = 1.0;
        callAlertView.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        
        
    }];
    
    
}
- (void)btn_sign_click{
    activityCompleteHandler(@"签到");
    [self dismissAlertView];
    
}
/**
 *  移除指示器
 */
- (void)dismissAlertView{
    
    kWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3f animations:^{
        callAlertView.alpha = 0;
        callAlertView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [callAlertView removeFromSuperview];
        if (activityCompleteHandler) {
            activityCompleteHandler(@"移除");
        }
        
    } completion:^(BOOL finished) {
        
        
        
        [weakSelf removeFromSuperview];
        
        
        
    }];
    
}
- (void)showPayAlertViewWithTimer:(NSInteger)timerCountDown withAlertViewCompleteHandler:(XDYCallViewCompleteHandler)alertViewCompleteHandler{
    
    activityCompleteHandler = alertViewCompleteHandler;
    [[XDYCallView sharedInstance] showAlertView:timerCountDown];
  
    
}

+ (void)showPayActivityAlertViewWithTimer:(NSInteger)timerCountDown withAlertViewCompleteHandler:(XDYCallViewCompleteHandler)alertViewCompleteHandler{

    
    [[XDYCallView sharedInstance] showPayAlertViewWithTimer:timerCountDown withAlertViewCompleteHandler:alertViewCompleteHandler];
    
    
    
}
+ (void)closeAlertView{
    [[XDYCallView sharedInstance] dismissAlertView];
    
}
- (void)closeBtnClick{
    [self dismissAlertView];
    
}
@end
