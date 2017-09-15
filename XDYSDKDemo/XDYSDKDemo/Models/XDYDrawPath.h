//
//  DrawPath.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//
//  标注绘制model

#import <UIKit/UIKit.h>

@interface XDYDrawPath:NSObject

+(id)drawPathWithCGPath:(CGPathRef)drawPath
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth;

@property (strong, nonatomic)UIBezierPath *drawPath;
@property (strong, nonatomic)UIColor *drawColor;
@property (assign, nonatomic)CGFloat lineWidth;

//用户选择的图像
//@property (strong, nonatomic)UIImage *image;

@end
