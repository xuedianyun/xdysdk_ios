//
//  XDYQuestionnaireView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYQuestionnaireView.h"
#import "XDYCheckGroup.h"
#import "XDYFillView.h"


#define XDYRGBHex(rgbValue)                                                       \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0         \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0            \
blue:((float)(rgbValue & 0xFF)) / 255.0                     \
alpha:1.0]

@interface XDYQuestionnaireView ()
{
    UIButton *submitBtn;
    UIButton *cancelBtn;
    
}
/**
 问卷的答题时间（指定情况最多支持1个小时），如果为0则为无限答题时间
 */
@property (nonatomic) NSTimeInterval            duration;
@property (nonatomic) CGFloat                   originHeight;
@property (nonatomic, strong) NSTimer           *timer;

@property (nonatomic, strong) UILabel           *countDownLabel;

@property (nonatomic, assign) BOOL              isCheck;

@property (nonatomic, strong) NSArray           *titleArray;
@property (nonatomic, strong) XDYCheckGroup      *checkGroup;

@property (nonatomic, strong) UIView            *backView;

@property (nonatomic, strong) UIView            *fillView;
@property (nonatomic, strong) NSMutableArray    *fillArray;

@property (nonatomic, strong) UIScrollView      *backScrollView;

@property (nonatomic, strong) UIButton          *spreadBtn;

@property (nonatomic, assign) BOOL              isSpread;

@property (nonatomic, strong) NSMutableArray    *resultArray; //答题结果

@property (nonatomic, strong) UIView            *successView;


@end


@implementation XDYQuestionnaireView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self initSubViews];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

#pragma mark privatte
- (void)initSubViews {
    _resultArray = [NSMutableArray array];
    
    [self addSubview:self.backView];
    
    if (!isPad) {
        [self addSubview:self.spreadBtn];
    }
    
}

