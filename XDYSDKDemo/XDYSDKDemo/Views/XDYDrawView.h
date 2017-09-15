//
//  XDYDrawView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol XDYDrawViewDelegate <NSObject>
@optional
- (void)XDYDrawrawPath:(NSArray *)array drawColor:(UIColor *)color drawWidth:(CGFloat)drawWidth;
@end

@interface XDYDrawView : UIView

@property (nonatomic,strong)UIView *cursorView;


@property (nonatomic, weak) id<XDYDrawViewDelegate> delegate;


-(void)setCursorX:(CGFloat)x Y:(CGFloat)y;

- (void)setDrawColor:(UIColor *)color;

- (void)openDrawlineWidth:(CGFloat)lineWidth;

- (void)closeDraw;

-(void)drawPath:(NSArray *)pathArray drawColor:(UIColor *)drawColor lineWidth:(CGFloat)lineWidth;

-(void)undoStep;

-(void)clearScreen;

@end
