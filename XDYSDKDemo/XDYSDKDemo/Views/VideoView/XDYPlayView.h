//
//  XDYPlayView.h
//  AgoraiOS
//
//  Created by lyy on 2017/8/30.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDYPlayView : UIView

@property (weak, nonatomic) IBOutlet UIView *playView;

@property (nonatomic, assign) int uid;
/**
 *  @b 是否在播放
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

- (void)isStudent;

- (void)hiddenLayer;
- (void)showLayer;
@end