- (void)countDown {
    self.countDownLabel.text = [NSString stringWithFormat:@"%@s",[self formatDuration:self.duration]];
    self.countDownLabel.textColor = XDYRGBHex(0xd95136);
    
    //没有时间了，关闭了吧
    if (self.duration == 0) {
        [self hide];
    }
    self.duration --;
}
#pragma mark - 隐藏选项
- (void)hideQuestionViews {
    
    for(int i = 0;i<[_checkGroup.subviews count];i++){
        [ [_checkGroup.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    [_checkGroup removeFromSuperview];
    
    _checkGroup = nil;
    
    for(int i = 0;i<[_fillView.subviews count];i++){
        [ [_fillView.subviews objectAtIndex:i] removeFromSuperview];
    }
    [_fillView removeFromSuperview];
    
    [submitBtn removeFromSuperview];
    submitBtn = nil;
    [cancelBtn removeFromSuperview];
    cancelBtn = nil;
    _spreadBtn.hidden = YES;
    
    [_backScrollView removeFromSuperview];
    
    
    //    self.countDownLabel.hidden = YES;
    //    [_spreadBtn removeFromSuperview];
    //    _spreadBtn = nil;
    
}

- (void)fireTimer {
    if (self.duration > 0) {
        [self.timer fire];
    }
}

- (NSString *)formatDuration:(NSTimeInterval)duration {
    int secend = duration;
    //    minute = (secend % 3600) / 60;
    //    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d", secend];
}


#pragma mark 显示试题选项
- (void)showWithDuration:(NSTimeInterval)duration
                    type:(int)type
              titleArray:(NSArray *)titleArray
                 isCheck:(BOOL)isCheck
{
    
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.titleArray = titleArray;
    //TODO 是不是可以加个动画
    if (duration < 0) {
        return;
    }
    self.isCheck = isCheck;
    self.hidden = NO;
    _spreadBtn.hidden = NO;
    //    self.duration = duration;
    if (duration == 100000) {
        self.countDownLabel.hidden = YES;     //duration = 0 没有限制答题时间
    }else{
        self.countDownLabel.hidden = NO;
    }
    
    
    //如果结果页面还在显示则先清空结果页面
    submitBtn=[[UIButton alloc]init];
    submitBtn.backgroundColor=XDYRGBHex(0x3498db);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    
    submitBtn.layer.cornerRadius = 15.0;
    [self addSubview:submitBtn];
    
    cancelBtn=[[UIButton alloc]init];
    cancelBtn.backgroundColor=XDYRGBHex(0x999999);
    [cancelBtn setTitle:@"放弃" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 15.0;
    [self addSubview:cancelBtn];
    
    //    [self showQuestionTimer];
    self.transform =  CGAffineTransformIdentity;
    
    
    [self addSubview:self.countDownLabel];
    
    switch (type) {
        case 0:
            [self loadSelectQuestion:false];//选择题选项
            break;
        case 1:
            [self loadFillQuestion];//填空题选项
            break;
        case 2:
            [self loadSelectQuestion:true];//判断题选项  true代表横排显示
            //            [self loadJudgeQuestion];
            break;
        default:
            break;
    }
}


- (void)showQuestionTimer:(NSInteger)duration {
    self.duration = duration;
    
    [self fireTimer];
}
- (void)loadSelectQuestion:(BOOL)flag{
    
    [submitBtn addTarget:self action:@selector(submitQuestion) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *arr=[NSMutableArray array];
    
    
    
    
    CGSize answer;
    
    NSMutableArray *heightArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    for (int i = 0; i <_titleArray.count; i++) {
        NSString *title = _titleArray[i];
        answer = [title sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(self.frame.size.width-160, HUGE_VALF)];
        
        if (answer.height < 30) {
            answer.height = 30;
        }
        NSNumber *height = [NSNumber numberWithFloat:answer.height];
        NSNumber *width = [NSNumber numberWithFloat:answer.width];
        
        [heightArray addObject:height];
        [widthArray addObject:width];
     
    }
    
    NSArray *array = [widthArray sortedArrayUsingComparator:cmptr];
    NSString *max = [array lastObject];
    
    
    if ([max intValue]<15 && (!isPad)) {
        flag = true;
    }
    if ([max intValue]<60 && isPad) {
        flag = true;
    }
    CGFloat y= 5;
    if (flag) {
        
        submitBtn.frame = CGRectMake(self.frame.size.width-119, 5,52,30);
        cancelBtn.frame = CGRectMake(self.frame.size.width-62,5, 52, 30);
        _spreadBtn.hidden = YES;
        _backView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1);
        for (int i = 0; i <_titleArray.count; i++) {
            CGFloat width = [widthArray[i] floatValue];
            
            XDYChooseBtnAndTitle *view = [[XDYChooseBtnAndTitle alloc]initWithFrame:CGRectMake((width+30)*i, y, width+30, 30)];
            view.tag = 1000 + i;
            [view setTitle:_titleArray[i]];
            [arr addObject:view];
            
        }

    }else{
        
        submitBtn.frame = CGRectMake(self.frame.size.width-70,23,52,30);
        cancelBtn.frame = CGRectMake(self.frame.size.width-70,55,52,30);
        
        _spreadBtn.hidden = NO;
        
        _spreadBtn.frame =CGRectMake(self.frame.size.width-36, 0, 36, 21);
        
        _backView.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-1);
        _isSpread = YES;
        
        
        
        
//        for (int i = 0; i <_titleArray.count; i++) {
//            CGFloat height = [heightArray[i] floatValue];
//            
//            XDYChooseBtnAndTitle *view = [[XDYChooseBtnAndTitle alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width-120, height)];
//            view.tag = 1000 + i;
//            [view setTitle:_titleArray[i]];
//            [arr addObject:view];
//            
//            y+=height+5;
//        }
    
        int pointx = 0, pointY = 0;
        
        for ( int i = 0; i < [_titleArray count]; ++i ){
            
            CGFloat height = [heightArray[i] floatValue];
            if ( (pointx + [widthArray[i] integerValue] + 40) >  (self.frame.size.width-90)){
                pointx = 0;
                pointY += [heightArray[i-1] floatValue];
            
            }
            XDYChooseBtnAndTitle *view = [[XDYChooseBtnAndTitle alloc]initWithFrame:CGRectMake(pointx+5, pointY, [widthArray[i] integerValue]+40, height)];
            pointx += [widthArray[i] integerValue]+40;
            view.tag = 1000 + i;
            [view setTitle:_titleArray[i]];
            [arr addObject:view];
            
        }

    }
    
    
    
    if (flag) {
        
        _checkGroup=[[XDYCheckGroup alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-120, self.frame.size.height) WithCheckBtns:arr];
    }else{
        
        _checkGroup=[[XDYCheckGroup alloc]initWithFrame:CGRectMake(0, 21, self.frame.size.width-120, self.frame.size.height) WithCheckBtns:arr];
    }
    _countDownLabel.frame = CGRectMake(0, 0, 60, 15);
    
    
    _checkGroup.isCheck=_isCheck;
    
    _checkGroup.backgroundColor=[UIColor clearColor];
    [self addSubview:_checkGroup];
    
    
    
}

NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

- (void)loadFillQuestion{
    [submitBtn addTarget:self action:@selector(submitFillQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    for(int i = 0;i<[_fillView.subviews count];i++){
        [ [_fillView.subviews objectAtIndex:i] removeFromSuperview];
    }
    [_fillView removeFromSuperview];
    
    
    [self.backView addSubview:self.backScrollView];
    
    if (_titleArray.count>1 && (!isPad)) {
        
        _fillView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width-90, self.frame.size.width-60)];
        _countDownLabel.frame = CGRectMake(0, self.frame.size.height-78, 60, 15);
        _backView.frame = CGRectMake(0, self.frame.size.height-79, self.frame.size.width, 79);
        _backScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_backView.frame), CGRectGetHeight(_backView.frame));
        _spreadBtn.frame =CGRectMake(self.frame.size.width-36, self.frame.size.height-99, 36, 21);
        submitBtn.frame = CGRectMake(self.frame.size.width-60, 30, 50, 29);
        cancelBtn.frame = CGRectMake(self.frame.size.width-60, 65, 50, 29);
        
        [_spreadBtn setBackgroundImage:[UIImage imageNamed:@"foldBack"] forState:(UIControlStateNormal)];
        _isSpread = YES;
        
    }else{
        
        _fillView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width-130, 40)];
        _countDownLabel.frame = CGRectMake(0, self.frame.size.height-48, 60, 15);
        _backView.frame = CGRectMake(0, self.frame.size.height-49, self.frame.size.width, 49);
        _backScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_backView.frame), CGRectGetHeight(_backView.frame));
        _spreadBtn.frame =CGRectMake(self.frame.size.width-36, self.frame.size.height-69, 36, 21);
        submitBtn.frame = CGRectMake(self.frame.size.width-119, self.frame.size.height-39, 52, 29);
        cancelBtn.frame = CGRectMake(CGRectGetMaxX(submitBtn.frame)+5, self.frame.size.height-39, 52, 29);
        _spreadBtn.hidden = YES;
        
    }
    
    _fillView.backgroundColor=[UIColor clearColor];
    [_backScrollView addSubview:_fillView];
    
    int margin = 5;//行间距
    int width;//现象的宽度
    int height = 30;//选项的高度
    _fillArray = [NSMutableArray array];
    
    for (int i = 0; i <_titleArray.count; i++) {
        int row;
        int col;
        
        if (isPad) {
            row = i/6;
            col = i%6;
            width =  (self.frame.size.width-160)/6;
        }else{
            row = i/3;
            col = i%3;
            
            width =  (self.frame.size.width-CGRectGetWidth(submitBtn.frame)-50)/3;
        }
        XDYFillView *fill = [[XDYFillView alloc]initWithFrame:CGRectMake(10+col*(width+margin), row*(height+3), width, height)];
        fill.backgroundColor = [UIColor clearColor];
        [self.fillView addSubview:fill];
        [_fillArray addObject:fill];
        
    }
    
    [self fireTimer];
}


