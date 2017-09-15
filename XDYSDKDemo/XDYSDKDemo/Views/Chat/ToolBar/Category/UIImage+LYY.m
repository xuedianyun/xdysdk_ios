//
//  UIImage+LYY.m
//  LYYWeibo
//
//  Created by lanou3g on 15/10/10.
//  Copyright (c) 2015年 李岩岩. All rights reserved.
//

#import "UIImage+LYY.h"

@implementation UIImage (LYY)

+ (UIImage *)imageWithName:(NSString *)name
{
    if (1) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
}

@end
