//
//  ClassForPadViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "RePlayForPadViewController.h"
#import "XDYSDK.h"
#import "VideoModel.h"

//聊天输入工具条
#import "XDYToolBar.h"
//聊天内容显示
#import "MessageFrame.h"
#import "MessageCell.h"
#import "MessageInfo.h"
#import "XDYDrawView.h"
#import "XDYRePlayToolView.h"

@interface RePlayForPadViewController ()
<UITableViewDelegate,UITableViewDataSource,HMComposeToolbarDelegate,UITextViewDelegate,XDYRePlayToolDelegate,XDYAVPlayerViewDelegate,UIGestureRecognizerDelegate,XDYAVPlayerViewDelegate>
{
    NSInteger curImage;
    UIImage* images[3];
    NSMutableArray  *_allMessagesFrame;
}

@property (nonatomic, assign) int maxMediaChannels;


@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) float                          height;//界面高度

@property (nonatomic, assign) float                          width;//界面宽度

@property (nonatomic, strong) UIButton                       *backButton;//返回上一个界面

@property (nonatomic, strong) UIImageView                    *leftView;//左视图

@property (nonatomic, strong) UIView                         *rightView;//右视图

@property (nonatomic, strong) UILabel                        *docToolLable;//文档工具栏

@property (nonatomic, strong) NSMutableArray                 *videoArray;//存储播放视图及相关信息

@property (nonatomic, strong) UIView                         *videoView;//播放视图


@property (nonatomic, strong) XDYVideoBackView               *stuVideoView1;

@property (nonatomic, strong) XDYVideoBackView               *stuVideoView2;

@property (nonatomic, strong) XDYVideoBackView               *stuVideoView3;

@property (nonatomic, strong) XDYVideoBackView               *stuVideoView4;

@property (nonatomic, strong) UIView                         *publishView;

@property (nonatomic, assign) int                            nodeId;//用户唯一标识

@property (nonatomic, strong) NSString                       *className;//课堂名称

@property (nonatomic, assign) BOOL                           password;//是否存在密码

@property (nonatomic, assign) int                            mediaId;//视频唯一标识

@property (nonatomic, strong) DocForPadView                  *docView;//文档视图


//动态ppt
@property (nonatomic, strong) NSString                       *DOCServerIP;
@property (nonatomic, strong) XDYHtmlDocView                 *htmlDocView;
@property (nonatomic, strong) NSString                       *htmlDocUrl;
@property (nonatomic, assign) int                            animationStep;
@property (nonatomic, assign) BOOL                           isFirstStep;
@property (nonatomic, assign) int                            curPageNo;
@property (nonatomic, strong) NSString                       *docVisible;

@property (nonatomic, assign) int                            itemIdx;//文档唯一标识

@property (nonatomic, strong) UIView                         *chatView;//聊天底层图

@property (nonatomic, assign) CGFloat                        keyboardHeight;//键盘高度

@property (nonatomic, strong) UITableView                    *chatTableView;//聊天视图

@property (nonatomic, strong) UILabel                        *chatTitleLable;//

@property (nonatomic, strong) NSString                       *previousTime;

@property (nonatomic, strong) XDYRePlayToolView              *rePlayTool;//拖动条

@property (nonatomic, assign) BOOL                           audioFlag;


@property (nonatomic, assign) CGFloat leftHeight;
@property (nonatomic, assign) CGFloat leftWidth;

@property (nonatomic, strong) XDYAVPlayerView *screenShareView;//屏幕共享
@property (nonatomic, strong) XDYAVPlayerView *mediaShareView;//媒体共享
@property (nonatomic, strong) XDYAVPlayerView *musicShareView;
@property (nonatomic, strong) NSMutableArray  *mediaShareArray;

@end

