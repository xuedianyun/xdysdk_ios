//
//  XDYGetLabelRect.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/30.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XDYGetLabelRect : NSObject
+ (CGRect)getAttributedStringHeight:(NSString*)strDes andSpaceWidth:(CGFloat)fWidth andFont:(UIFont*)font;

@end

