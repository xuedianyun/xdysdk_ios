//
//  XDY_CameraVC.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import <UIKit/UIKit.h>

@class XDY_CameraVC;
@protocol  XDY_CameraVCDelegate<NSObject>
@optional
- (void)XDYCameraVC:(XDY_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo;
- (void)XDYCameraCancel;

@end

@interface XDY_CameraVC : UIViewController
@property (nonatomic , assign)id<XDY_CameraVCDelegate> delegate;
@end