@implementation RePlayForPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self afn];
    if (XDY_WIDTH > XDY_HEIGHT) {
        _height = XDY_HEIGHT;
        _width = XDY_WIDTH;
    }else{
        
        _height = XDY_WIDTH;
        _width = XDY_HEIGHT;
    }
    
    self.view.backgroundColor = kUIColorFromRGB(0xebebeb);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(10, 15, XDY_HEIGHT, 54);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [backButton setTitleColor:kUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
    [backButton setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/backPad.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backIpadBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    self.backButton = backButton;
    
    [self loadAllView];

    
    //创建xdy客户端
    XDYClient *xdyClient = [XDYClient sharedClient];
    //初始化学点云
    [xdyClient initXDY];
    
    //    [[XDYClient sharedClient] catchJsLog];
    
    //接收所有课堂消息
    [[XDYClient sharedClient] getMessageXDYBlock:^(id type, id message) {
        
        NSArray *typeArray = [NSArray arrayWithObjects:
                              @"init",
                              @"class_init_success",
                              @"class_join_success",
                              @"video_play",
                              @"video_stop",
                              @"audio_play",
                              @"audio_stop",
                              @"video_broadcast",
                              @"audio_broadcast",
                              @"chat_receive_message",
                              @"class_update_roster_num",
                              @"document_update",
                              @"document_delete",
                              @"whiteboard_annotation_update",
                              @"class_update_timer",
                              @"record_playback_update",
                              @"screen_share_play",
                              @"screen_share_stop",
                              @"media_shared_update",
                              @"media_shared_delete",
                              @"music_shared_update",//伴音
                              @"music_shared_delete",
                              @"error_event",
                              nil];
        
        int index = (int)[typeArray indexOfObject:type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (index) {
                case 0:
                {
                    NSString *success = message[@"success"];
                    if ([success isEqualToString:@"1"]) {
                        [self initXDYRePlayClass];
                    }
                }
                    break;
                case 1://class_init_success
                    _password = [message[@"passwordRequired"] boolValue];
                    [self userVerify:_password];
                    
                    break;
                case 2://class_join_success
                    
                    _maxMediaChannels =  [message[@"maxMediaChannels"] intValue];
                    _DOCServerIP = message[@"DOCServerIP"];
                    
                    [XDYLoadingHUD hiddenLoadingAnimation];
                    
                    [_backButton setTitle:[NSString stringWithFormat:@"      %@",message[@"className"]] forState:(UIControlStateNormal)];
                    
                    _nodeId = [message[@"nodeId"] intValue];
                    self.rePlayTool.endTime.text = [self formatDuration:[message[@"recordPlaybackMaxTime"]floatValue]] ;
                    self.rePlayTool.slider.minimumValue = 0;
                    self.rePlayTool.slider.maximumValue = [message[@"recordPlaybackMaxTime"] floatValue];
                    
                    [self resetFrame];
                    
                    break;
                case 3://video_play
                    
                    [self PlayView:message isAudio:false];
                    break;
                case 4://video_stop
                    
                    _mediaId = [message[@"mediaId"] intValue];
                    [self stopPlay:_mediaId];
                    
                    break;
                case 5://audio_play
                    _audioFlag = true;
                    [self PlayView:message isAudio:true];
                    
                    break;
                case 6://audio_stop
                    _audioFlag = false;
                    _mediaId = [message[@"mediaId"] intValue];
                    [self stopPlay:_mediaId];
                    break;
                case 7://video_broadcast
                {
                    if([message[@"toNodeId"] intValue] == _nodeId){
                        if ([message[@"actionType"] intValue] == 1) {
                            [self publishView:[message[@"toNodeId"] intValue]];
                        }else if([message[@"actionType"] intValue] == 2){
                            [self unpublishView:[message[@"toNodeId"] intValue]];
                        }
                    }
                }
                    break;
                case 8://audio_broadcast
                    if([message[@"toNodeId"] intValue] == _nodeId){
                        if ([message[@"actionType"] intValue] == 1) {
                            [self publishView:[message[@"toNodeId"] intValue]];
                        }else if([message[@"actionType"] intValue] == 2){
                            [self unpublishView:[message[@"toNodeId"] intValue]];
                        }
                    }
                    break;
                case 9://chat_receive_message
                {
                    NSString *dateString = [XDYCurrentTime getChatTime];
                    if ([message[@"fromNodeId"] intValue] == _nodeId) {//自己发送消息
                        [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:message[@"fromName"] msgType:[message[@"msgType"] intValue]];
                    }else{
                        if ([message[@"fromRole"] isEqualToString:@"host"]) {
                            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeTeacher icon:@"XueDianYunSDK.bundle/ClassRoomTeacherIcon" name:message[@"fromName"] msgType:[message[@"msgType"] intValue]];
                        }else{
                            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeOther icon:@"ClassRoomStudentIcon" name:message[@"fromName"] msgType:[message[@"msgType"] intValue]];
                        }
                    }
                }
                    break;
                case 10://class_update_roster_num
                    
                    break;
                case 11://document_update
                {
                    
                    [_docView.drawView clearScreen];
                    if ([message[@"visible"] intValue] == 1){
                        _docToolLable.text = [NSString stringWithFormat:@"%d /%d页    ",[message[@"curPageNo"] intValue],[message[@"pageNum"] intValue]];
                        
                        if ([message[@"fileType"] isEqualToString:@"zip"]) {
                            
                            self.htmlDocView.hidden = NO;
                            NSString *docImageUrl = message[@"html"];
                            
                            if (![docImageUrl isEqualToString:_htmlDocUrl]) {
                              
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                                   
                                    [self.htmlDocView setSrc:docImageUrl];
                                    _htmlDocUrl = docImageUrl;
                                    
                                });
                            }
                            int curpage = [message[@"curPageNo"] intValue];
                            if (curpage != _curPageNo) {
                                [self.htmlDocView jumpPage:curpage];
                                _animationStep = 1;
                                _curPageNo = curpage;
                            }
                            
                            int animationStep = [message[@"animationStep"] intValue];
                            if (_isFirstStep) {
                                
                                _isFirstStep = false;
                                for (int i = 1; i<animationStep; i++) {
                                    [self.htmlDocView nextStep];
                                }
                                _animationStep = animationStep;
                            }else{
                                if (_animationStep > animationStep) {
                                    [self.htmlDocView preStep];
                                    
                                }else if (_animationStep <animationStep){
                                    [self.htmlDocView nextStep];
                                    
                                }
                                _animationStep = animationStep;
                            }
                            
                        }else{
                            self.htmlDocView.hidden = YES;
                            NSArray *docImgArr = message[@"images"];
                            if(docImgArr.count == 0){
                                return;
                            }
                            int curpage = [message[@"curPageNo"] intValue]-1;
                            NSString *docImageUrl = docImgArr[curpage];
                            _itemIdx = [message[@"itemIdx"] intValue];
                            [_docView setDocFile:docImageUrl];
                        }
                    }
                }

                    break;
                case 12://document_delete
                    if ([message[@"itemIdx"] intValue] == _itemIdx) {
                        _docToolLable.text = @"";
                        
                        [_docView setDocFile:nil];
                        
                    }
                    break;
                case 13://whiteboard_annotation_update
                {
                    if ([message[@"isFresh"] boolValue]) {
                        //清空画面
                        if (self.htmlDocView.hidden == NO) {
                            [_htmlDocView.drawView clearScreen];
                            
                        }else{
                            [_docView.drawView clearScreen];
                        }
                    }
                    NSArray *anno = message[@"annotaionItems"];
                    for (int i = 0; i<anno.count; i++) {
                        
                        NSString *color = anno[i][@"color"];
                        CGFloat lineWidth = [anno[i][@"thickness"] floatValue];
                        NSArray *pointGroup = anno[i][@"pointGroup"];
                        
                        NSMutableArray *pointArray = [NSMutableArray array];
                        for (int j = 0; j<pointGroup.count; j++) {
                            
                            NSDictionary *dic = pointGroup[j];
                            float x = [dic[@"w"] floatValue]/100.0 * CGRectGetWidth(_docView.frame);
                            float y = [dic[@"h"] floatValue]/100.0 * CGRectGetWidth(_docView.frame);
                            
                            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                            
                        }
                        if (self.htmlDocView.hidden == NO) {
                            [_htmlDocView.drawView drawPath:pointArray drawColor:XDYHexColor(color) lineWidth:lineWidth];
                        }else{
                            [_docView.drawView drawPath:pointArray drawColor:XDYHexColor(color) lineWidth:lineWidth];
                        }
                    }
                }
                    break;
                case 14://class_update_timer
                    self.rePlayTool.slider.value = [message[@"classTimestamp"] floatValue];
                    self.rePlayTool.startTime.text = [self formatDuration:[message[@"classTimestamp"] floatValue]];
                    break;
                case 15://record_playback_update
                    if ([message[@"status"] intValue]==4) {
                        
                        
                        NSNumber *time = [NSNumber numberWithInt:1];
                        NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",nil];
                        [[XDYClient sharedClient] api:@"seekRecordPlayback" message:dictionary];
                        [[XDYClient sharedClient] api:@"pauseRecordPlayback" message:nil];
                        
                        _rePlayTool.rePlay = false;
                        _rePlayTool.rePlaying = NO;
                        //还原所有设置
                        [self.docView setDocFile:@""];
                        [self.htmlDocView setSrc:@""];
                        self.htmlDocView.hidden = YES;
                        _docToolLable.text = @"";
                        [_docView.drawView clearScreen];
                        
                        if (self.mediaShareView != nil) {
                            [self.mediaShareView mediaStop];
                            [self.mediaShareView destoryAVPlayer];
                            [self.mediaShareView removeFromSuperview];
                            self.mediaShareView = nil;
                        }
                        
                        if (self.screenShareView != nil) {
                            [self.screenShareView mediaStop];
                            [self.screenShareView destoryAVPlayer];
                            [self.screenShareView removeFromSuperview];
                            self.mediaShareView = nil;
                        }
                        
                        
                        NSArray *array = [NSArray arrayWithArray:_videoArray];
                        
                        for (VideoModel *video in array) {
                            if (video.avplayView != nil) {
                                [video.avplayView mediaStop];
                                [video.avplayView destoryAVPlayer];
                                [video.avplayView removeFromSuperview];
                                video.avplayView = nil;
                            }
                            if (video.audioBtn != nil) {
                                [video.audioBtn removeFromSuperview];
                                video.audioBtn = nil;
                                video.audioBtn = false;
                            }
                            [_videoArray removeObject:video];
                        }
                        
                        [_allMessagesFrame removeAllObjects];
                        [self.chatTableView reloadData];
                        _rePlayTool.slider.value = 0;
                        _rePlayTool.startTime.text = @"00:00";
                        
                        
                    }
                    
                    break;
                case 16://screen_share_play
                {
                     [self ScreenSharePlay:message];
                }
                    break;
                case 17://screen_share_stop
                {
                     [self ScreenShareStop:message];
                }
                    break;
                case 18://media_shared_update
                {
                    [self loadMediaShareView:message];
                }
                    break;
                case 19://media_shared_delete
                {
                    [self mediaShareDelete:message];
                }
                    break;
                case 20://music_shared_update
                {
                    [self loadMusicShare:message];
                }
                    break;
                case 21://music_shared_delete
                {
                    [self musicShareDelete:message];
                    
                }
                    break;
                case 22://error_event
                    if ([message[@"code"] intValue] == 911 || [message[@"code"] intValue] == 910) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(message[@"reson"],@"") preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    break;
                default:
                    
                    break;
            }
        });
        
    }];
    //耳机插播监听
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
}

