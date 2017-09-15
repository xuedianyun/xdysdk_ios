//
//  ViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "ClassViewController.h"
#import "XDYSDK.h"
#import "VideoModel.h"


//聊天输入工具条
#import "XDYToolBar.h"
//聊天内容显示
#import "MessageFrame.h"
#import "MessageCell.h"
#import "MessageInfo.h"
#import "XDYDrawView.h"
#import "XDYQuestionnaireView.h"
#import "XDYIphonePlayView.h"
#import "XDYIphonePublishView.h"

@interface ClassViewController ()<HorizontalMenuProtocol,UITableViewDelegate,UITableViewDataSource,HMComposeToolbarDelegate,UITextViewDelegate,popActionSheetDelegate,UIGestureRecognizerDelegate,XDYDrawViewDelegate,XDY_ChoicePictureVCDelegate,XDY_CameraVCDelegate,XDY_ChoicePictureListVCDelegate,XDYAVPlayerViewDelegate>
{
    NSInteger curImage;
    UIImage* images[3];
    NSMutableArray  *_allMessagesFrame;
    NSMutableArray  *_memberArray;
    UILabel *_totalNum;
    UIView *_footerView;
}
@property (nonatomic, strong) XDYIphonePlayView              *playView;
@property (nonatomic, strong) XDYIphonePublishView           *publishView;
@property (nonatomic, strong) HorizontalMenuView             *menuView;//聊天文档详情工具条
@property (nonatomic, strong) XDYBottomView                  *bottomView;//底部视图
@property (nonatomic, strong) NSMutableArray                 *videoArray;//存储video视图及相关信息
@property (nonatomic, strong) DocView                        *docView;//文档视图
@property (nonatomic, strong) NSMutableArray                 *pointArray;//标注数组
@property (nonatomic, strong) XDYHtmlDocView                 *htmlDocView;//动态ppt视图
@property (nonatomic, strong) NSString                       *htmlDocUrl;//文档url
@property (nonatomic, assign) int                            animationStep;//
@property (nonatomic, assign) int                            aniStepFirst;
@property (nonatomic, assign) BOOL                           isFirstStep;
@property (nonatomic, assign) int                            curPageNo;
@property (nonatomic, strong) NSString                       *docVisible;
@property (nonatomic, assign) int                            itemIdx;//文档唯一标识
@property (nonatomic, strong) NSString                       *fileType;//文档类型
@property (nonatomic, strong) HMComposeToolbar               *toolbar;//键盘
@property (nonatomic, weak) HMEmotionTextView                *textView;//输入框
@property (nonatomic, strong) HMEmotionKeyboard              *kerboard;//表情键盘
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;//  是否正在切换键盘
@property (nonatomic, strong) UIView                         *chatView;
@property (nonatomic, assign) CGFloat                        keyboardHeight;
@property (nonatomic, strong) UITableView                    *chatTableView;//聊天列表
@property (nonatomic, strong) UILabel                        *chatTitleLable;
@property (nonatomic, strong) UITableView                    *memberTableView;//成员列表
@property (nonatomic, assign) BOOL                           isMember;
@property (nonatomic, strong) NSString                       *previousTime;
@property (nonatomic, strong) NSString                       *success;
@property (nonatomic, strong) NSMutableDictionary            *screenDic;
@property (nonatomic, strong) XDYAVPlayerView                *mediaShareView;//媒体共享
@property (nonatomic, strong) XDYAVPlayerView                *musicShareView;//伴音
@property (nonatomic, strong) XDYQuestionnaireView           *questionnaireView;//答题卡、签到
@property (nonatomic, strong) NSDictionary                   *questionDic;
@property (nonatomic, strong) NSDictionary                   *signDic;
@property (nonatomic, assign) int                            questionItemIdx;
@property (nonatomic, assign) BOOL                           callfire;
@property (nonatomic, assign) BOOL                           questionfire;


@end

