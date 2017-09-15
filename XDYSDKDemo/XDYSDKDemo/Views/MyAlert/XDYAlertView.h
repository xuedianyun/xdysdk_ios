//
//  ILSMLAlertView.h
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
alertLeftBackgrColor:(UIColor *)leftBackrColor
alertRightBackgrColor:(UIColor *)rightBackrColor;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
