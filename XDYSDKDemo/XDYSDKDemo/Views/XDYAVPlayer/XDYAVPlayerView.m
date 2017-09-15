//
//  AVPlayerView.m
//  RePlay
//
//  Created by lyy on 2017/2/16.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYAVPlayerView.h"

@interface XDYAVPlayerView ()<UIGestureRecognizerDelegate>
{
    BOOL _isFisrtConfig;
    BOOL _statusReadyToPlay;
    //音量控制控件
    MPVolumeView * _volumeView;
    float preVolume;
    
    
}


/**
 *  @b 旋转的菊花
 */
@property (nonatomic, strong) UIActivityIndicatorView *actIndicator;
/**
 * @b 判断滑块是否在拖动
 */
@property (nonatomic, assign) BOOL sliderValueChanging;

/**
 * @b 这个是用来切换全屏时, 将self添加到不同的位置
 */
@property (nonatomic, weak) UIView * avplayerSuperView;

/**
 *  @b avplayer播放器
 */
@property (nonatomic, strong) AVPlayer * viewAVplayer;

/**
 * @b 用来监控播放时间的observer
 */
@property (nonatomic, strong) id timerObserver;




@end

@implementation XDYAVPlayerView

#pragma mark - 实例化方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        
        [self initSubViews];
    }
    return self;
}

#pragma mark - 从xib唤醒视图

-(void)initSubViews{
    _seekTempTime = 0;
    //创建控制声音的MPVolumeView
//    [self createVolumeView];
    
    //从xib唤醒的时候初始化一下值
    [self initialSelfView];
}

#pragma mark - 初始化播放控制信息
-(void)initialSelfView{
    self.userInteractionEnabled = NO;
    _isFisrtConfig = YES;
    _isPlaying = NO;
    _statusReadyToPlay = NO;
    
    _startEndMark = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startEndMark.frame = CGRectMake(0, self.frame.size.height-40, 40, 40);
    [_startEndMark setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
    
    [self addSubview:_startEndMark];
    
    _startEndMark.hidden = YES;
    
//    _videoProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(40, self.frame.size.height-40, self.frame.size.width-50, 40)];
//    _videoProgressView.progressTintColor = kUIColorFromRGB(0x555555);
//    [self addSubview:_videoProgressView];
//    _videoProgressView.userInteractionEnabled = YES;
   
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(40, self.frame.size.height-40, self.frame.size.width-50, 40)];
    [self addSubview:_slider];
    _slider.enabled = NO;
    [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];

    _slider.hidden = YES;
//    [_viewAVplayer setAutomaticallyWaitsToMinimizeStalling:NO];
    
}

-(void)mediaPlay{
    [self.actIndicator startAnimating];
    self.actIndicator.hidden = NO;
    
    [self.viewAVplayer play];
    _isPlaying = YES;
    [_startEndMark setImage:[UIImage imageNamed:@"stop"] forState:(UIControlStateNormal)];
}

