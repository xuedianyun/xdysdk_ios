//
//  XDY_ChoicePictureVC.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class XDY_ChoicePictureVC;

@protocol  XDY_ChoicePictureVCDelegate<NSObject>
@optional
- (void)XDYChoicePictureVC:(XDY_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr;

@end

@interface XDY_ChoicePictureVC : UIViewController
@property (nonatomic , assign)id <XDY_ChoicePictureVCDelegate> delegate;
@property (nonatomic , assign)NSInteger maxChoiceImageNumber;
@property (nonatomic , strong) ALAssetsGroup  * assetsGroup;
@end
