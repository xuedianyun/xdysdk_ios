//
//  HCCommonTool.h
//  HCLoadingHUDDemo
//
//  Created by Jentle on 16/9/1.
//  Copyright © 2016年 Jentle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYCommonTool : NSObject

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font size:(CGSize)size;

/**
 *  字符串转色值
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;
+ (BOOL)isEmpty:(NSString *)str;

+ (NSString *) md5:(NSString *) input;
+ (UIImage *)setImageOriginal:(NSString *)imageName;
@end