-(void)mediaStop{
    [self.viewAVplayer pause];
    _isPlaying = NO;
    [_startEndMark setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
}

#pragma mark -----------------------------
#pragma mark - 视频播放相关
#pragma mark -----------------------------
#pragma mark - KVO - 监测视频状态, 视频播放的核心部分
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {        //获取到视频信息的状态, 成功就可以进行播放, 失败代表加载失败
        if (self.avplayerItem.status == AVPlayerItemStatusReadyToPlay) {   //准备好播放
            _statusReadyToPlay = YES;
            Log(@"AVPlayerItemStatusReadyToPlay: 视频成功播放");
            if (_isFisrtConfig) {
                //self准备好播放
                [self readyToPlay];
                //avplayerView准备好播放
                [self readyToPlayConfigPlayView];
                if (self.isPlaying) {
                    [self.viewAVplayer play];
                    
                }else{
                    [self.viewAVplayer pause];
                }
                if (_seekTempTime) {
                    [self seekToTheTimeValue:_seekTempTime];
          
                }
            }
        }else if(self.avplayerItem.status == AVPlayerItemStatusFailed){    //加载失败
            Log(@"AVPlayerItemStatusFailed: 视频播放失败");
        }else if(self.avplayerItem.status == AVPlayerItemStatusUnknown){   //未知错误
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){ //当缓冲进度有变化的时候
        
        [self updateAvailableDuration];
        Log(@"当缓冲进度有变化的时候");
        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){ //当视频播放因为各种状态播放停止的时候, 这个属性会发生变化
        if (self.isPlaying) {
            [self.viewAVplayer play];
            [self.actIndicator stopAnimating];
            self.actIndicator.hidden = YES;
        }
        
        Log(@"playbackLikelyToKeepUp change : %@", change);
    }else if([keyPath isEqualToString:@"playbackBufferEmpty"]){  //当没有任何缓冲部分可以播放的时候
        [self.actIndicator stopAnimating];
        self.actIndicator.hidden = YES;
        Log(@"playbackBufferEmpty");
    }else if ([keyPath isEqualToString:@"playbackBufferFull"]){
        Log(@"playbackBufferFull: change : %@", change);
    }else if([keyPath isEqualToString:@"presentationSize"]){      //获取到视频的大小的时候调用
        Log(@"获取到视频的大小的时候调用");
        
    }
}
#pragma mark - 更新缓冲时间
-(void)updateAvailableDuration{
    NSArray * loadedTimeRanges = self.avplayerItem.loadedTimeRanges;
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
 
    
//    self.videoProgressView.progress = result/self.totalSeconds;
}

#pragma mark - 当缓冲好视频调用的方法
-(void)readyToPlayConfigPlayView{
   
    self.userInteractionEnabled = YES;
    self.actIndicator.hidden = YES;
    [self.actIndicator stopAnimating];
}
#pragma mark - 创建控制声音的控制器, 通过self.volumeSlider来控制声音
-(void)createVolumeView{
    _volumeView = [[MPVolumeView alloc] init];
    _volumeView.showsRouteButton = NO;
    _volumeView.showsVolumeSlider = NO;
    for (UIView * view in _volumeView.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
            _volumeSlider = (UISlider *)view;
            break;
        }
    }
    [self addSubview:_volumeView];
}
#pragma mark - 缓冲好准备播放所做的操作, 并且添加时间观察, 更新播放时间
-(void)readyToPlay{
    _isFisrtConfig = NO;
    _totalSeconds = self.avplayerItem.duration.value/self.avplayerItem.duration.timescale;
    _totalSeconds = (float)self.totalSeconds;
   
    //这个是用来监测视频播放的进度做出相应的操作
    __weak XDYAVPlayerView * weakSelf = self;
    self.timerObserver = [self.viewAVplayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        [weakSelf.actIndicator stopAnimating];
        weakSelf.actIndicator.hidden = YES;
        long long currentSecond = weakSelf.avplayerItem.currentTime.value/weakSelf.avplayerItem.currentTime.timescale;
        
        if (!weakSelf.sliderValueChanging) {
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(currentPlayTime:totalTime:)]) {
                [weakSelf.delegate currentPlayTime:(float)currentSecond totalTime:weakSelf.totalSeconds];
            }
            
//
            weakSelf.slider.maximumValue = 0;
            weakSelf.slider.maximumValue = weakSelf.totalSeconds;
            [weakSelf.slider setValue:(float)currentSecond animated:YES];
            

        }
        
        float tempTime = (float)currentSecond ;
        
        if (tempTime>=weakSelf.totalSeconds) {
             [weakSelf.startEndMark setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
            
//            [weakSelf seekToTheTimeValue:0];
//            
//            [weakSelf mediaStop];
//            
        }
    }];
}
//跳转到指定位置
-(BOOL)seekToTheTimeValue:(float)value{
        //加载菊花显示
        self.actIndicator.hidden = NO;
        [self.actIndicator startAnimating];
        [self.viewAVplayer pause];
    
        CMTime changedTime = CMTimeMakeWithSeconds(value, 1);
    
        __weak XDYAVPlayerView * weakSelf = self;
        if (_statusReadyToPlay) {//视频准备好之后才能进行seek
            [self.viewAVplayer seekToTime:changedTime completionHandler:^(BOOL finished){
                if (weakSelf.isPlaying) {
                    [weakSelf.viewAVplayer play];
                }
                weakSelf.sliderValueChanging = NO;
                //加载菊花隐藏
                [weakSelf.actIndicator stopAnimating];
                weakSelf.actIndicator.hidden = YES;
                
            }];
            return YES;
        }else{
            return NO;
        }
}

