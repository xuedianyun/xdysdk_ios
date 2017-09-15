//
//  XDYIphonePublishView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/2.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYIphonePublishView : UIView
@property (weak, nonatomic) IBOutlet UIView *publishView;

@property(nonatomic,copy)void (^publishBlock)();


@property(nonatomic,copy)void (^unPublishBlock)();

- (void)publishVideo;
- (void)unpublishVideo;

@end
