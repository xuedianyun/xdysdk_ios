//
//  XDYPublishView.h
//  AgoraiOS
//
//  Created by lyy on 2017/8/30.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYPublishView : UIView

@property (weak, nonatomic) IBOutlet UIView *publishView;


@property(nonatomic,copy)void (^publishBlock)();


@property(nonatomic,copy)void (^unPublishBlock)();

- (void)hiddenCamera:(BOOL)flag isMax:(BOOL)max;

- (void)publishVideo;
- (void)unpublishVideo;

@end
