//
//  ViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "RePlayViewController.h"
#import "XDYSDK.h"
#import "VideoModel.h"

#import "XDYRePlayToolView.h"
#import "XDYAVPlayerView.h"
//聊天输入工具条
#import "XDYToolBar.h"
//聊天内容显示
#import "MessageFrame.h"
#import "MessageCell.h"
#import "MessageInfo.h"


@interface RePlayViewController ()<HorizontalMenuProtocol,UITableViewDelegate,UITableViewDataSource,HMComposeToolbarDelegate,UITextViewDelegate,XDYRePlayToolDelegate,XDYAVPlayerViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger curImage;
    UIImage* images[3];
    NSMutableArray  *_allMessagesFrame;
    
}
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, strong) UILabel                        *titleLabel;

@property (nonatomic, strong) UIButton                       *backButton;

@property (nonatomic, strong) UIImageView                    *topView;//上部视图

@property (nonatomic, strong) HorizontalMenuView             *menuView;//聊天文档详情工具条

@property (nonatomic, strong) UIView                         *bottomView;//底部视图

@property (nonatomic, strong) NSMutableArray                 *videoArray;//存储video视图及相关信息

@property (nonatomic, strong) XDYAVPlayerView *teaPlayView;
@property (nonatomic, strong) XDYAVPlayerView *stuPlayView;

@property (nonatomic, assign) int                            nodeId;

@property (nonatomic, strong) NSString                       *className;//课堂名称

@property (nonatomic, assign) BOOL                           password;//是否存在密码

@property (nonatomic, assign) int                            mediaId;//视频唯一标识

@property (weak, nonatomic) IBOutlet UITextField             *chatTextField;//聊天框

@property (weak, nonatomic) IBOutlet UILabel                 *chatLabel;//聊天显示区

@property (nonatomic, strong) DocView                        *docView;


//动态ppt
@property (nonatomic, strong) NSString                       *DOCServerIP;
@property (nonatomic, strong) XDYHtmlDocView                 *htmlDocView;
@property (nonatomic, strong) NSString                       *htmlDocUrl;
@property (nonatomic, assign) int                            animationStep;
@property (nonatomic, assign) BOOL                           isFirstStep;
@property (nonatomic, assign) int                            curPageNo;
@property (nonatomic, strong) NSString                       *docVisible;


@property (nonatomic, assign) int                            itemIdx;

@property (nonatomic, strong) NSString                       *fileType;


@property (nonatomic, strong) HMComposeToolbar               *toolbar;//键盘

@property (nonatomic, weak) HMEmotionTextView                *textView;//输入框

@property (nonatomic, strong) HMEmotionKeyboard              *kerboard;

@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;//  是否正在切换键盘

@property (nonatomic, strong) UIView                         *chatView;

@property (nonatomic, assign) CGFloat                        keyboardHeight;

@property (nonatomic, strong) UITableView                    *chatTableView;

@property (nonatomic, strong) UILabel                        *chatTitleLable;

@property (nonatomic, strong) NSString                       *previousTime;

@property (nonatomic, strong) XDYRePlayToolView              *rePlayTool;//拖动条

@property (nonatomic, strong) XDYAVPlayerView                *screenShareView;
@property (nonatomic, strong) XDYAVPlayerView                *mediaShareView;
@property (nonatomic, strong) XDYAVPlayerView                *musicShareView;
@property (nonatomic, strong) NSMutableArray                 *mediaShareArray;

@end

