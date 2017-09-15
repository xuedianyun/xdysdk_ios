//
//  VideoModel.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//  视频model  主要用于记录开启的视频窗口

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XDYAVPlayerView.h"
#import "XDYVideoBackView.h"

@interface VideoModel : NSObject

@property (nonatomic, strong) XDYAVPlayerView *avplayView;

@property (nonatomic, strong) UIButton  *audioBtn;

@property (nonatomic, strong) XDYVideoBackView *videoBackView;


@property (nonatomic, strong) UIImageView *audioImg;



@property (nonatomic, assign) int    mediaId;//视频唯一id由js底层返回

@property (nonatomic, assign) int    videoId;//视图唯一标识，由自己提供

@property (nonatomic, strong) UIView *playView;//存储的视频显示视图
@property (nonatomic, assign) int    uid;//视频唯一id也是用户nodeid
@end