@implementation ClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self applyMicOrCamera];
    _success = 0;
    XDYClient *xdyClient = [XDYClient sharedClient];//创建xdy客户端
    [xdyClient initXDY];//初始化学点云
    
    [xdyClient catchJsLog];
    
    [self initVariable];//初始化所有变量
    [self loadAllView];//加载所有视图
    [self loadData];//数据加载
    [self loadNotification];//通知消息监听
    //双击事件
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 2; // 单击
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
   
}
#pragma mark -初始化所有变量
- (void)loadData{
    
    //接收所有课堂消息
    [[XDYClient sharedClient] getMessageXDYBlock:^(id type, id message) {
        
        XDYClassEventType index = (int)[[self returnTypeArray] indexOfObject:type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (index) {
                case XDYClassEventTypeInit://init
                    //初始化逻辑
                    [self initXDYClass:message];
                   
                    break;
                case XDYClassEventTypeInitSuccess://class_init_success
                    
                    [self initSuccess:message];
                    
                    break;
                case XDYClassEventTypeJoinSuccess://class_join_success

                    [self joinSuccess:message];
                    
                    break;
                case XDYClassEventTypeClassUpdateStatus://class_update_status
                {
                    [self classUpdateStatus:message];
                    
                }
                    break;
                case XDYClassEventTypeClassUpdateRoster://class_update_roster
                
                    [self classUpdateRoster:message];
                    
                    break;
                case XDYClassEventTypeClassInsertRoster://class_insert_roster
                {
                    [self classInsertRoster:message];
                }
                    break;
                case XDYClassEventTypeClassDeleteRoster://class_delete_roster
                {
                    [self classDeleteRoster:message];
                    
                }
                    break;
                case XDYClassEventTypeVideoPlay://video_play
                {
                }
                    break;
                case XDYClassEventTypeVideoStop://video_stop
                    
                    
                    break;
                case XDYClassEventTypeAudioPlay://audio_play
                   
                    
                    break;
                case XDYClassEventTypeAudioStop://audio_stop
                {
                }
                    break;
                case XDYClassEventTypeVideoBroadcast://video_broadcast
                {
                    [self videoBroadcast:message];
                }
                    break;
                case XDYClassEventTypeAudioBroadcast://audio_broadcast
                    break;
                case XDYClassEventTypeMediaStopPublish://media_stop_publish
                {
                }
                    break;
                case XDYClassEventTypeScreenSharePlay://screen_share_play
               
                    break;
                case XDYClassEventTypeScreenShareStop://screen_share_stop
                
                    break;
                case XDYClassEventTypeMediaSharedUpdate://media_shared_update
                {
                    [self loadMediaShareView:message];
                }
                    break;
                case XDYClassEventTypeMediaSharedDelete://media_shared_delete
                {
                    [self mediaShareDelete:message];
                }
                    break;
                case XDYClassEventTypeMusicSharedUpdate://music_shared_update
                {
                    
                    [self loadMusicShare:message];
                }
                    break;
                case XDYClassEventTypeMusicShredDelete://music_shared_delete
                {
                    [self musicShareDelete:message];
                }
                    break;
                case XDYClassEventTypeChatReceiveMessage://chat_receive_message
                {
                    [self chatReciveMessage:message];
                }
                    break;
                
                case XDYClassEventTypeDocumentUpdate://document_update
                {
                    [self documentUpdate:message];
                }
                    break;
                case XDYClassEventTypeDocumentDelete://document_delete
                    
                    [self documentDelete:message];
                    
                    break;
                    
                case XDYClassEventTypeWhiteboardAnnotationUpdate://whiteboard_annotation_update
                {
                    [self writeBoardAnnotationUpdate:message];
                    
                }
                    break;
                case XDYClassEventTypeCursorUpdate://cursor_update
                {
                    [self cursorUpdate:message];
                    
                }
                    break;

                case XDYClassEventTypeStartAnswerQuestion://start_answer_question
                {
                    [self startAnswerQuestion:message];
                    
                }
                    break;
                case XDYClassEventTypeStopAnswerQuestion://stop_answer_question
                {
                    [self stopAnswerQuestion:message];
                    
                }
                    break;
                case XDYClassEventTypeUpadateQuestionTime://update_question_time
                {
                    [self upadateQuestionTime:message];
                    
                }
                    break;
                case XDYClassEventTypeClassExit://class_exit
                {
                    [self classExit:message];
                    
                }
                    break;
                case XDYClassEventTypeErrorEvent://error_event
                {
                    
                    [self errorEvent:message];
                    
                }
                    break;
                default:
                    break;
            }
        });
    }];
    

    [[XDYClient sharedClient] XDYRemoteVideo:^(id type, id message) {
        NSLog(@"type,%@response%@",type,message);
        
        NSArray *typeArray = [NSArray arrayWithObjects:@"Decoded",@"Frame",@"Offline",@"Muted", nil];
        int index = (int)[typeArray indexOfObject:type];
        
        switch (index) {
            case 0://视频编码开始
            {
                NSNumber *uid = message[@"uid"];
                for (XDYMemberModel *model in _memberArray) {
                    if (model.nodeId  == [uid intValue] && [model.userRole isEqualToString:@"host"]) {
                
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_playView.playView,@"playView",uid,@"uid", nil];
                        [[XDYClient sharedClient]RTCApi:@"playVideo" message:dic];
                        [_playView hiddenLayer];
                        
                    }
                }
            }
                break;
            case 1:
                
                break;
            case 2://用户离线
            {
                [_playView showLayer];
            }
                break;
            case 3://推流停止推流
            {
                NSNumber *uid = message[@"uid"];
                BOOL muted = [message[@"muted"] boolValue];
                for (XDYMemberModel *model in _memberArray) {
                    if (model.nodeId  == [uid intValue] && [model.userRole isEqualToString:@"host"]) {

                        if(muted){
                            [_playView showLayer];
                        }else{
                            [_playView hiddenLayer];
                        }
                        
                    }
                }
            }
                break;
            default:
                break;
        }

    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        if (![_success isEqualToString:@"1"]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [XDYAlert showBottomWithText:NSLocalizedString(@"加载课堂失败，请重新进入!",@"")];
            }];
        }
    });
    
}

- (void)handControl{
   
    for (XDYMemberModel *model in _memberArray) {
        if (model.handUpTime == 0) {
            if (model.nodeId == _joinSuccessModel.nodeId) {//教师端控制学生取消举手
                _menuView.handButton.selected = false;
                [_menuView.handButton setImage:[UIImage imageNamed:@"hand-normal-"] forState:(UIControlStateNormal)];
            }
        }
    }
}

#pragma mark - 禁言
- (void)classUpdateStatus:(NSDictionary *)dic{
    
    
    [_menuView setModel:dic];
    
    
    if ([dic[@"silence"] boolValue]) {
        _textView.placehoder = [NSString stringWithFormat:@"你已经被禁言，暂时不能发言"];
        _textView.editable = NO;
        _toolbar.userInteractionEnabled = NO;
        _footerView.hidden = NO;
        
    }else{
        NSDictionary *silenceUsers = dic[@"silenceUsers"];
        
        if ([silenceUsers isKindOfClass:[NSNull class]]) {
            return;
        }
        
        if ( [[silenceUsers allKeys] containsObject:_joinSuccessModel.userId]) {
            _textView.placehoder = [NSString stringWithFormat:@"你已经被禁言，暂时不能发言"];
            _textView.editable = NO;
            _toolbar.userInteractionEnabled = NO;
            _footerView.hidden = NO;
            
           
        }else{
            _textView.placehoder = @"";
            _textView.editable = YES;
            _toolbar.userInteractionEnabled = YES;
            _footerView.hidden = YES;
            

        }
        
    }
    [self userListBanned:dic];
    
}
- (void)userListBanned:(NSDictionary *)dic{
    
    if ([dic[@"silence"] boolValue]) {
        
        for (XDYMemberModel *model in _memberArray){
            model.isBannedChat = true;
            
        }
    }else{
        NSDictionary *silenceUsers = dic[@"silenceUsers"];
        NSArray *keys = [silenceUsers allKeys];
        
        for (XDYMemberModel *model in _memberArray){
            model.isBannedChat = false;
            
            for (int i = 0; i<keys.count; i++) {
                
                
                if ([model.userId isEqualToString:keys[i]] ) {
                    model.isBannedChat = true;
                }
            }
        }

    }
    
    if (_isMember) {
        [_memberTableView reloadData];
    }
    
}