@implementation RePlayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self afn];
    [self loadAllView];
    [self detectCall];
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
                    [XDYLoadingHUD hiddenLoadingAnimation];
                
                    _classType = [message[@"classType"] intValue];
                    _DOCServerIP = message[@"DOCServerIP"];

                    
                    _nodeId = [message[@"nodeId"] intValue];
                    self.titleLabel.text = message[@"className"];

                    self.rePlayTool.endTime.text = [self formatDuration:[message[@"recordPlaybackMaxTime"]floatValue]] ;
                    self.rePlayTool.slider.minimumValue = 0;
                    self.rePlayTool.slider.maximumValue = [message[@"recordPlaybackMaxTime"] floatValue];
                    [self loadSetUp];
                    
                    break;
                case 3://video_play
                    
                    [self PlayView:message isAudio:false];
                    
                    break;
                case 4://video_stop
                    _topView.hidden = NO;
                    _mediaId = [message[@"mediaId"] intValue];
                    [self stopPlay:_mediaId];
                    break;
                case 5://audio_play
                    [self PlayView:message isAudio:true];
                    
                    break;
                case 6://audio_stop
                    _topView.image = [UIImage imageNamed:@"XueDianYunSDK.bundle/video.png"];
                    _mediaId = [message[@"mediaId"] intValue];
                    [self stopPlay:_mediaId];
                    
                    break;
                case 7://video_broadcast
                {
                   
                }
                    break;
                case 8://audio_broadcast
                    
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
                        
                         _itemIdx = [message[@"itemIdx"] intValue];
                        _fileType = message[@"fileType"];
                        
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
                           
                            [_docView setDocFile:docImageUrl];
                            
                            
                        }
                    }
                }

                    
                    break;
                case 12://document_delete
                    
                    if ([message[@"itemIdx"] intValue] == _itemIdx) {
                        
                        [_docView setDocFile:nil];
                        
                    }
                    break;
                case 13://whiteboard_annotation_update
                {
                    if ([message[@"isFresh"] boolValue]) {
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
                            float x = [dic[@"w"] floatValue]/100.0 * XDY_WIDTH;
                            float y = [dic[@"h"] floatValue]/100.0 * XDY_WIDTH;
                            
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
                            if (video.audioImg != nil) {
                                [video.audioImg removeFromSuperview];
                                video.audioImg = nil;
                                video.audioImg = false;
                            }
                            [_videoArray removeObject:video];
                        }

                        [self.view addSubview:_backButton];
                        [_allMessagesFrame removeAllObjects];
                        [self.chatTableView reloadData];
                        _rePlayTool.slider.value = 0;
                        _rePlayTool.startTime.text = @"00:00";
                        [self.view addSubview:_backButton];
                        
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
                case 20:
                {
                    [self loadMusicShare:message];
                
                }
                    break;
                case 21:
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
    
    
    _videoArray = [NSMutableArray arrayWithCapacity:0];
    _allMessagesFrame = [NSMutableArray array];
    _mediaShareArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    _videoArray = [NSMutableArray arrayWithCapacity:0];
    _allMessagesFrame = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //
    UIImageView *topView = [[UIImageView alloc]init];
    topView.frame = CGRectMake(0, 0, XDY_WIDTH,XDY_VIDEOHEIGHT);
    topView.image = [UIImage imageNamed:@"XueDianYunSDK.bundle/video.png"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    _topView = topView;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    [backButton setTitle:NSLocalizedString(@"返回",@"") forState:(UIControlStateNormal)];
    [backButton setImage:[UIImage imageNamed:@"XueDianYunSDK.bundle/back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(ReplaybackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:backButton];
    self.backButton = backButton;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, 60)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [self.view bringSubviewToFront:titleLabel];
    self.titleLabel = titleLabel;
    

    
    //菜单栏
    self.menuView = [[HorizontalMenuView alloc]init];
    _menuView.frame = CGRectMake(0, XDY_VIDEOHEIGHT,XDY_WIDTH,50);
    _menuView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:_menuView];
    //4.设置菜单名数组
    NSArray *menuArray = [NSArray arrayWithObjects:NSLocalizedString(@"文档",@""),NSLocalizedString(@"聊天",@""),nil];
    [_menuView setNameWithArray:menuArray menuModel:0];
    //5.设置委托代理
    _menuView.myDelegate=self;
    
    //底层视图
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_menuView.frame), XDY_WIDTH, XDY_HEIGHT-CGRectGetMaxY(_menuView.frame))];
    [self.view addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _docView = [[DocView alloc]initWithFrame: CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
   
    _docView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:_docView];
    
    //聊天视图
    [self loadTableView];
    // 添加输入工具条
//    [self setupToolbar];
//    // 添加输入控件
//    [self setupTextView];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
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
- (void)loadSetUp{
    
    _htmlDocView = [[XDYHtmlDocView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
    [_htmlDocView loadDOCServerIP:_DOCServerIP];
    [self.bottomView addSubview:_htmlDocView];
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
    
    //开始播放
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
    
    
    _rePlayTool = [[XDYRePlayToolView alloc]initWithFrame:CGRectMake(0, XDY_HEIGHT-40, self.view.frame.size.width, 40)];
    _rePlayTool.delegate = self;
    [self.view addSubview:_rePlayTool];
    [self.view bringSubviewToFront:_rePlayTool];
}

#pragma mark - 初始化课堂
- (void)initXDYRePlayClass{
    
    // 初始化课堂
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",self.portal,@"portal",self.userRole,@"userRole",self.userId,@"userId",nil];
    
    [[XDYClient sharedClient] api:@"initRecordPlayback" message:dictionary];
    
}

#pragma mark - 加入课堂
- (void)userVerify:(BOOL)flag{
    [XDYLoadingHUD hiddenLoadingAnimation];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"加入课堂",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if (flag) {
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"请输入用户名",@"");
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
                if (video.audioImg != nil) {
                    [video.audioImg removeFromSuperview];
                    video.audioImg = nil;
                    video.audioImg = false;
                }
                [_videoArray removeObject:video];
            }
            for (VideoModel *video in array) {
                if (video.avplayView != nil) {
                    [video.avplayView mediaStop];
                    [video.avplayView destoryAVPlayer];
                    [video.avplayView removeFromSuperview];
                    video.avplayView = nil;
                }
                if (video.audioImg != nil) {
                    [video.audioImg removeFromSuperview];
                    video.audioImg = nil;
                    video.audioImg = false;
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
        self.screenShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
        [_bottomView addSubview:_screenShareView];
        self.screenShareView.videoUrlStr = replay;
        
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
              
                self.mediaShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
                self.mediaShareView.delegate = self;
                [_bottomView addSubview:_mediaShareView];
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
            if (self.mediaShareView.volumeSlider.value != [dic[@"mediaVolume"] floatValue]) {
                [self.mediaShareView volumeSet:[dic[@"mediaVolume"] floatValue]];
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
    
    
    int mediaId = [message[@"mediaId"] intValue];
    
    VideoModel *videoModel = [[VideoModel alloc]init];
    XDYAVPlayerView *playView;
    
    if ([message[@"userRole"] isEqualToString:@"normal"] && (_classType == 1)) {
        playView = [[XDYAVPlayerView alloc]initWithFrame: CGRectMake(XDY_WIDTH-(XDY_VIDEOHEIGHT)/3/3*4, (XDY_VIDEOHEIGHT)/3*2, (XDY_VIDEOHEIGHT)/3/3*4, (XDY_VIDEOHEIGHT)/3)];
        _stuPlayView = playView;
    }else{
        playView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, XDY_VIDEOHEIGHT)];
        _teaPlayView = playView;
    }
    
    playView.delegate = self;
    playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playView];
    playView.tag = mediaId;
    [self.view bringSubviewToFront:_backButton];
    if (_stuPlayView != nil) {
        [self.view bringSubviewToFront:_stuPlayView];
    }
    if (isAudio) {
        UIImageView *audioImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(playView.frame), CGRectGetHeight(playView.frame))];
        audioImg.image = [UIImage imageNamed:@"XueDianYunSDK.bundle/audio.png"];
        [playView addSubview:audioImg];
        audioImg.userInteractionEnabled = YES;
        if ([message[@"userRole"] isEqualToString:@"host"]) {
            
            [audioImg addSubview:_backButton];
            [playView sendSubviewToBack:audioImg];
        }
        videoModel.audioImg = audioImg;
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
            
            [_videoArray removeObject:video];
        }
        
    }
    [self.view addSubview:_backButton];
    
}