//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            Log(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
           
            Log(@"耳机拔出，停止播放操作");
            
        {
            for (VideoModel *video in _videoArray) {
                if (video.avplayView.isPlaying) {
                    [video.avplayView mediaPlay];
                }
            }
            
            if (_screenShareView.isPlaying) {
                [_screenShareView mediaPlay];
            }
            if (_mediaShareView.isPlaying) {
                [_mediaShareView mediaPlay];
            }
            
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            Log(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}


- (void)loadAllView{
    
    _audioFlag = false;
    _videoArray = [NSMutableArray arrayWithCapacity:0];
    _allMessagesFrame = [NSMutableArray array];
    _mediaShareArray = [NSMutableArray array];
    _itemIdx = -1;
    
    if (isPad) {
        _leftHeight =  _height-64;
    }
    
    self.leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, _width/4*3, _leftHeight-10)];
    _leftWidth = _width/4*3;
    
    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftView.userInteractionEnabled = YES;
    [self.view addSubview:self.leftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(_width/4*3, 64, _width/4, _leftHeight-10)];
    self.rightView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.rightView];
    
    
    UIButton *videoView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    videoView.frame = CGRectMake(2.5, 10, CGRectGetWidth(_rightView.frame)-2.5,( (CGRectGetWidth(_rightView.frame)-10)/4.0*3));
    
    videoView.backgroundColor = kUIColorFromRGB(0xf5f9fc);
    [videoView setImage:[self setImageOriginal:@"videoIconTeacher.png"] forState:(UIControlStateNormal)];
    
    videoView.userInteractionEnabled = NO;
    
    [self.rightView addSubview:videoView];
    self.videoView = videoView;