- (void)EndBackgroundAction:(NSNotification *)notification{
    [_htmlDocView removeFromSuperview];
    _htmlDocView = nil;
    
    
    [_publishView unpublishVideo];
    [[XDYClient sharedClient] RTCApi:@"unPublishVideo" message:nil];

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
            
            if(_mediaShareView.isPlaying){
                [_mediaShareView mediaPlay];
            }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            Log(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
- (void)loadNotification{
    
    //进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndBackgroundAction:) name:@"enterBackground" object:nil];
    //耳机插播监听
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
}
- (void)initVariable{
    
    //初始化所有变量
    _videoArray = [NSMutableArray arrayWithCapacity:0];
    _allMessagesFrame = [NSMutableArray array];
    _screenDic = [NSMutableDictionary dictionary];
    _memberArray = [NSMutableArray array];
    _itemIdx = -1;
    _questionItemIdx = -1;
    _isMember = false;
    _callfire = false;
    _questionnaireView = false;
    _questionDic = [NSDictionary dictionary];
    _signDic = [NSDictionary dictionary];
    _pointArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    self.textView.inputView = nil;
    self.toolbar.showEmotionButton = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];//页面加载时提供加载页面
}

- (void)loadAllView{
    
    __weak typeof(self) weakself = self;
    //播放窗口
    _playView = [[[NSBundle mainBundle] loadNibNamed:@"XDYIphonePlayView" owner:nil options:nil] lastObject];
    _playView.frame = CGRectMake(0, 0, XDY_WIDTH,XDY_VIDEOHEIGHT);
    [self.view addSubview:_playView];
    _playView.backBlock = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出课堂吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[XDYClient sharedClient]api:@"leaveClass" message:nil];
            [weakself dismissViewControllerAnimated:YES completion:^{
                [weakself stopAllVideoPlay];
                
                if (weakself.musicShareView !=nil) {
                    [weakself.musicShareView mediaStop];
                    [weakself.musicShareView destoryAVPlayer];
                    [weakself.musicShareView removeFromSuperview];
                    weakself.musicShareView = nil;
                }
                if (weakself.mediaShareView != nil) {
                    [weakself.mediaShareView mediaStop];
                    [weakself.mediaShareView destoryAVPlayer];
                    [weakself.mediaShareView removeFromSuperview];
                    weakself.mediaShareView = nil;
                }
                
                
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [weakself presentViewController:alertController animated:YES completion:nil];
    };
    //推流窗口
    _publishView = [[[NSBundle mainBundle] loadNibNamed:@"XDYIphonePublishView" owner:nil options:nil]lastObject];
    _publishView.frame = CGRectMake(XDY_WIDTH/3*2, XDY_VIDEOHEIGHT-XDY_WIDTH/3/3*4, XDY_WIDTH/3, XDY_WIDTH/3/3*4);
    [_playView addSubview:_publishView];
    
    _publishView.publishBlock = ^{
        
        [[XDYClient sharedClient] RTCApi:@"publishVideo" message:nil];
        
    };
    _publishView.unPublishBlock = ^{
        
        [[XDYClient sharedClient] RTCApi:@"unPublishVideo" message:nil];
    };
    

    //菜单栏
    UIView *menu = [[UIView alloc]initWithFrame:CGRectMake(0, XDY_VIDEOHEIGHT,XDY_WIDTH,50)];
    [self.view addSubview:menu];
    
    self.menuView = [[HorizontalMenuView alloc]init];
    _menuView.frame = CGRectMake(0, XDY_VIDEOHEIGHT,XDY_WIDTH,50);
    _menuView.backgroundColor = kUIColorFromRGB(0xfafafa);
    [self.view addSubview:_menuView];
    
    
    //5.设置委托代理
    _menuView.myDelegate=self;
    
    //底层视图
    _bottomView = [[XDYBottomView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(menu.frame), XDY_WIDTH, XDY_HEIGHT-CGRectGetMaxY(menu.frame))];
    [self.view addSubview:_bottomView];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _docView = [[DocView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
    _docView.drawView.delegate = self;
    _docView.backgroundColor = [UIColor whiteColor];
    _docView.hidden = YES;
    [self.bottomView addSubview:_docView];
    [self.bottomView sendSubviewToBack:_docView];
    
    _docView.userInteractionEnabled = YES;
    
    //聊天视图
    [self loadTableView];
//    if (_classType == 3) {
    [self loadmemberTableView];
//    }
    // 添加输入工具条
    [self setupToolbar];
    // 添加输入控件
    [self setupTextView];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
    UIButton *selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    selectBtn.frame = CGRectMake(0, 100, 100, 30);
    selectBtn.backgroundColor = [UIColor redColor];
}

- (void)loadSuccessView{

    //4.设置菜单名数组
    NSArray *menuArray;
    if (menuArray == nil) {
        if ([self.userRole isEqualToString:@"invisible"]) {
            menuArray = [NSArray arrayWithObjects:NSLocalizedString(@"文档",@"此处为文档"),NSLocalizedString(@"聊天",@""),nil];
            [_menuView setNameWithArray:menuArray menuModel:0];
            
        }else{
            if (_joinSuccessModel.classType == 1) {
                menuArray = [NSArray arrayWithObjects:NSLocalizedString(@"文档",@"此处为文档"),NSLocalizedString(@"聊天",@""),nil];
                
                [_menuView setNameWithArray:menuArray menuModel:2];
            }else{
                menuArray = [NSArray arrayWithObjects:NSLocalizedString(@"文档",@"此处为文档"),NSLocalizedString(@"聊天",@""),NSLocalizedString(@"成员",@""),nil];
                
                [_menuView setNameWithArray:menuArray menuModel:1];
            }
        }
    }
    //初始化rtc
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_publishView.publishView,@"publishView", nil];
    [[XDYClient sharedClient]RTCApi:@"initAudioAndVideo" message:dic];
}
#pragma mark - 加载动态ppt
- (void)loadHTMLDocView{
    
    _htmlDocView = [[XDYHtmlDocView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
    
    _htmlDocView.drawView.delegate = self;
    
    [_htmlDocView loadDOCServerIP:_joinSuccessModel.DOCServerIP];
    
    [self.bottomView addSubview:_htmlDocView];
    [self.bottomView sendSubviewToBack:_htmlDocView];
    
    [self.htmlDocView getMessageXDYDocBlock:^(id type, id message) {
        
        if ([type isEqualToString:@"success"]) {
            _docVisible = message;
        }else if([type isEqualToString:@"loadDocSuccess"]&&[message isEqualToString:@"1"]){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self.htmlDocView jumpPage:_curPageNo];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    
                    for (int i = 1; i<_aniStepFirst; i++) {
                        [self.htmlDocView nextStep];
                        
                    }
                });
            });
        }
        
    }];
}



