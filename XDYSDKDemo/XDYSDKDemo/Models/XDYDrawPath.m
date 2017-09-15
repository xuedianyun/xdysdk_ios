//
//  DrawPath.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYDrawPath.h"

@implementation XDYDrawPath

+(id)drawPathWithCGPath:(CGPathRef)drawPath
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth
{
    XDYDrawPath *path = [[XDYDrawPath alloc]init];
    
    path.drawPath = [UIBezierPath bezierPathWithCGPath:drawPath];
    
    path.drawPath.lineCapStyle = kCGLineCapRound; //线条拐角
    path.drawPath.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    path.drawColor = color;
    path.lineWidth = lineWidth;
    
    return path;
}


@end
