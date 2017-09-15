//
//  XDYHtmlDocView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDYDrawView.h"

typedef void(^BLOCK)(id type, id message);


@interface XDYHtmlDocView : UIView


@property (nonatomic, strong)  XDYDrawView  *drawView;
@property (nonatomic, copy) BLOCK  XDYDocBlock;


- (void)loadDOCServerIP:(NSString *)ip;

- (void)setSrc:(NSString *)url;

- (void)prePage;

- (void)nextPage;

- (void)jumpPage:(int)num;

- (void)preStep;

- (void)nextStep;

- (void)getMessageXDYDocBlock:(BLOCK)XDYDocBlock;

-(void)setCursorX:(CGFloat)x Y:(CGFloat)y;

- (void)setWriteBoard:(NSDictionary *)message
       annotaionArray:(void(^)(id data))annotationArray;



@end