//    if (_classType == 1) {
    
    
    _stuVideoView1 = [[XDYVideoBackView alloc]init];
    _stuVideoView2 = [[XDYVideoBackView alloc]init];
    _stuVideoView3 = [[XDYVideoBackView alloc]init];
    _stuVideoView4 = [[XDYVideoBackView alloc]init];

    
    
    _docView = [[DocForPadView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
    
    _docView.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:_docView];
    _docView.userInteractionEnabled = YES;
    
    UILabel *docToolLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_docView.frame), CGRectGetMaxY(_docView.frame), CGRectGetWidth(_docView.frame), 49)];
    docToolLable.backgroundColor = kUIColorFromRGB(0xe3e4e6);
    docToolLable.textAlignment = NSTextAlignmentRight;
    docToolLable.textColor = kUIColorFromRGB(0x333333);
    
    [self.leftView addSubview:docToolLable];
    self.docToolLable = docToolLable;
    
    
    //聊天视图
    [self loadTableView];
    
    //录制拖动条
    [self setupRePlayTool];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [self.view addGestureRecognizer:singleRecognizer];
}
- (void)resetFrame{
    
    _htmlDocView = [[XDYHtmlDocView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
    
    [_htmlDocView loadDOCServerIP:_DOCServerIP];
    [self.leftView addSubview:_htmlDocView];
    
    _htmlDocView.hidden = YES;
    
    [self.htmlDocView getMessageXDYDocBlock:^(id type, id message) {
        
        if ([type isEqualToString:@"success"]) {
            _docVisible = message;
        }else if([type isEqualToString:@"loadDocSuccess"]&&[message isEqualToString:@"1"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self.htmlDocView jumpPage:_curPageNo];
            });
        }
    }];
    
    
    float stuSpace = 2.5;
    if (_maxMediaChannels == 2) {
        _stuVideoView1.frame =  CGRectMake(stuSpace, CGRectGetMaxY(_videoView.frame)+5, CGRectGetWidth(_rightView.frame)-stuSpace,( (CGRectGetWidth(_rightView.frame)-10)/4.0*3));
         [_stuVideoView1 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/videoIconStudent.png"]];
        _stuVideoView1.isPlay = @"-1";
        [self.rightView addSubview:_stuVideoView1];
        
        self.chatTableView.frame = CGRectMake(stuSpace, CGRectGetMaxY(_stuVideoView1.frame)+5, CGRectGetWidth(_rightView.frame)-stuSpace, CGRectGetHeight(self.rightView.frame)-CGRectGetMaxY(_stuVideoView1.frame)) ;
    }else if(_maxMediaChannels == 3){
        
        _stuVideoView1.frame =  CGRectMake(stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace, (CGRectGetWidth(_videoView.frame)-stuSpace)/2,(CGRectGetWidth(_videoView.frame)-stuSpace)/2/4.0*3);
        [_stuVideoView1 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView1];
        _stuVideoView1.isPlay = @"-1";
        _stuVideoView2.frame = CGRectMake(CGRectGetMaxX(_stuVideoView1.frame)+stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace,CGRectGetWidth(_stuVideoView1.frame),CGRectGetHeight(_stuVideoView1.frame));
        [_stuVideoView2 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView2];
        _stuVideoView2.isPlay = @"-1";
        self.chatTableView.frame = CGRectMake(stuSpace, CGRectGetMaxY(_stuVideoView1.frame)+5, CGRectGetWidth(_rightView.frame)-stuSpace, CGRectGetHeight(self.rightView.frame)-CGRectGetMaxY(_stuVideoView1.frame)) ;
        
    }else if(_maxMediaChannels == 5){
        
        _stuVideoView1.frame =  CGRectMake(stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace, (CGRectGetWidth(_videoView.frame)-stuSpace)/2,(CGRectGetWidth(_videoView.frame)-stuSpace)/2/4.0*3);
        [_stuVideoView1 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView1];
        _stuVideoView1.isPlay = @"-1";
        _stuVideoView2.frame = CGRectMake(CGRectGetMaxX(_stuVideoView1.frame)+stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace,CGRectGetWidth(_stuVideoView1.frame),CGRectGetHeight(_stuVideoView1.frame));
        [_stuVideoView2 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView2];
        _stuVideoView2.isPlay = @"-1";
        _stuVideoView3.frame = CGRectMake(CGRectGetMinX(_stuVideoView1.frame), CGRectGetMaxY(_stuVideoView1.frame)+stuSpace, CGRectGetWidth(_stuVideoView1.frame),CGRectGetHeight(_stuVideoView1.frame));
        [_stuVideoView3 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView3];
        _stuVideoView3.isPlay = @"-1";
        _stuVideoView4.frame = CGRectMake(CGRectGetMaxX(_stuVideoView1.frame)+stuSpace, CGRectGetMaxY(_stuVideoView1.frame)+stuSpace, CGRectGetWidth(_stuVideoView1.frame),CGRectGetHeight(_stuVideoView1.frame));
        [_stuVideoView4 setVideoIcon:[self setImageOriginal:@"XueDianYunSDK.bundle/IconStudent"]];
        [self.rightView addSubview:_stuVideoView4];
        _stuVideoView4.isPlay = @"-1";
        self.chatTableView.frame = CGRectMake(stuSpace, CGRectGetMaxY(_stuVideoView3.frame)+5, CGRectGetWidth(_rightView.frame)-stuSpace, CGRectGetHeight(self.rightView.frame)-CGRectGetMaxY(_stuVideoView3.frame)) ;
    }
    
    
    _rePlayTool.rePlay = true;
    _rePlayTool.rePlaying = YES;
    
    [[XDYClient sharedClient] api:@"startRecordPlayback" message:nil];
    for (VideoModel *video in _videoArray) {
        if (video.avplayView != nil) {
            [video.avplayView mediaPlay];
        }
    }
    if (_screenShareView != nil) {
        [_screenShareView mediaPlay];
    }
    if (_mediaShareView != nil) {
        [_mediaShareView mediaPlay];
    }
   
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    
    [_rePlayTool showRePlayTool];
    
}
#pragma mark - 录制回放工具条
- (void)setupRePlayTool{
    
    //    UIView *layer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
    //    layer.backgroundColor = [UIColor clearColor];
    //    [_bottomView addSubview:layer];
    //    [_bottomView bringSubviewToFront:layer];
    
    _rePlayTool = [[XDYRePlayToolView alloc]initWithFrame:CGRectMake(0, _height-40, _width, 40)];
    _rePlayTool.delegate = self;
    [self.view addSubview:_rePlayTool];
    [self.view bringSubviewToFront:_rePlayTool];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];
}

