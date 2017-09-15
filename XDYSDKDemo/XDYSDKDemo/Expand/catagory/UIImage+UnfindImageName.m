//
//  UIImage+UnfindImageName.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/4/12.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import "UIImage+UnfindImageName.h"
#import <objc/runtime.h>

@implementation UIImage (UnfindImageName)
+ (void)load {
#ifdef DEBUG
    Method oldMethod = class_getClassMethod([self class], @selector(imageNamed:));
    Method newMethod = class_getClassMethod([self class], @selector(customImageNamed:));
    method_exchangeImplementations(oldMethod, newMethod);
#endif
    
}
+ (UIImage *)customImageNamed:(NSString *)name {
    
    UIImage *image = [self customImageNamed:name];
//    if (!image) {
//        NSLog(@"%@",[NSString stringWithFormat:@"imageName: %@ is undefined", name]);
//    }
    NSAssert(image != nil, ([NSString stringWithFormat:@"imageName: %@ is undefined", name]));
    
    return image;
}
@end
