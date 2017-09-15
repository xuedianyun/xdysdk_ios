//
//  DocForPadView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/24.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XDYDrawView.h"

@interface DocForPadView : UIView


@property (nonatomic, strong)  UIScrollView *scrollView;

@property (nonatomic, strong)  XDYDrawView  *drawView;


-(void)setDocFile:(NSString *)url;

-(void)setCursorX:(CGFloat)x Y:(CGFloat)y;


- (void)setWriteBoard:(NSDictionary *)message
       annotaionArray:(void(^)(id data))annotationArray;

@end