- (void)loadQuestionView:(NSDictionary *)message isHoriz:(BOOL)isHoriz{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *options = message[@"options"];
    CGSize answer;
    //    CGFloat size.
    NSMutableArray *heightArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    CGFloat y = 10;
    
    for (int i = 0; i <options.count; i++) {
        
        NSString *title = options[i];
        answer = [title sizeWithFont:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(self.view.frame.size.width-160, HUGE_VALF)];
        NSNumber *height = [NSNumber numberWithFloat:answer.height];
        NSNumber *width = [NSNumber numberWithFloat:answer.width];
        if (answer.height < 40) {
            answer.height = 40;
        }
        
        [heightArray addObject:height];
        [widthArray addObject:width];
        y+=answer.height+5;
    }
    
    NSArray *array = [widthArray sortedArrayUsingComparator:cmptr];
    NSString *max = [array lastObject];
    
    
    if ([max intValue]<15) {
        isHoriz = true;
    }
    CGFloat height;
    if (isHoriz) {
        height = 40;
    }else{
        height = y;
        
    }
    
    
    int pointx = 0, pointY = 0;
    
    for ( int i = 0; i < [options count]; ++i ){
        
        int answerw = (pointx + [widthArray[i] intValue] + 40);
        int w =(self.view.frame.size.width-90);
        if ( answerw > w){
            pointx = 0;
            int h = [heightArray[i-1] floatValue];
            if (h < 40) {
                h = 40;
            }
            pointY += h;
        }
        pointx += [widthArray[i] integerValue]+40;
        
    }
    if (isHoriz) {
        self.questionnaireView.frame = CGRectMake(0, CGRectGetHeight(_bottomView.frame)-height, XDY_WIDTH, height);
    }else{
        
        self.questionnaireView.frame = CGRectMake(0, CGRectGetHeight(_bottomView.frame)-pointY-20-60, XDY_WIDTH, pointY+60+20);
    }
   
    
    [self.bottomView addSubview:self.questionnaireView];
    
    [self.questionnaireView getAnswerXDYBlock:^(NSString *questionId, NSArray *answer) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[_questionDic[@"itemIdx"] intValue]],@"itemIdx",[NSNumber numberWithInt:[_questionDic[@"questionId"] intValue]],@"questionId",answer,@"answer", nil];
        [[XDYClient sharedClient]api:@"sendAnswer" message:dic];
        
    }];

}
#pragma mark - 初始化课堂
- (void)initXDYClass:(NSDictionary *)message{
    _success = message[@"success"];
    [self initXDY:message];
    
}

- (void)showError{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"密码输入错误，请重新输入!",@"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self userVerify:true];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 课堂初始化成功
- (void)initSuccess:(NSDictionary *)message{
    BOOL flag = [message[@"passwordRequired"] boolValue];
    [self userVerify:flag];
    
}
- (void)joinSuccess:(NSDictionary *)message{
    
    [self joinXDYSuccess:message];
    
    
    _playView.titleLable.text = message[@"className"];
    [XDYLoadingHUD hiddenLoadingAnimation];
    
    [self loadSuccessView];
    

}
- (void)classUpdateRoster:(NSDictionary *)message{
    
    NSDictionary *nodeData = message[@"nodeData"];
    if (nodeData ==NULL) {
        return;
    }
    XDYMemberModel *memberModel = [[XDYMemberModel alloc]init];
    memberModel.userId = nodeData[@"userId"];
    memberModel.nodeId = [message[@"nodeId"] intValue];
    memberModel.userRole = nodeData[@"userRole"];
    memberModel.name = nodeData[@"name"];
    memberModel.handUpTime = [nodeData[@"handUpTime"] intValue];
    memberModel.openCamera = [nodeData[@"openCamera"] intValue];
    memberModel.openMicrophones = [nodeData[@"openMicrophones"] intValue];
    memberModel.deviceType = [nodeData[@"deviceType"]intValue];
    
    NSArray *member = [NSArray arrayWithArray:_memberArray];
    for (XDYMemberModel *model in member) {
        if (model.nodeId == memberModel.nodeId) {
            [_memberArray removeObject:model];
        }
    }
    [_memberArray addObject:memberModel];
    if ([memberModel.userRole isEqualToString:@"host"]) {
        [_memberArray exchangeObjectAtIndex:0 withObjectAtIndex:_memberArray.count-1];
    }else if(memberModel.nodeId == _joinSuccessModel.nodeId && (_memberArray.count>1)){
        [_memberArray exchangeObjectAtIndex:1 withObjectAtIndex:_memberArray.count-1];
    }
    
    [self handControl];
    
    if (_isMember) {
        [_memberTableView reloadData];
    }
    
    //控制老师视频的显示隐藏
    if ([memberModel.userRole isEqualToString:@"host"]) {
    
        if (memberModel.openCamera == 0) {
            [_playView showLayer];
        }else{
            [_playView hiddenLayer];
        }

    
    }

}
- (void)classInsertRoster:(NSDictionary *)message{
    NSDictionary *nodeData = message[@"nodeData"];
    
    if (nodeData != NULL) {
        
        XDYMemberModel *memberModel = [[XDYMemberModel alloc]init];
        memberModel.userId = nodeData[@"userId"];
        memberModel.nodeId = [message[@"nodeId"] intValue];
        memberModel.userRole = nodeData[@"userRole"];
        memberModel.name = nodeData[@"name"];
        memberModel.handUpTime = [nodeData[@"handUpTime"] intValue];
        memberModel.openCamera = [nodeData[@"openCamera"] intValue];
        memberModel.openMicrophones = [nodeData[@"openMicrophones"] intValue];
        memberModel.deviceType = [nodeData[@"deviceType"]intValue];
        
        NSArray *member = [NSArray arrayWithArray:_memberArray];
        for (XDYMemberModel *model in member) {
            if (model.nodeId == memberModel.nodeId) {
                [_memberArray removeObject:model];
            }
        }
        [_memberArray addObject:memberModel];
        if ([memberModel.userRole isEqualToString:@"host"]) {
            [_memberArray exchangeObjectAtIndex:0 withObjectAtIndex:_memberArray.count-1];
        }else if(memberModel.nodeId == _joinSuccessModel.nodeId && (_memberArray.count>1)){
            [_memberArray exchangeObjectAtIndex:1 withObjectAtIndex:_memberArray.count-1];
        }
        
        if (_isMember) {
            [_memberTableView reloadData];
        }
    }
}
- (void)classDeleteRoster:(NSDictionary *)message{
    int nodeId = [message[@"nodeId"] intValue];
    
    NSArray *member = [NSArray arrayWithArray:_memberArray];
    for (XDYMemberModel *model in member) {
        if (model.nodeId == nodeId) {
            [_memberArray removeObject:model];
        }
    }
    if (_isMember) {
        [_memberTableView reloadData];
    }

}
#pragma mark - 加入课堂
- (void)userVerify:(BOOL)flag{
 
    [self userXDYVerify:flag confirm:^(id data) {
        
        if ([data[@"success"] boolValue]) {
            
            [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];
           
        }else{
             [self userVerify:flag];
        }
        
    } cancel:^(id data) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self stopAllVideoPlay];
        }];
    }];
    
    [XDYLoadingHUD hiddenLoadingAnimation];
    
}

