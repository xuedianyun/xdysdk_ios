//
//   XDYSelectColorView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYSelectColorView.h"


#define kButtonSpace 10.0

@interface XDYSelectColorView()
{
    //选择颜色的块代码变量
    SelectColorBlock _selectColorBlock;
}

@property (strong, nonatomic)NSArray *colorArray;

@end

@implementation XDYSelectColorView

-(id)initWithFrame:(CGRect)frame afterSelectColor:(SelectColorBlock)afterSelectColor
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _selectColorBlock = afterSelectColor;
        [self setBackgroundColor:kUIColorFromRGB(0xe3e4e6)];
        
        //绘制颜色的按钮
        NSArray *array = @[kUIColorFromRGB(0x0071bc),
                           kUIColorFromRGB(0xb8242a),
                           kUIColorFromRGB(0x6a0db2),
                           kUIColorFromRGB(0xfae81b)
                           ];
        self.colorArray = array;
        [self createColorButtonsWithArray:array];
        
    }
    return self;
}

#pragma mark - 绘制颜色的按钮
-(void)createColorButtonsWithArray:(NSArray *)array
{
    //1.计算按钮的位置
    //2.设置按钮的颜色，需要使用数组
    //需要按钮的宽度，起始点位置
    NSInteger index = 0;
    NSInteger count = array.count;
//    CGFloat width = 40;
    CGFloat height = self.bounds.size.height;
    
    for(int i= 0;i<count;i++){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat startX = kButtonSpace + index * (height - 10 + kButtonSpace);
        [button setFrame:CGRectMake(startX, kButtonSpace / 2, height - 10, height - 10)];
        //设置按钮背景颜色
        [button setBackgroundColor:array[index]];
        [button setTag:index];
        
        
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.cornerRadius = 5;

        index++;
    }
}

#pragma mark - 按钮监听方法
-(void)tapButton:(UIButton *)button
{
    //调用块代码
    _selectColorBlock(self.colorArray[button.tag]);
    [self removeFromSuperview];
    
}


@end
