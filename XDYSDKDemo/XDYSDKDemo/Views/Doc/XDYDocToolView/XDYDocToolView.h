//
//  XDYDocToolView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDYSelectColorView.h"

#pragma mark - 定义块代码
#pragma mark - 工具视图的操作块代码
typedef void(^ToolViewActionBlock)(BOOL flag);
@interface XDYDocToolView:UIView
@property (nonatomic, strong) UIButton *brushBtn;


//扩展initWithFrame方法，增加块代码参数
-(id)initWithFrame:(CGRect)frame
  afterSelectColor:(SelectColorBlock)afterSelectColor
   afterSelectbrush:(ToolViewActionBlock)afterSelectbrush
   afterSelectUndo:(ToolViewActionBlock)afterSelectUndo
   afterSelectPage:(ToolViewActionBlock)afterSelectPage;

- (void)setModel:(NSDictionary *)dic;


@end
