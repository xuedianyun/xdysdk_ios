//
//  XDYDocModel.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDYDocModel : NSObject

@property (nonatomic, strong) NSString                       *htmlDocUrl;
@property (nonatomic, assign) int                            animationStep;
@property (nonatomic, assign) int                            aniStepFirst;
@property (nonatomic, assign) BOOL                           isFirstStep;
@property (nonatomic, assign) int                            curPageNo;
@property (nonatomic, strong) NSString                       *docVisible;

@end