-(void)stopAllVideoPlay{
    
    
    [[XDYClient sharedClient] RTCApi:@"destoryAudioAndVideo" message:nil];

}


- (void)videoBroadcast:(NSDictionary *)message{
    
    if([message[@"toNodeId"] intValue] == _joinSuccessModel.nodeId){
        
        int actionType =[message[@"actionType"] intValue];
        switch (actionType) {
            case 0:
                
                break;
            case 1:
                [_publishView publishVideo];
                [[XDYClient sharedClient] RTCApi:@"publishVideo" message:nil];
                break;
            case 2:
                [_publishView unpublishVideo];
                [[XDYClient sharedClient] RTCApi:@"unPublishVideo" message:nil];
                break;
            case 3:
            {
                
                
                
            }
                break;
            default:
                break;
        }
        
    }

}
- (void)audioBroadcast:(NSDictionary *)message{
    
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
        
        [self.musicShareView destoryAVPlayer];
        [self.musicShareView removeFromSuperview];
        self.musicShareView = nil;
    }
}
- (void)chatReciveMessage:(NSDictionary *)message{
    NSString *dateString = [XDYCurrentTime getChatTime];
    
    if ([message[@"fromNodeId"] intValue] == _joinSuccessModel.nodeId) {//自己发送消息
        //                        [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeMe icon:@"XueDianYunSDK.bundle/ClassRoomStudentIcon" name:message[@"fromName"]];
    }else{
        if ([message[@"fromRole"] isEqualToString:@"host"]) {
            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeTeacher icon:@"XueDianYunSDK.bundle/ClassRoomTeacherIcon" name:message[@"fromName"] imgURL:nil msgType:[message[@"msgType"] intValue] isSuccess:false];
        }else{
            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeOther icon:@"ClassRoomStudentIcon" name:message[@"fromName"] imgURL:nil msgType:[message[@"msgType"] intValue] isSuccess:false];
        }
    }
}

- (void)documentUpdate:(NSDictionary *)message{
 
    if ([message[@"visible"] intValue] == 1){
        
        _itemIdx = [message[@"itemIdx"] intValue];
        _fileType = message[@"fileType"];
        
        if ([message[@"fileType"] isEqualToString:@"zip"]) {
            
            
            _docView.hidden = YES;
            NSString *docImageUrl = message[@"html"];
            
            if (![docImageUrl isEqualToString:_htmlDocUrl]) {
                if (_htmlDocView != nil) {
                    [_htmlDocView removeFromSuperview];
                    _htmlDocView = nil;
                }
                [self loadHTMLDocView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
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
            _aniStepFirst = animationStep;
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
            
            _htmlDocUrl = @"";
            [self.htmlDocView setSrc:@""];
            self.htmlDocView.hidden = YES;
            
            NSArray *docImgArr = message[@"images"];
            if(docImgArr.count == 0){
                return;
            }
            int curpage = [message[@"curPageNo"] intValue]-1;
            NSString *docImageUrl = docImgArr[curpage];
            _docView.hidden = NO;
            [_docView setDocFile:docImageUrl];
            
        }
    }
}

- (void)documentDelete:(NSDictionary *)message{
    if ([message[@"itemIdx"] intValue] == _itemIdx) {
        [_docView setDocFile:nil];
        [_htmlDocView setSrc:@""];
        _htmlDocView.hidden = YES;
    }
}

- (void)writeBoardAnnotationUpdate:(NSDictionary *)message{
    __weak typeof(self) weakself = self;
    if ([_fileType isEqualToString:@"zip"]) {
        [_htmlDocView setWriteBoard:message annotaionArray:^(id data) {
            [weakself saveAnnotation:(NSArray *)data Message:message];

        }];
        
    }else{
        [_docView setWriteBoard:message annotaionArray:^(id data) {
            [weakself saveAnnotation:(NSArray *)data Message:message];
        }];
    }
}

- (void)saveAnnotation:(NSArray *)array Message:(NSDictionary *)message{
    
    if ([message[@"isFresh"] boolValue]) {
        self.pointArray = [NSMutableArray arrayWithArray:array];
    }else{
        [self.pointArray addObject:array[0]];
    }
}

- (void)cursorUpdate:(NSDictionary *)message{
   
    
    NSArray *point = message[@"pointGroup"];
    if (point.count == 0) {
        if (self.htmlDocView.hidden == NO  && self.htmlDocView !=nil) {
            _htmlDocView.drawView.cursorView.hidden = YES;
            
        }else{
            _docView.drawView.cursorView.hidden = YES;
            
        }
        return;
    }
    NSDictionary *dic = point.lastObject;
    
    float x = [dic[@"w"] floatValue]/100.0 * XDY_WIDTH;
    float y = [dic[@"h"] floatValue]/100.0 * XDY_WIDTH;
    
    if (self.htmlDocView.hidden == NO  && self.htmlDocView !=nil) {
        _htmlDocView.drawView.cursorView.hidden = NO;
        [_htmlDocView setCursorX:x Y:y];
        
    }else{
        _docView.drawView.cursorView.hidden = NO;
        [_docView setCursorX:x Y:y];
    }
    
}
- (void)startAnswerQuestion:(NSDictionary *)message{
    if ([message[@"itemIdx"]intValue] != _questionItemIdx) {
        int type = [message[@"type"] intValue];
        _questionItemIdx= [message[@"itemIdx"]intValue];
        
        int timeLimit = [message[@"timeLimit"] intValue];
        if (type == 1) {//单选
            
            _questionDic = message;
            
            [self loadQuestionView:message isHoriz:false];
            [self.questionnaireView showWithDuration:timeLimit type:0 titleArray:_questionDic[@"options"] isCheck:NO];
            
            
            
        }else if (type == 2){//多选
            _questionDic = message;
            [self loadQuestionView:message isHoriz:false];
            [self.questionnaireView showWithDuration:timeLimit type:1 titleArray:_questionDic[@"options"] isCheck:YES];
            
        }else if (type == 3){//判断
            
            _questionDic = message;
            [self loadQuestionView:message isHoriz:true];
            [self.questionnaireView showWithDuration:timeLimit type:2 titleArray:_questionDic[@"options"] isCheck:NO];
            
        }else if (type == 100) {//点名
            
            _signDic = message;
            [XDYCallView showPayActivityAlertViewWithTimer:timeLimit withAlertViewCompleteHandler:^(NSString *answer) {
                if ([answer isEqualToString:@"签到"]) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[_signDic[@"itemIdx"] intValue]],@"itemIdx",[NSNumber numberWithInt:[_signDic[@"questionId"] intValue]],@"questionId",@"",@"answer", nil];
                    [[XDYClient sharedClient]api:@"sendAnswer" message:dic];
                    
                }
                
            }];
            
        }
        
    }

}
- (void)stopAnswerQuestion:(NSDictionary *)message{
    if ([message[@"type"] intValue] == 100) {
        [XDYCallView closeAlertView];
        _callfire = false;
    }else{
        [self.questionnaireView hide];
        [_questionnaireView removeFromSuperview];
        _questionnaireView = nil;
        _questionfire = false;
    }
}
- (void)upadateQuestionTime:(NSDictionary *)message{
    int type = [message[@"type"] intValue];
    if (type == 100) {
            [XDYCallView showCallTimer:[message[@"timestamp"] intValue]];
            _callfire = true; 
    }else{
        if (!_questionfire) {
            [self.questionnaireView showQuestionTimer:[message[@"timestamp"] intValue]];
            _questionfire =true;
        }
        
    }
}
- (void)classExit:(NSDictionary *)message{
    
    [self classExitXDY:message confirm:^(id data) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self stopAllVideoPlay];
            if (_musicShareView !=nil) {
                [_musicShareView mediaStop];
                [_musicShareView destoryAVPlayer];
                [_musicShareView removeFromSuperview];
                _musicShareView = nil;
            }
            
            if (_mediaShareView != nil) {
                [_mediaShareView mediaStop];
                [_mediaShareView destoryAVPlayer];
                [_mediaShareView removeFromSuperview];
                _mediaShareView = nil;
            }
            
        }];
        
    }];
    
}

