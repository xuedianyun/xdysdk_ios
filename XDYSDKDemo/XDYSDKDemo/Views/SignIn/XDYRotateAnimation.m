//
//  RotateAnimation.m
//  Layer
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XDYRotateAnimation.h"
#import <QuartzCore/QuartzCore.h>


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define  XDYCallViewSize  CGSizeMake(290,199)

@implementation XDYRotateAnimation

-(void)createAnimation:(float)startAngle andEndAngle:(float)endAngle andType:(int)type
{
        //创建运转动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	pathAnimation.calculationMode = kCAAnimationPaced;
	pathAnimation.fillMode = kCAFillModeForwards;
	pathAnimation.removedOnCompletion = NO;
	pathAnimation.duration = 1.0;
	pathAnimation.repeatCount = 1000; //旋转多少圈
        //设置运转动画的路径
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, self.frame.size.width/2, self.frame.size.height/2, 33.5, startAngle, endAngle, 0);
    pathAnimation.path = curvedPath;
	CGPathRelease(curvedPath);
    
    float x = 30;
    
    circleView1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:circleView1];
    circleView1.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, x, x);
    [circleView1 setImage:[self setImageOriginal:@"ball"] forState:(UIControlStateNormal)];
    
    
           //设置放大的动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    circleView1.transform=CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
            //设置运转的动画
    [circleView1.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
   
}


//创建圆形路径
-(void)crearArcBackground
{
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x3498db).CGColor);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, 33.5, 0, 2*M_PI, 1);
	CGContextDrawPath(ctx, kCGPathStroke);
	UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = curve;
    [self addSubview:imageView];
    
//    imageView.backgroundColor = [UIColor redColor];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self crearArcBackground];
        [self createAnimation: M_PI / 6 andEndAngle:M_PI / 6 + 2 * M_PI andType: 1];
    }
    return self;
}
- (UIImage *)setImageOriginal:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
    
}
-(void)setRotateAnimationBackgroundColor:(UIColor *)aColor
{
    self.backgroundColor = aColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
