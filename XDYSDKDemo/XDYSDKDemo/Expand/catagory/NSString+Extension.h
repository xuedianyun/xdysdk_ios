//
//  NSString+Extension.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/29.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