- (void)errorEvent:(NSDictionary *)message{
    
    [self erorEventXDY:message confirm:^(id data) {
        [self userVerify:true];
    }];
        
}

- (void)loadMediaShareView:(NSDictionary *)dic{
    XDYMediaSharedModel *mediaShareModel = [[XDYMediaSharedModel alloc]initWithDictionary:dic];
    switch (mediaShareModel.status) {
        case 0:
        {
            if (self.mediaShareView.tag == mediaShareModel.itemIdx) {
                [self.mediaShareView mediaStop];
                [self.mediaShareView removeFromSuperview];
                self.mediaShareView = nil;
            }
            
        }
            break;
        case 1:
        {
            if (![self.mediaShareView.videoUrlStr isEqualToString: mediaShareModel.url] || self.mediaShareView == nil) {
                self.mediaShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame))];
                [_bottomView addSubview:_mediaShareView];
                self.mediaShareView.delegate = self;
                self.mediaShareView.slider.hidden = NO;
                self.mediaShareView.startEndMark.hidden = NO;
                self.mediaShareView.tag = mediaShareModel.itemIdx;
                
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
    if (self.musicShareView != nil){
        self.musicShareView.seekTempTime = time;
    }
    
}
- (void)mediaShareDelete:(NSDictionary *)dic{
    if (self.mediaShareView.tag == [dic[@"itemIdx"] intValue]) {
        [self.mediaShareView destoryAVPlayer];
        [self.mediaShareView removeFromSuperview];
        self.mediaShareView = nil;
    }
}
#pragma mark - 推流 ---照片选择
- (void)sheetSeletedIndex:(NSInteger)index title:(NSString *)title actionSheetTag:(NSInteger)tag{
    
    switch (tag) {
        case 2001:
        {
           
           
        }
            break;
        case 2002:
        {
            switch (index) {
                case 0:
                {
                    XDY_PictureListVC  * vc = [XDY_PictureListVC new];
                    vc.delegate = self;
                    vc.picDelegate = self;
                    vc.maxChoiceImageNumberumber = 1;
                    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
                }
                    break;
                case 1://从相机中选择
                {
                    XDY_CameraVC * cameraVc = [XDY_CameraVC new];
                    cameraVc.delegate = self;
                    [self presentViewController:cameraVc animated:YES completion:nil];
                }
                    
                    break;;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - XDY_ChoicePictureVCDelegate图片上传
- (void)XDYChoicePictureVC:(XDY_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    [XDYLoadingHUD hiddenLoadingAnimation];
    
    UIImage *image = photoArr.firstObject;
    
    NSString *data = [XDYCurrentTime getTimeInterval];
    
    
    [[XDYClient sharedClient]sendChatPictrueMsg:[image fixOrientation] DOCServerIP:_joinSuccessModel.DOCServerIP siteId:_joinSuccessModel.siteId timestamp:data classId:self.classId Success:^(id response) {
        
        NSString *dateString = [XDYCurrentTime getChatTime];
        [self addMessageWithContent:@"" time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:image msgType:1 isSuccess:true];
        
    } Failer:^(id type, id error) {
       
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }];
}

- (void)XDYPictureCancel{
    [self hiddenHub];
    
}

- (void)XDYCameraCancel{
    [self hiddenHub];
    
}
- (void)hiddenHub{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        
        [XDYLoadingHUD hiddenLoadingAnimation];
    });

}
#pragma mark - XDY_CameraVCDelegate
- (void)XDYCameraVC:(XDY_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    
    [self XDYChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
    
}

#pragma mark - 文档聊天详情切换
-(void)getTag:(NSInteger)tag{
    switch (tag) {
        case 0://文档
        {
            if ([_fileType isEqualToString:@"zip"]) {
                _htmlDocView.hidden = NO;
            }
                
            _toolbar.hidden = YES;
            _chatTableView.hidden = YES;
            [self.view endEditing:YES];
            if (_questionnaireView != nil) {
                self.questionnaireView.hidden = NO;
            }
            
            self.memberTableView.hidden = YES;
            _isMember = false;
        }
            break;
        case 1://聊天
        {
            _toolbar.hidden = NO;
            _chatTableView.hidden = NO;
            self.memberTableView.hidden = YES;
            _isMember = false;
            [self.bottomView bringSubviewToFront:_chatTableView];
            [self.bottomView bringSubviewToFront:_toolbar];
            
            [_chatTableView reloadData];
            if (_allMessagesFrame.count == 0) {
                return;
            }
            // 3、滚动至当前行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1  inSection:0];
            [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
            break;
        case 2://成员
        {
            _toolbar.hidden = YES;
            _chatTableView.hidden = YES;
            [self.view endEditing:YES];
            _isMember = true;
            _memberTableView.hidden = NO;
            [self.memberTableView reloadData];
           
            
            [self.bottomView bringSubviewToFront:_memberTableView];
        }
            break;
        case 3://撤销绘制
        {
            [[XDYClient sharedClient] api:@"sendGotoPrev" message:nil];
        }
            break;
            
        default:
            
            break;
            
    }
}
- (void)isHand:(BOOL)hand{
    if (hand) {
        
        NSNumber *isHandUp = [NSNumber numberWithBool:true];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:isHandUp,@"isHandUp",nil];
        [[XDYClient sharedClient] api:@"changeHandUpStatus" message:dic];
        
    }else{
        NSNumber *isHandUp = [NSNumber numberWithBool:false];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:isHandUp,@"isHandUp",nil];
        [[XDYClient sharedClient] api:@"changeHandUpStatus" message:dic];
    }
    
}
-(void)isBrush:(BOOL)brush{
    if (brush) {
        
        _docView.scrollView.scrollEnabled = NO;
        [_docView.drawView openDrawlineWidth:2];
        [_htmlDocView.drawView openDrawlineWidth:2];
        
    }else{
        
        _docView.scrollView.scrollEnabled = YES;
        [_docView.drawView closeDraw];
        [_htmlDocView.drawView closeDraw];
        
    }
}


#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time type:(MessageType )type icon:(NSString *)icon name:(NSString *)name imgURL:(UIImage *)imgURL msgType:(int)msgType isSuccess:(BOOL)isSuccess{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    MessageInfo *msg = [[MessageInfo alloc] init];
    
    mf.showTime = ![self.previousTime isEqualToString:time];
    msg.content = content;
    msg.time = time;
    msg.icon = icon;
    msg.type = type;
    msg.userName = name;
    msg.imgUrl = imgURL;
    msg.msgType = msgType;
    mf.messageInfo = msg;
    self.previousTime = time;
    [_allMessagesFrame addObject:mf];
    
    
     if (!_isMember) {
         [self.chatTableView reloadData];
    // 3、滚动至当前行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1  inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     }
}


- (void)loadmemberTableView{
    
    //TableView的创建
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XDY_WIDTH, CGRectGetHeight(self.bottomView.frame)) style:UITableViewStylePlain];
    self.memberTableView.tag = 1001;
    self.memberTableView.backgroundColor = [UIColor redColor];
    
    self.memberTableView.dataSource =self;
    self.memberTableView.delegate = self;
    self.memberTableView.tableFooterView = [[UIView alloc]init];
    self.memberTableView.backgroundColor = kUIColorFromRGB(0xffffff);
    //注册cell
    [self.memberTableView registerNib:[UINib nibWithNibName:@"XDYMemberCell" bundle:nil] forCellReuseIdentifier:@"XDYMemberCell"];
    
    self.memberTableView.tableFooterView = [[UIView alloc] init];
    self.memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomView addSubview:self.memberTableView];
    self.memberTableView.hidden = YES;
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, 30)];
    headView.backgroundColor = kUIColorFromRGB(0xffffff);
    _totalNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, XDY_WIDTH-10, 30)];
    _totalNum.font = [UIFont systemFontOfSize:14];
    _totalNum.textColor = [UIColor grayColor];
    
    _totalNum.text = @"在线人数:0";
    [headView addSubview:_totalNum];
    self.memberTableView.tableHeaderView = headView;
    
}