#pragma mark - 文档聊天详情切换
-(void)getTag:(NSInteger)tag{

    switch (tag) {
        case 0://文档
        {
            _toolbar.hidden = YES;
            _chatTableView.hidden = YES;
            [self.view endEditing:YES];
        }
            break;
        case 1://聊天
        {
            
            _toolbar.hidden = NO;
            _chatTableView.hidden = NO;
            [self.bottomView bringSubviewToFront:_chatTableView];
            [self.bottomView bringSubviewToFront:_toolbar];
        }
            break;
        default:
            break;
    }
}
#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time type:(MessageType )type icon:(NSString *)icon name:(NSString *)name  msgType:(int)msgType{
    
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
    self.chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, CGRectGetHeight(self.bottomView.frame)) style:UITableViewStylePlain];
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.tag = 1001;
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self.bottomView addSubview:self.chatTableView];
    self.chatTableView.hidden = YES;
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

#pragma mark - 添加工具条
- (void)setupToolbar{
    // 1.创建
    HMComposeToolbar *toolbar = [[HMComposeToolbar alloc] init];
    toolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    toolbar.delegate = self;
    toolbar.height = 40;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    [toolbar addSubview:lineView];
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.x = 0;
    toolbar.width = XDY_WIDTH;
    toolbar.y = CGRectGetHeight(_bottomView.frame)-40;
    
    [self.bottomView addSubview:toolbar];
    self.toolbar.hidden = YES;
}

