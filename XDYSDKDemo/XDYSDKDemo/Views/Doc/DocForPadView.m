//
//  DocForPadView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/24.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "DocForPadView.h"



@interface DocForPadView ()
@property (strong, nonatomic)  UIImageView  *displayView;
@end

@implementation DocForPadView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.scrollEnabled = YES;//控制是否可以滚动
        _scrollView.userInteractionEnabled = YES;//控制是否可以响应用户点击事件（touch）
        [self addSubview:_scrollView];
        _displayView = [[UIImageView alloc]init];
        _displayView.backgroundColor = [UIColor clearColor];
        _displayView.contentMode = UIViewContentModeScaleAspectFit;
        _displayView.userInteractionEnabled = YES;
        [_scrollView addSubview:_displayView];
        _drawView = [[XDYDrawView alloc]init];
        [_displayView addSubview:_drawView];
        
//        _cursorView = [[XDYCursorView alloc]init];
//        [_displayView addSubview:_cursorView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _drawView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _displayView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.scrollView.contentSize = self.displayView.frame.size;
    
    self.scrollView.canCancelContentTouches = NO;//是否可以中断touches
   
    
}

-(void)setDocFile:(NSString *)url{
    
    __weak typeof(self) weakSelf = self;
    
    [_displayView setImageWithURL:[NSURL URLWithString:url] placeholder:self.displayView.image options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        CGSize size = image.size;
        CGFloat w = weakSelf.frame.size.width;
        CGFloat h = weakSelf.frame.size.height;
        
        if (image.size.width > 0 && image.size.height > 0) {
            h = size.height *(w/size.width);
        }
        
        CGFloat y = (self.height-h)*0.5;
        y = y>0 ? y:0;
        
        weakSelf.displayView.frame = CGRectMake(0, y, weakSelf.frame.size.width, h);
        weakSelf.drawView.frame = weakSelf.displayView.bounds;
        weakSelf.scrollView.contentSize = weakSelf.displayView.frame.size;
        
    }];
    
}

-(void)setCursorX:(CGFloat)x Y:(CGFloat)y{
    [self.drawView setCursorX:x Y:y];
    
}

- (void)setWriteBoard:(NSDictionary *)message
       annotaionArray:(void(^)(id data))annotationArray
{
    if ([message[@"isFresh"] boolValue]) {
        //清空画面
        [self.drawView clearScreen];
        
    }
    NSArray *anno = message[@"annotaionItems"];
    for (int i = 0; i<anno.count; i++) {
        
        NSString *color = anno[i][@"color"];
        CGFloat lineWidth = [anno[i][@"thickness"] floatValue];
        NSArray *pointGroup = anno[i][@"pointGroup"];
        
        //                        if ((initiator !=_nodeId) && [message[@"isFresh"]boolValue]) {
        NSMutableArray *pointArray = [NSMutableArray array];
        for (int j = 0; j<pointGroup.count; j++) {
            
            NSDictionary *dic = pointGroup[j];
            float x = [dic[@"w"] floatValue]/100.0 * CGRectGetWidth(self.frame);
            float y = [dic[@"h"] floatValue]/100.0 * CGRectGetWidth(self.frame);
            
            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            
        }
        
        [self.drawView drawPath:pointArray drawColor:XDYHexColor(color) lineWidth:lineWidth];
        
        
    }
    annotationArray(anno);
    
}

- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)setImageOriginal:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