#pragma mark -添加tableView
- (void)loadTableView{
    
    self.chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, CGRectGetHeight(self.bottomView.frame)-49) style:UITableViewStylePlain];
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.tag = 1002;
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.backgroundColor = kUIColorFromRGB(0xebebeb);
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self.bottomView addSubview:self.chatTableView];
    self.chatTableView.hidden = YES;
    
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
    toolbar.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    toolbar.delegate = self;
    toolbar.height = 49;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xd1d1d1);
    [toolbar addSubview:lineView];
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.x = 0;
    toolbar.width = XDY_WIDTH;
    toolbar.y = CGRectGetHeight(_bottomView.frame)-49;
    
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
    textView.frame = CGRectMake(38*2+2, 7, CGRectGetWidth(self.toolbar.frame)-38*3-4, 36);
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
    
    _menuView.userInteractionEnabled = YES;
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
        self.questionnaireView.transform = CGAffineTransformIdentity;
    }];
}
/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    
    _menuView.userInteractionEnabled = NO;
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        
        self.keyboardHeight = keyboardF.size.height;
        if ([self.textView isFirstResponder]) {
            self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        }else{
            self.questionnaireView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        }
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
//    self.textView.inputView = nil;
//    [textView becomeFirstResponder];
    
}

#pragma mark - 消息发送
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        if ((![self.textView.text isEqualToString:@""]) && (![XDYCommonTool isEmpty:self.textView.text])) {
            [textView resignFirstResponder];
            self.textView.inputView = nil;
            self.toolbar.showEmotionButton = NO;
            // 1、增加数据源
            NSString *con = [NSString stringWithFormat:@"%@",self.textView.realText];
            
            NSString *content = [NSStringLimit stringConver:con];//替换字符
            [self chatMessage:content msgType:0];
            NSString *dateString = [XDYCurrentTime getChatTime];
            
            
            [self addMessageWithContent:content time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:nil msgType:0 isSuccess:false];
                        
            // 4、清空文本框内容
            textView.text = nil;
        
        }
        return NO;
    }
    return YES;
}

