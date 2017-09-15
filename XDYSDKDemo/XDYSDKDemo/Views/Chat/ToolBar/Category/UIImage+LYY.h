//
//  UIImage+LYY.h
//  LYYWeibo
//
//  Created by lanou3g on 15/10/10.
//  Copyright (c) 2015年 李岩岩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYY)

/*
 *加载图片
 */
+ (UIImage *)imageWithName:(NSString *)name;


/*
 *返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
@end