#pragma mark - 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    HMEmotionTextView *textView = [[HMEmotionTextView alloc] init];
    textView.returnKeyType = UIReturnKeySend;
    textView.textColor = [UIColor blackColor];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    textView.frame = CGRectMake(40, 5, CGRectGetWidth(self.toolbar.frame)-80, 30);
    textView.backgroundColor = [UIColor whiteColor];
    textView.delegate = self;
    [self.toolbar addSubview:textView];
    textView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:217/255.0 blue:219/255.0 alpha:1].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    self.textView = textView;
    
    // 2.设置提醒文字（占位文字）
    //    textView.placehoder = @"有问题和大家讨论一下吧";
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}
/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        
        self.keyboardHeight = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        
        
    }];
}
#pragma mark -  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    // 1.拼接表情
    [self.textView appendEmotion:emotion];
    // 2.检测文字长度
    //    [self textViewDidChange:self.textView];
    
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.textView deleteBackward];
}


#pragma mark - 文本框代理方法
#pragma mark -点击textView键盘的回车按钮
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.inputView = nil;
    [textView becomeFirstResponder];
    
}

#pragma mark - 消息发送
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
//        if ([self.textView.text isEqualToString:@""]) {
        
            [textView resignFirstResponder];
            // 1、增加数据源
            NSString *content = [NSString stringWithFormat:@"%@",self.textView.realText];
            [self chatMessage:content];
            
            // 4、清空文本框内容
            textView.text = nil;
            
//        }
        return NO;
    }
    return YES;
}
- (void)chatMessage:(NSString *)message{
    
    //发送聊天消息
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"to",message,@"message",nil];
    [[XDYClient sharedClient] api:@"sendChatMsg" message:dic];
    
}
#pragma mark - HMComposeToolbarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeTool:(HMComposeToolbar *)toolbar didClickedButton:(HMComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
            break;
        case HMComposeToolbarButtonTypeEmotion: // 表情
            [self openEmotion];
            break;
        case HMComposeToolbarButtonTypeMention: //发送
            [self sendChatMessage];
            break;
        default:
            break;
    }
}
/**
 *  打开表情
 */
- (void)openEmotion
{
//    if (self.textView.inputView ) {
//        // 当前显示的是自定义键盘，切换为系统自带的键盘
//        self.textView.inputView = nil;
//        // 显示表情图片
//        self.toolbar.showEmotionButton = YES;
//    } else
//    {
        // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        self.textView.inputView = self.kerboard;
        // 不显示表情图片
//        self.toolbar.showEmotionButton = NO;
//    }
    // 关闭键盘
    [self.textView resignFirstResponder];
    // 记录是否正在更换键盘
    // 更换完毕完毕
    self.changingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textView becomeFirstResponder];
    });
}

#pragma mark - 消息发送
- (void)sendChatMessage
{
    if ([self.textView.text isEqualToString:@""]) {
        
    }else{
        [self.textView resignFirstResponder];
        // 1、增加数据源
        NSString *content = [NSString stringWithFormat:@"%@",self.textView.realText];
        
        [self chatMessage:content];
        
        // 4、清空文本框内容
        self.textView.text = nil;
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
        if (video.audioImg != nil) {
            [video.audioImg removeFromSuperview];
            video.audioImg = nil;
            video.audioImg = false;
        }
        [_videoArray removeObject:video];
    
    }

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
    
    [self.view addSubview:_backButton];
    
    [[XDYClient sharedClient] api:@"seekRecordPlayback" message:dictionary];
    if (!_rePlayTool.rePlaying) {
        
         [[XDYClient sharedClient] api:@"pauseRecordPlayback" message:nil];
        
    }
}

#pragma mark - 退出课堂
- (void)ReplaybackBtn {
    
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
                if (video.audioImg != nil) {
                    [video.audioImg removeFromSuperview];
                    video.audioImg = nil;
                    video.audioImg = false;
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


#pragma mark - 初始化方法
- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = XDY_WIDTH;
        self.kerboard.height = 216;
    }
    return _kerboard;
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

#pragma mark - 在ipad设备下强制横屏，在iphone设备下强制竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation     NS_AVAILABLE_IOS(6_0)
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//        return UIInterfaceOrientationLandscapeRight;
//    }else{
        return UIInterfaceOrientationPortrait;
//    }
}
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return NO;
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