#pragma mark - 初始化课堂
- (void)initXDYRePlayClass{
    
    // 初始化课堂
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",self.userRole,@"userRole",self.portal,@"portal",self.userId,@"userId",nil];
    
    
    [[XDYClient sharedClient] api:@"initRecordPlayback" message:dictionary];
    
}

#pragma mark - 加入课堂
- (void)userVerify:(BOOL)flag{
    [XDYLoadingHUD hiddenLoadingAnimation];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"加入课堂",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if (flag) {
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder =NSLocalizedString(@"请输入用户名",@"");
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"请输入密码",@"");
            textField.secureTextEntry = YES;
        }];
        
    }else{
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"请输入用户名",@"");
        }];
    }
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"登录",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *username = alertController.textFields.firstObject;
        UITextField *password = alertController.textFields.lastObject;
        
        
        if ([username.text isEqualToString:@""]) {
            [self userVerify:_password];
        }else{
            //获取txt内容即可
            NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:username.text,@"userName",password.text,@"password",nil];
            
            
            [[XDYClient sharedClient] api:@"joinClass" message:dictionary];
            [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSArray *array = [NSArray arrayWithArray:_videoArray];
            for (VideoModel *video in array) {
                if (video.avplayView != nil) {
                    [video.avplayView mediaStop];
                    [video.avplayView destoryAVPlayer];
                    [video.avplayView removeFromSuperview];
                    video.avplayView = nil;
                }
                if (video.audioBtn != nil) {
                    [video.audioBtn removeFromSuperview];
                    video.audioBtn = nil;
                    video.audioBtn = false;
                }
                [_videoArray removeObject:video];
            }
            if (_mediaShareView != nil) {
                [_mediaShareView mediaStop];
                [_mediaShareView destoryAVPlayer];
                [_mediaShareView removeFromSuperview];
                _mediaShareView = nil;
            }
            if (_screenShareView != nil) {
                [_screenShareView mediaStop];
                [_screenShareView destoryAVPlayer];
                [_screenShareView removeFromSuperview];
                _screenShareView = nil;
            }
            
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)ScreenSharePlay:(NSDictionary *)dic{
    
    NSString *replay = dic[@"replay"];
    int seek = [dic[@"seek"] intValue];
    if (![self.screenShareView.videoUrlStr isEqualToString: replay]) {
        self.screenShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
        [_leftView addSubview:_screenShareView];
        self.screenShareView.videoUrlStr = replay;
        
        
        if (seek == 0) {
            seek = 1;
        }
        self.screenShareView.seekTempTime = seek;
    }
    
    [self.screenShareView mediaPlay];
    if (seek == 0) {
        seek = 1;
    }
    [self.screenShareView seekToTheTimeValue:seek];
    
}

