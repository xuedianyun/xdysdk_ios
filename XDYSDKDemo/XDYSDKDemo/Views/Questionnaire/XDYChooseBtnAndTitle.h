//
//  XDYChooseBtnAndTitle.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/2.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDYChooseBtnAndTitleDelegate <NSObject>

-(void)selectBtn:(UIButton*)sender;

@end

@interface XDYChooseBtnAndTitle : UIView

@property(nonatomic)BOOL isSelect;

@property(nonatomic,weak)id<XDYChooseBtnAndTitleDelegate>delegate;

-(void)setTitle:(NSString*)title;

@end
