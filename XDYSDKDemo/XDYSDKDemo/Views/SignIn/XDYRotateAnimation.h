//
//  RotateAnimation.h
//  Layer
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义三个圆
enum
{
    firstArc = 1,
};

@interface XDYRotateAnimation : UIView
{
    UIButton *circleView1;
}

-(void)setRotateAnimationBackgroundColor:(UIColor *)aColor;


@end