- (void)ScreenShareStop:(NSDictionary *)dic{
    
    [self.screenShareView mediaStop];
    [self.screenShareView destoryAVPlayer];
    [self.screenShareView removeFromSuperview];
    self.screenShareView = nil;
    
}
- (void)loadMediaShareView:(NSDictionary *)dic{
    
    
    
    XDYMediaSharedModel *mediaShareModel = [[XDYMediaSharedModel alloc]initWithDictionary:dic];
    
    switch (mediaShareModel.status) {
        case 0:
        {
            
            if (self.mediaShareView.tag == mediaShareModel.itemIdx) {
                [self.mediaShareView mediaStop];
                self.mediaShareView.hidden = YES;
            }
            
            
        }
            break;
        case 1:
        {
            if (![self.mediaShareView.videoUrlStr isEqualToString: mediaShareModel.url]) {
                [self.mediaShareView removeFromSuperview];
                self.mediaShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
                [_leftView addSubview:_mediaShareView];
                self.mediaShareView.delegate = self;
                self.mediaShareView.tag = mediaShareModel.itemIdx;
                [_mediaShareArray addObject:self.mediaShareView];
                
                self.mediaShareView.videoUrlStr = mediaShareModel.url;
                self.mediaShareView.seekTempTime = mediaShareModel.seek;
            }
            
            self.mediaShareView.hidden = NO;
            
            if (!self.mediaShareView.isPlaying) {
                [self.mediaShareView mediaPlay];
            }
            
            int seek = self.mediaShareView.seekTempTime - mediaShareModel.seek;
            if (seek>=3|| seek<=-3) {
                [self.mediaShareView seekToTheTimeValue:mediaShareModel.seek];
                
            }
            

            
            
        }
            break;
        case 2:
        {
            [self.mediaShareView mediaStop];
        }
            break;
        default:
            break;
    }
}
- (void)currentPlayTime:(float)time totalTime:(float)totalTime{
    
    if (self.mediaShareView != nil) {
        self.mediaShareView.seekTempTime = time;
    }
    if (self.musicShareView != nil) {
        self.musicShareView.seekTempTime = time;
    }
        
}
- (void)mediaShareDelete:(NSDictionary *)dic{
    if (self.mediaShareView.tag == [dic[@"itemIdx"] intValue]) {
        [self.mediaShareView mediaStop];
        [self.mediaShareView destoryAVPlayer];
        [self.mediaShareView removeFromSuperview];
        self.mediaShareView = nil;
    }
}
- (void)loadMusicShare:(NSDictionary *)dic{
    
    
    XDYMediaSharedModel *musicShareModel = [[XDYMediaSharedModel alloc]initWithDictionary:dic];
    
    switch (musicShareModel.status) {
        case 0:
        {
            
            if (self.musicShareView.tag == musicShareModel.itemIdx) {
                [self.musicShareView mediaStop];
                [self.musicShareView removeFromSuperview];
                self.musicShareView = nil;
            }
            
            
        }
            break;
        case 1:
        {
            
            if (![self.musicShareView.videoUrlStr isEqualToString: musicShareModel.url] || self.musicShareView == nil) {
                self.musicShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 10, 200, 50)];
                self.musicShareView.delegate = self;
                _musicShareView.slider.hidden = NO;
                _musicShareView.startEndMark.hidden = NO;
                self.musicShareView.tag = musicShareModel.itemIdx;
                
                self.musicShareView.videoUrlStr = musicShareModel.url;
                self.musicShareView.seekTempTime = musicShareModel.seek;
            }
            
            self.musicShareView.hidden = NO;
            [self.musicShareView mediaPlay];
            
            int seek = self.musicShareView.seekTempTime - musicShareModel.seek;
            if (seek>=3 || seek<=-3) {
                [self.musicShareView seekToTheTimeValue:musicShareModel.seek];
            }
            
            float volume =[dic[@"musicVolume"] floatValue];
            
            [self.musicShareView volumeSet:volume];
            
        }
            break;
            
        case 2:
        {
            [self.musicShareView mediaStop];
            
        }
            break;
        default:
            break;
    }
}
- (void)musicShareDelete:(NSDictionary *)dic{
    if (self.musicShareView.tag == [dic[@"itemIdx"] intValue]) {
        [self.musicShareView removeFromSuperview];
        self.musicShareView = nil;
    }
}