- (void)submitQuestion{
    
    self.transform = CGAffineTransformIdentity;
    
    
    for (int i=0; i<_checkGroup.selectValueArr.count; i++) {
        
        NSInteger intager = [_checkGroup.selectValueArr[i] integerValue];
        
        NSNumber *answer = [NSNumber numberWithInteger:intager-1000];
        
        //        [_resultArray addObject:_titleArray[intager-1000]];
        [_resultArray addObject:answer];
        _answerButtonClick(@"",_resultArray);
    }
    
    
    //    [UIView animateWithDuration:0.5 animations:^{
    //    } completion:^(BOOL finished) {
    
    //        [self showSuccessView:0];
    //    }];
    if (_resultArray.count != 0) {
        [self hideQuestionViews];
        [self hide];
    }
    
    
    
}

-(void)submitFillQuestion{
    self.transform = CGAffineTransformIdentity;
    for (XDYFillView *view in _fillArray) {
        [_resultArray addObject:view.result.text];
    }
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        [self hideQuestionViews];
        //        [self showSuccessView:1];
    }];
    
}
#pragma mark - 提交结果页面
- (void)showSuccessView:(int)type {
    
    _successView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _successView.backgroundColor = XDYRGBHex(0xf1f1f1);
    _successView.layer.borderColor = XDYRGBHex(0xd1d1d1).CGColor;
    _successView.layer.borderWidth = 0.5;
    [self addSubview:_successView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 65, 30)];
    
    label.text = [NSString stringWithFormat:@"我的答案:"];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = XDYRGBHex(0x333333);
    [self.successView addSubview:label];
    
    for (int i=0; i<_resultArray.count; i++) {
        switch (type) {
            case 0:
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85+25*(i), 21, 18, 18)];
                label.font = [UIFont systemFontOfSize:14];
                label.text = _resultArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = XDYRGBHex(0x3498db);
                label.layer.cornerRadius = 9;
                label.clipsToBounds = YES;
                [self.successView addSubview:label];
            }
                break;
            case 1:
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85+50*(i), 20, 50, 20)];
                label.text = _resultArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                [self.successView addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 19, 50, 1)];
                lineView.backgroundColor = XDYRGBHex(0xd1d1d1);
                [label addSubview:lineView];
            }
                break;
            default:
                break;
        }
    }
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 80, 30)];
    successLabel.text = [NSString stringWithFormat:@"正确答案:"];
    successLabel.font = [UIFont systemFontOfSize:14];
    [self.successView addSubview:successLabel];
    successLabel.textColor = XDYRGBHex(0x333333);
    
    
    for (int i=0; i<_resultArray.count; i++) {
        switch (type) {
            case 0:
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85+25*(i), 60, 18, 18)];
                label.font = [UIFont systemFontOfSize:16];
                label.text = _resultArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = XDYRGBHex(0xd95136);
                label.layer.cornerRadius = 9;
                label.clipsToBounds = YES;
                [self.successView addSubview:label];
            }
                break;
            case 1:
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85+50*(i), 60, 50, 20)];
                label.text = _resultArray[i];
                label.textAlignment = NSTextAlignmentCenter;
                [self.successView addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 19, 50, 1)];
                lineView.backgroundColor = XDYRGBHex(0xd1d1d1);
                [label addSubview:lineView];
            }
                break;
            default:
                break;
        }
    }
    
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-62,self.frame.size.height/2-15,52,30)];
    closeBtn.backgroundColor=XDYRGBHex(0x3498db);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.layer.cornerRadius = 15.0;
    [self.successView addSubview:closeBtn];
    
}
#pragma mark - 隐藏所有内容
- (void)hide {
    [self.checkGroup removeAllCheckBtn];
    
    for(int i = 0;i<[_checkGroup.subviews count];i++){
        [ [_checkGroup.subviews objectAtIndex:i] removeFromSuperview];
    }
    [self.checkGroup removeFromSuperview];
    [submitBtn removeFromSuperview];
    submitBtn = nil;
    [cancelBtn removeFromSuperview];
    cancelBtn = nil;
    self.checkGroup = nil;
    
    for(int i = 0;i<[_fillView.subviews count];i++){
        [ [_fillView.subviews objectAtIndex:i] removeFromSuperview];
    }
    [_fillView removeFromSuperview];
    
    for(int i = 0;i<[_successView.subviews count];i++){
        [ [_successView.subviews objectAtIndex:i] removeFromSuperview];
    }
    [self.successView removeFromSuperview];
    self.successView = nil;
    [_resultArray removeAllObjects];
    
    //TODO 是不是可以加个动画
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview];
    
}
#pragma mark getter
- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.textColor = XDYRGBHex(0xFFFFFF);
        _countDownLabel.font = [UIFont systemFontOfSize:12];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.backgroundColor = [UIColor whiteColor];
    }
    return _countDownLabel;
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}



- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = XDYRGBHex(0xf1f1f1);
        _backView.layer.borderColor = XDYRGBHex(0xd1d1d1).CGColor;
        _backView.layer.borderWidth = 0.5;
        
    }
    return _backView;
}
- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]init];
        _backScrollView.backgroundColor = [UIColor clearColor];
        
    }
    return _backScrollView;
}

- (UIButton *)spreadBtn {
    if (!_spreadBtn) {
        _spreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_spreadBtn setBackgroundImage:[UIImage imageNamed:@"foldBack"] forState:(UIControlStateNormal)];
        [_spreadBtn addTarget:self action:@selector(spreadBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _spreadBtn;
}
- (void)spreadBtnClick{
    
    if (_isSpread) {
        
        
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height - 60);
        cancelBtn.hidden = YES;
        
        [_spreadBtn setBackgroundImage:[UIImage imageNamed:@"spreadBack"] forState:(UIControlStateNormal)];
        _isSpread = false;
        
    }else{
        
        self.transform =  CGAffineTransformIdentity;
        
        cancelBtn.hidden = NO;
        
        [_spreadBtn setBackgroundImage:[UIImage imageNamed:@"foldBack"] forState:(UIControlStateNormal)];
        _isSpread = true;
    }
    
}

#pragma mark util
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)getAnswerXDYBlock:(AnswerButtonClick)answerButtonClick{
    _answerButtonClick = answerButtonClick;
}
@end
