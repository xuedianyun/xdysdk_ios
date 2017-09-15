//
//  XDY_PictureListVC.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XDY_ChoicePictureVC.h"

@protocol  XDY_ChoicePictureListVCDelegate<NSObject>
@optional
- (void)XDYPictureCancel;

@end

@interface XDY_PictureListVC : UIViewController
@property (nonatomic , assign)id <XDY_ChoicePictureVCDelegate> delegate;
@property (nonatomic, assign) id <XDY_ChoicePictureListVCDelegate> picDelegate;
@property (nonatomic , assign)NSInteger maxChoiceImageNumberumber;
@end