#pragma mark - 开始播流
- (void)PlayView:(NSDictionary *)message isAudio:(BOOL)isAudio{
    
    VideoModel *videoModel = [[VideoModel alloc]init];
    
    int mediaId = [message[@"mediaId"] intValue];
    XDYAVPlayerView *playView;
    
    if ([message[@"userRole"] isEqualToString:@"host"]) {
        playView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_videoView.frame), CGRectGetHeight(_videoView.frame))];
        [_videoView addSubview:playView];
    
    }else{
        
        if (_maxMediaChannels == 2) {
            XDYVideoBackView *videoPlayBack = _stuVideoView1;
            playView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(videoPlayBack.frame), CGRectGetHeight(videoPlayBack.frame))];
            [videoPlayBack addSubview:playView];
            videoModel.videoBackView = videoPlayBack;
        }else{
            
            XDYVideoBackView *videoPlayBack;
            if (![_stuVideoView1.isPlay isEqualToString:@"1"]) {
                videoPlayBack = _stuVideoView1;
                _stuVideoView1.isPlay = @"1";
            }else if(![_stuVideoView2.isPlay isEqualToString:@"2"]) {
                videoPlayBack = _stuVideoView2;
                _stuVideoView2.isPlay = @"2";
            }else if(![_stuVideoView3.isPlay isEqualToString:@"3"]) {
                videoPlayBack = _stuVideoView3;
                _stuVideoView3.isPlay = @"3";
            }else if(![_stuVideoView4.isPlay isEqualToString:@"4"]) {
                videoPlayBack = _stuVideoView4;
                _stuVideoView4.isPlay = @"4";
            }
            playView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(videoPlayBack.frame), CGRectGetHeight(videoPlayBack.frame))];
            [videoPlayBack addSubview:playView];
            videoModel.videoBackView = videoPlayBack;
 
        }
        
    }

    playView.delegate = self;
    playView.backgroundColor = [UIColor blackColor];
    
    playView.tag = mediaId;
    
    
    if (isAudio) {
        
        UIButton *audioImg = [UIButton buttonWithType:(UIButtonTypeCustom)];
        audioImg.backgroundColor = [UIColor redColor];
        
        if (_maxMediaChannels == 2) {
           
            if ([message[@"userRole"] isEqualToString:@"host"]) {
                [audioImg setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/audioIcon"] forState:(UIControlStateNormal)];
                audioImg.frame = CGRectMake(0, 0, CGRectGetWidth(_videoView.frame), CGRectGetHeight(_videoView.frame));
                [_videoView addSubview:audioImg];
            }else{
                [audioImg setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/audioIcon"] forState:(UIControlStateNormal)];
                audioImg.frame = CGRectMake(0, 0, CGRectGetWidth(_videoView.frame), CGRectGetHeight(_videoView.frame));
                [_stuVideoView1 addSubview:audioImg];
            }
            
        }else{
        
        
            audioImg.frame = CGRectMake(0, 0, CGRectGetWidth(playView.frame), CGRectGetHeight(playView.frame));
            if ([message[@"userRole"] isEqualToString:@"host"]) {
                [audioImg setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/audioIcon"] forState:(UIControlStateNormal)];
            }else{
                [audioImg setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/audioIcon"] forState:(UIControlStateNormal)];
                
            }
            [playView addSubview:audioImg];
        }
        
        
        audioImg.backgroundColor = kUIColorFromRGB(0xf5f9fc);
        
        videoModel.audioBtn = audioImg;
        
    }

    
    
    videoModel.mediaId = mediaId;
    videoModel.avplayView = playView;
    
    [_videoArray addObject:videoModel];
    
    NSString *url = message[@"replay"];
    int seek = [message[@"seek"] intValue];
    
    playView.videoUrlStr = url;
    playView.seekTempTime = seek;
    [playView mediaPlay];
}

#pragma mark - 停止播流
- (void)stopPlay:(int)mediaId{
    NSArray *viewArray = [NSArray arrayWithArray:_videoArray];
    
    for (VideoModel *video in viewArray) {
        if (video.mediaId == mediaId) {
            [video.avplayView mediaStop];
            [video.avplayView destoryAVPlayer];
            [video.avplayView removeFromSuperview];
            video.avplayView = nil;
            video.videoBackView.isPlay = @"-1";
            [video.audioBtn removeFromSuperview];
            video.audioBtn = nil;
            [_videoArray removeObject:video];
        }
    }
}

- (void)publishView:(int)mediaId{
    //推流视图
    _publishView  = [[UIView alloc]init];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        _publishView.frame = CGRectMake(self.view.frame.size.width-300, 140, 200, 300);
    //    }else{
    
    _publishView.frame = CGRectMake(_width-(XDY_VIDEOHEIGHT)/3/3*4, (XDY_VIDEOHEIGHT)/3*2, (XDY_VIDEOHEIGHT)/3/3*4, (XDY_VIDEOHEIGHT)/3);
    //    }
    
    
    _publishView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_publishView];
    [self.view bringSubviewToFront:_publishView];
    
    NSNumber *videoId = [NSNumber numberWithInt:mediaId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_publishView,@"view",videoId,@"videoId",nil];
    
    [[XDYClient sharedClient]api:@"publishVideo" message:dic];
    
}



- (void)unpublishView:(int)mediaId{
    
    NSNumber *videoId = [NSNumber numberWithInt:mediaId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_publishView,@"view",videoId,@"videoId",nil];
    
    [[XDYClient sharedClient]api:@"unPublishVideo" message:dic];
    
    [_publishView removeFromSuperview];
    
    
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time type:(MessageType )type icon:(NSString *)icon name:(NSString *)name msgType:(int)msgType{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    MessageInfo *msg = [[MessageInfo alloc] init];
    
    //    mf.showTime = ![self.previousTime isEqualToString:time];
    msg.content = content;
    //    msg.time = time;
    msg.icon = icon;
    msg.type = type;
    msg.userName = name;
    mf.messageInfo = msg;
    msg.msgType = msgType;
    
    self.previousTime = time;
    [_allMessagesFrame addObject:mf];
    [self.chatTableView reloadData];
    
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1  inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark -添加tableView
- (void)loadTableView{
    
    self.chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(2.5, CGRectGetMaxY(_videoView.frame)+5, CGRectGetWidth(_rightView.frame)-5, CGRectGetHeight(self.rightView.frame)-CGRectGetMaxY(_videoView.frame)) style:UITableViewStylePlain];

   
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.tag = 1001;
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self.rightView addSubview:self.chatTableView];
    
    self.chatTableView.tableFooterView = [[UIView alloc]init];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        MessageInfo *messageInfo = [[MessageInfo alloc] init];
        messageInfo.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:messageInfo.time];
        messageFrame.messageInfo = messageInfo;
        previousTime = messageInfo.time;
        [_allMessagesFrame addObject:messageFrame];
        [self.chatTableView reloadData];
    }
    
}


#pragma mark - tableView  Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allMessagesFrame.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        return 60;
    }else{
        return [_allMessagesFrame[indexPath.row] cellHeight];
    }
}

#pragma mark - 设置聊天table的cell样式及数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageFrame *mf = _allMessagesFrame[indexPath.row];
    if (mf.messageInfo.msgType) {
        static NSString *CellIdentifier = @"ChatCell";
        
        XDYMesageChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[XDYMesageChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // 设置聊天数据
        cell.messageFrame = _allMessagesFrame[indexPath.row];
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"Cell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // 设置聊天数据
        cell.messageFrame = _allMessagesFrame[indexPath.row];
        return cell;
    }
}

