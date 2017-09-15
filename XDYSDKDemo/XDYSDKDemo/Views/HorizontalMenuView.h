//
//  HorizontalMenuView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/10.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 ***自定义协议
 */

@protocol HorizontalMenuProtocol <NSObject>

@optional//可选的方法
//
//@required//必须实现的

-(void)getTag:(NSInteger)tag;//获取当前被选中下标值
-(void)isHand:(BOOL)hand;
- (void)isBrush:(BOOL)brush;

@end


@interface HorizontalMenuView : UIView


    
@property (nonatomic, strong)NSArray *menuArray;//获取到的菜单名数组

@property (nonatomic, strong)UIButton *handButton;

@property (nonatomic, strong)UIButton *brushButton;

-(void)setNameWithArray:(NSArray*)menuArray menuModel:(int)menuModel;//设置菜单名方法


//协议委托代理
@property (nonatomic,assign)id <HorizontalMenuProtocol> myDelegate;

- (void)setModel:(NSDictionary *)message;

@end