#pragma mark - 聊天发送
- (void)chatMessage:(NSString *)message msgType:(int)msgType{
    NSNumber *type = [NSNumber numberWithInt:msgType];
    
    //发送聊天消息
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"to",message,@"message",type,@"msgType",nil];
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
        case HMComposeToolbarButtonTypePictrue: // 表情
            [self openPictrue];
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
    if ( self.toolbar.showEmotionButton) {
        // 当前显示的是自定义键盘，切换为系统自带的键盘
        self.textView.inputView = nil;
        // 显示表情图片
        self.toolbar.showEmotionButton = NO;
    } else
    {
        // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        self.textView.inputView = self.kerboard;
        // 不显示表情图片
        self.toolbar.showEmotionButton = YES;
    }
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
#pragma mark - 图片选择
- (void)openPictrue{
    [self.textView resignFirstResponder];
    
    //使用方法
    NSArray * arr = @[NSLocalizedString(@"打开相册",@""),NSLocalizedString(@"打开相机",@"")];
    XDYActionSheet * actionSheet = [[XDYActionSheet alloc] initWithFrame:CGRectZero object:self titleArray:arr rowHeight:50 setTableTag:2002];
    
    actionSheet.titleColor = [UIColor blackColor];
    actionSheet.titleFont = [UIFont systemFontOfSize:14];
    actionSheet.delegate = self;
    [self.view addSubview:actionSheet];
}

#pragma mark - 消息发送
- (void)sendChatMessage
{
    if ((![self.textView.text isEqualToString:@""]) && (![XDYCommonTool isEmpty:self.textView.text])) {
      
        [self.textView resignFirstResponder];
        
        self.toolbar.showEmotionButton = NO;
        self.textView.inputView = nil;
        // 1、增加数据源
        NSString *con = [NSString stringWithFormat:@"%@",self.textView.realText];
        
        NSString *content = [NSStringLimit stringConver:con];//替换字符
        [self chatMessage:content msgType:0];
        
        NSString *dateString = [XDYCurrentTime getChatTime];
        [self addMessageWithContent:content time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:nil msgType:0 isSuccess:false];
        // 4、清空文本框内容
        self.textView.text = nil;
    }
}

#pragma mark - tableView  Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isMember) {
        return _memberArray.count;
    }else{
        return _allMessagesFrame.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView.tag == 1000) {
        return 60;
    }else if(tableView.tag == 1001){
        return 50;
    }else{
        return [_allMessagesFrame[indexPath.row] cellHeight];
    }
}

#pragma mark - 设置聊天table的cell样式及数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMember) {//用户列表
        
        static NSString *CellIdentifier = @"XDYMemberCell";
        
        XDYMemberCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        XDYMemberModel *memberModel = _memberArray[indexPath.row];
        
        
        [cell setModel:memberModel nodeid:_joinSuccessModel.nodeId];
        
        
        //在线人数
        _totalNum.text = [NSString stringWithFormat:@"在线人数：%lu",(unsigned long)_memberArray.count];
        cell.backgroundColor = kUIColorFromRGB(0xFFFFFF);
        cell.selectedBackgroundView = [[UIView alloc]init];
        
        return cell;
    }else{//聊天内容
        
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 1002) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag == 1002) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XDY_WIDTH, 30)];
        footerView.backgroundColor = kUIColorFromRGB(0xebebeb);
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(XDY_WIDTH/2-50, 5, 100, 20);
        btn.backgroundColor = kUIColorFromRGB(0xb2b2b2);
        btn.layer.cornerRadius = 5;
        [btn setImage:[UIImage imageNamed:@"forbidIcon"] forState:(UIControlStateNormal)];
        [btn setTitle:@"  您已被禁言" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [footerView addSubview:btn];
        _footerView = footerView;
        if (_toolbar.userInteractionEnabled == NO) {
            _footerView.hidden = NO;
        }else{
            _footerView.hidden = YES;
        }
        return footerView;
        
    }else{
        return nil;
    }
    
}
#pragma mark - cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 画笔监听
-(void)XDYDrawrawPath:(NSArray *)array drawColor:(UIColor *)color drawWidth:(CGFloat)drawWidth{
    
    NSNumber *type = [NSNumber numberWithInt:0];
    NSNumber *thickness = [NSNumber numberWithInt:drawWidth];
    //    NSString *color = @"#FF0000";
    
    NSString *rgb = [[[XDYUIColorToRGB alloc]init] changeUIColorToRGB:color];
    
    //发画笔绘制消息
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:type,@"type",array,@"pointGroup",rgb,@"color",thickness,@"thickness",nil];
    
    [[XDYClient sharedClient] api:@"sendInsertAnnotaion" message:param];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    self.textView.inputView = nil;
    self.toolbar.showEmotionButton = NO;
    
}

#pragma mark - 退出课堂
- (void)backBtn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出课堂吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[XDYClient sharedClient]api:@"leaveClass" message:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            [self stopAllVideoPlay];
            
            
            
            if (_musicShareView !=nil) {
                [_musicShareView mediaStop];
                [_musicShareView destoryAVPlayer];
                [_musicShareView removeFromSuperview];
                _musicShareView = nil;
            }
            if (_mediaShareView != nil) {
                [_mediaShareView mediaStop];
                [_mediaShareView destoryAVPlayer];
                [_mediaShareView removeFromSuperview];
                _mediaShareView = nil;
            }
           
            
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];}

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
- (XDYQuestionnaireView *)questionnaireView {
    
    if (!_questionnaireView) {
        _questionnaireView = [[XDYQuestionnaireView alloc] init];
    }
    return _questionnaireView;
    
}


#pragma mark - 在ipad设备下强制横屏，在iphone设备下强制竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation     NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return NO;
}

- (void)AFNetworkingReachabilityDidChang:(NSNotification *)note
{
    
    NSDictionary *usderInfo = note.userInfo;
    AFNetworkReachabilityStatus status = [[usderInfo valueForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self notReachable];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [XDYAlert showBottomWithText:NSLocalizedString(@"您目前使用的是移动数据网络",@"") duration:2];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
        default:
            break;
    }
    
    
}

- (void)notReachable{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"您的设备网络断开状态，请重新进入",@"")preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self stopAllVideoPlay];
            if (_musicShareView !=nil) {
                [_musicShareView mediaStop];
                [_musicShareView destoryAVPlayer];
                [_musicShareView removeFromSuperview];
                _musicShareView = nil;
            }
            if (_mediaShareView != nil) {
                [_mediaShareView mediaStop];
                [_mediaShareView destoryAVPlayer];
                [_mediaShareView removeFromSuperview];
                _mediaShareView = nil;
            }
            
        }];
        
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


//不管何时,只要有通知中心的出现,在dealloc的方法中都要移除所有观察者.
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
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