#pragma mark - cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
#pragma mark - 播放暂停事件
- (void)rePlayBegining:(XDYRePlayToolView *)view{
    
    if (view.rePlaying) {//暂停
        
        for (VideoModel *video in _videoArray) {
            if (video.avplayView.isPlaying) {
                [video.avplayView mediaStop];
            }
        }
        if (_screenShareView.isPlaying) {
            [_screenShareView mediaStop];
        }
        if (_mediaShareView.isPlaying) {
            [_mediaShareView mediaStop];
        }
        
        view.rePlay = false;
        view.rePlaying = NO;
        [[XDYClient sharedClient] api:@"pauseRecordPlayback" message:nil];
        
    }else{
       
        view.rePlay = true;
        view.rePlaying = YES;
        
        [[XDYClient sharedClient] api:@"startRecordPlayback" message:nil];
        for (VideoModel *video in _videoArray) {
            if (video.avplayView != nil) {
                [video.avplayView mediaPlay];
            }
        }
        if (_screenShareView != nil) {
            [_screenShareView mediaPlay];
        }
        if (_mediaShareView != nil) {
            [_mediaShareView mediaPlay];
        }
        
    }
}

#pragma mark - slider的Value改变事件
- (void)SliderValueChange:(UISlider *)slider{
    
    [self.docView setDocFile:nil];
    [self.docView.drawView clearScreen];
    
    [_allMessagesFrame removeAllObjects];
    [self.chatTableView reloadData];
    NSNumber *time = [NSNumber numberWithInt:slider.value];
    
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:time,@"time",nil];
    _rePlayTool.startTime.text = [self formatDuration:slider.value];
    
    NSArray *array = [NSArray arrayWithArray:_videoArray];
    
    for (VideoModel *video in array) {
        if (video.avplayView != nil) {
            [video.avplayView mediaStop];
            [video.avplayView destoryAVPlayer];
            [video.avplayView removeFromSuperview];
            video.avplayView = nil;
        }
        if (video.audioBtn != nil) {
            [video.audioBtn removeFromSuperview];
            video.audioBtn = nil;
            video.audioBtn = false;
        }
        [_videoArray removeObject:video];
    }
    _audioFlag = false;
    
    if (_screenShareView != nil) {
        [_screenShareView mediaStop];
        [_screenShareView destoryAVPlayer];
        [_screenShareView removeFromSuperview];
        _screenShareView = nil;
    }
    if (_mediaShareView != nil) {
        [_mediaShareView mediaStop];
        [_mediaShareView destoryAVPlayer];
        [_mediaShareView removeFromSuperview];
        _mediaShareView = nil;
    }

    
    [[XDYClient sharedClient] api:@"seekRecordPlayback" message:dictionary];
    if (!_rePlayTool.rePlaying) {
        
        [[XDYClient sharedClient] api:@"pauseRecordPlayback" message:nil];
    }
}

#pragma mark - 退出课堂
- (void)backIpadBtn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"您确定要关闭回放吗？",@"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[XDYClient sharedClient]api:@"stopRecordPlayback" message:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSArray *array = [NSArray arrayWithArray:_videoArray];
            for (VideoModel *video in array) {
                if (video.avplayView != nil) {
                    [video.avplayView mediaStop];
                    [video.avplayView destoryAVPlayer];
                    [video.avplayView removeFromSuperview];
                    video.avplayView = nil;
                }
                if (video.audioBtn != nil) {
                    [video.audioBtn removeFromSuperview];
                    video.audioBtn = nil;
                    video.audioBtn = false;
                }
                [_videoArray removeObject:video];
            }
            if (_mediaShareView != nil) {
                [_mediaShareView mediaStop];
                [_mediaShareView destoryAVPlayer];
                [_mediaShareView removeFromSuperview];
                _mediaShareView = nil;
            }
            if (_screenShareView != nil) {
                [_screenShareView mediaStop];
                [_screenShareView destoryAVPlayer];
                [_screenShareView removeFromSuperview];
                _screenShareView = nil;
            }
            
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",@"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (UIImage *)setImageOriginal:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
//时间转换
- (NSString *)formatDuration:(NSTimeInterval)duration {
    
    int minute = 0, secend = duration;
    minute = (secend % 3600) / 60;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}
//#pragma mark - 在ipad设备下强制横屏，在iphone设备下强制竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation     NS_AVAILABLE_IOS(6_0)
{
    
    return UIInterfaceOrientationLandscapeRight;
    
}
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}
#pragma mark - 电话监听事件
-(void)detectCall
{
    
    __weak __typeof(self)weakSelf = self;
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler=^(CTCall* call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            for (VideoModel *video in weakSelf.videoArray) {
                if (video.avplayView.isPlaying) {
                    [video.avplayView mediaPlay];
                }
            }
            
            if (weakSelf.screenShareView.isPlaying) {
                [weakSelf.screenShareView mediaPlay];
            }
            if (weakSelf.mediaShareView.isPlaying) {
                [weakSelf.mediaShareView mediaPlay];
            }
            
            
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            
        }
        
        
    };
}

-(void)afn{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                if (_rePlayTool.rePlaying) {//暂停
                    
                    for (VideoModel *video in _videoArray) {
                        if (video.avplayView.isPlaying) {
                            [video.avplayView mediaStop];
                        }
                    }
                    _rePlayTool.rePlay = false;
                    _rePlayTool.rePlaying = NO;
                    [[XDYClient sharedClient] api:@"pauseRecordPlayback" message:nil];
                }
                [XDYAlert showBottomWithText:NSLocalizedString(@"网络已经断开",@"") duration:2];
                
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [XDYAlert showBottomWithText:NSLocalizedString(@"您目前使用的是移动数据网络",@"") duration:2];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            default:
                break;
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