- (BOOL)volumeSet:(float)volume
{
    BOOL ret = NO;
    if (preVolume !=volume) {
        
        NSArray* arrayTracks = [_avplayerItem.asset tracksWithMediaType:AVMediaTypeAudio];
        
        if (0 < [arrayTracks count]) {
            
            AVAssetTrack* assetTrackAudio = [arrayTracks objectAtIndex:0];
            
            if (nil != assetTrackAudio) {
                
                AVMutableAudioMixInputParameters* audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
                [audioInputParams setVolume:volume atTime:(kCMTimeZero)];
                [audioInputParams setTrackID:[assetTrackAudio trackID]];
                NSArray* audioParams = [NSArray arrayWithObject:audioInputParams];
                AVMutableAudioMix* audioMix = [AVMutableAudioMix audioMix];
                [audioMix setInputParameters:audioParams];
                [[_viewAVplayer currentItem] setAudioMix:audioMix];
                ret = YES;
                
            }
        }
        preVolume = volume;

    }
    
    return YES;
    
}

//播放结束调用的方法
-(void)moviePlayEnd:(NSNotification *)notification{
    [self seekToTheTimeValue:0.0];
    [self.viewAVplayer pause];
    _isPlaying = NO;
}

#pragma mark ---------------
#pragma mark - 以下是销毁以及销毁后再播放的相关方法
#pragma mark ---------------

-(void)destoryAVPlayer{

    self.userInteractionEnabled = NO;
    
    if (_avplayerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_avplayerItem];
        /*
         status
         loadedTimeRanges
         playbackLikelyToKeepUp
         playbackBufferEmpty
         playbackBufferFull
         presentationSize
         */
        [_avplayerItem removeObserver:self forKeyPath:@"status"];
        [_avplayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_avplayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [_avplayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_avplayerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
        [_avplayerItem removeObserver:self forKeyPath:@"presentationSize"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timerObserver) {
        [_viewAVplayer removeTimeObserver:self.timerObserver];
        _timerObserver = nil;
    }
    [(AVPlayerLayer *)self.layer setPlayer:nil];
    _avplayerItem = nil;
    _viewAVplayer = nil;
    _statusReadyToPlay = NO;
}
-(void)replay{
    [self initialSelfView];
    [self.viewAVplayer play];
}
-(void)dealloc{
    [self destoryAVPlayer];
}

#pragma mark - 懒加载
-(AVPlayerItem *)avplayerItem{
    if (!_avplayerItem) {
        NSString * urlString  =[self.videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _avplayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        [_avplayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_avplayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_avplayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_avplayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_avplayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_avplayerItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avplayerItem];
    }
    return _avplayerItem;
}

-(AVPlayer *)viewAVplayer{
    
    if (!_viewAVplayer) {
        _viewAVplayer = [AVPlayer playerWithPlayerItem:self.avplayerItem];
        _viewAVplayer.usesExternalPlaybackWhileExternalScreenIsActive = YES;
        [(AVPlayerLayer *)self.layer setPlayer:_viewAVplayer];
    }
    return _viewAVplayer;
    
}

-(UIActivityIndicatorView *)actIndicator{
    
    if (!_actIndicator) {
        _actIndicator = [[UIActivityIndicatorView alloc]init];
        [self addSubview:_actIndicator];
        self.actIndicator.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    }
    return _actIndicator;
    
}

#pragma mark - 用来将layer转为AVPlayerLayer, 必须实现的方法, 否则会崩
+(Class)layerClass{
    return [AVPlayerLayer class];
}

#pragma mark - 禁止使用其他实例化方法
-(instancetype)init{
    NSAssert(NO, @"请不要使用此实例化方法");
    return nil;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    NSAssert(NO, @"请不要使用此实例化方法");
//    return nil;
//}

@end
