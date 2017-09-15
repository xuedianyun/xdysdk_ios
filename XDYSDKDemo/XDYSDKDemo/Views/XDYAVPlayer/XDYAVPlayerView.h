//
//  AVPlayerView.h
//  RePlay
//
//  Created by lyy on 2017/2/16.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYAVPlayerDefine.h"


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@protocol XDYAVPlayerViewDelegate <NSObject>

-(void)currentPlayTime:(float)time totalTime:(float)totalTime;

@end

@interface XDYAVPlayerView : UIView

@property (nonatomic, assign) id<XDYAVPlayerViewDelegate> delegate;

/**
 *  @b 是否在播放
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
 *  @b 视频的总长度
 */
@property (nonatomic, assign,) float totalSeconds;

/**
 * @b 视频源urlStr
 */
@property (nonatomic, copy) NSString * videoUrlStr;

/**
 *  @b avplayerItem主要用来监听播放状态
 */
@property (nonatomic, strong) AVPlayerItem * avplayerItem;

/**
 * @b 暂时性的销毁播放器, 用于节省内存, 再用时可以回到销毁点继续播放
 */
@property (nonatomic, assign) float seekTempTime;

/**
 *播放暂停按钮
 */
@property (nonatomic, strong) UIButton *startEndMark;
/**
 *缓冲进度条
 */
//@property (nonatomic, strong) UIProgressView *videoProgressView;

/**
 *时间条
 */
@property (nonatomic, retain) UISlider *slider;

//用这个来控制音量
@property (nonatomic, retain) UISlider * volumeSlider;

/**
 seek到指定时间进行播放
 
 @param value 秒为单位
 */
-(BOOL)seekToTheTimeValue:(float)value;

- (BOOL)volumeSet:(float)value;
/**
 暂时性的销毁播放器, 用于节省内存, 再用时可以回到销毁点继续播放
 */

-(void)destoryAVPlayer;

/**
 开始播放
 */
-(void)mediaPlay;
/**
 停止播放
 */
-(void)mediaStop;

/**
 destory 后再次播放, 会记住之前的播放状态, 时间和是否暂停
 */
-(void)replay;

@end
