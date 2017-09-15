//
//  MessageFrame.h
//  QQ聊天布局
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MessageInfo.h"

#define kMargin 5 //间隔
#define kIconWH 30 //头像宽高
#define kNameW 40 //用户名宽度
#define kNameH 15  //用户名高度
//#define kContentW 160 //内容宽度

#define kTimeMarginW 15 //时间文本与边框间隔宽度方向
#define kTimeMarginH 10 //时间文本与边框间隔高度方向

//#define kContentTop 10 //文本内容与按钮上边缘间隔
//#define kContentLeft 25 //文本内容与按钮左边缘间隔
//#define kContentBottom 15 //文本内容与按钮下边缘间隔
//#define kContentRight 15 //文本内容与按钮右边缘间隔

#define kContentTop 10 //文本内容与按钮上边缘间隔
#define kContentLeft 10 //文本内容与按钮左边缘间隔
#define kContentBottom 10 //文本内容与按钮下边缘间隔
#define kContentRight 5 //文本内容与按钮右边缘间隔

#define kTimeFont [UIFont systemFontOfSize:12] //时间字体

#define kTeacherFont [UIFont systemFontOfSize:10] //时间字体
#define kContentFont [UIFont systemFontOfSize:16] //内容字体

#import <Foundation/Foundation.h>

@class Message;

@interface MessageFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconF;

@property (nonatomic, assign, readonly) CGRect teachF;

@property (nonatomic, assign, readonly) CGRect nameF;

@property (nonatomic, assign, readonly) CGRect timeF;

@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGRect sendF;

@property (nonatomic, assign) CGFloat kContentW;


@property (nonatomic, assign, readonly) CGFloat cellHeight; //cell高度

@property (nonatomic, strong) MessageInfo *messageInfo;

@property (nonatomic, assign) BOOL showTime;

@end
