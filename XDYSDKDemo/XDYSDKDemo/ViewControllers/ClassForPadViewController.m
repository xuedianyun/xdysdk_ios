//
//  ClassForPadViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ClassForPadViewController.h"
#import "XDYSDK.h"
#import "VideoModel.h"
#import "XDYAlertView.h"
//聊天输入工具条
#import "XDYToolBar.h"
//聊天内容显示
#import "MessageFrame.h"
#import "MessageCell.h"
#import "MessageInfo.h"
#import "XDYQuestionnaireView.h"

#import "XDYPlayView.h"
#import "XDYPublishView.h"
#import "NavigationView.h"

@interface ClassForPadViewController ()
<UITableViewDelegate,UITableViewDataSource,HMComposeToolbarDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,XDYDrawViewDelegate,popActionSheetDelegate,XDY_CameraVCDelegate,XDY_PhotoListCellDelegate,XDY_ChoicePictureVCDelegate,XDY_ChoicePictureListVCDelegate,XDYAVPlayerViewDelegate>
{
    NSInteger curImage;
    UIImage* images[3];
    NSMutableArray  *_allMessagesFrame;
    NSMutableArray  *_memberArray;
    UIView *_footerView;
}

@property (nonatomic, strong) NavigationView                 *backButton;//自定义导航条
@property (nonatomic, assign) float                          height;
@property (nonatomic, assign) float                          width;
@property (nonatomic, assign) CGFloat leftHeight;
@property (nonatomic, assign) CGFloat leftWidth;
@property (nonatomic, strong) UIImageView                    *leftView;
@property (nonatomic, strong) UIView                         *rightView;
@property (nonatomic, strong) UIView                         *docToolView;
@property (nonatomic, strong) XDYDocToolView                 *toolView;
@property (nonatomic, strong) UILabel                        *docToolLable;
@property (nonatomic, strong) UIButton                       *handUpBtn;
@property (nonatomic, assign) BOOL                           showHandUp;
@property (nonatomic, strong) XDYPlayView                    *videoView;//播放视图
@property (nonatomic, strong) XDYPublishView                 *publishView;//推流视图
@property (nonatomic, strong) XDYPlayView                    *student2;
@property (nonatomic, strong) XDYPlayView                    *student3;
@property (nonatomic, strong) XDYPlayView                    *student4;
@property (nonatomic, strong) NSMutableArray                 *videoArray;//存储播放视图及相关信息
@property (nonatomic, strong) NSMutableArray                 *publishArray;//存储推流视图及相关信息
@property (nonatomic, assign) int                            mediaId;//视频唯一标识
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
@property (nonatomic, assign) BOOL                           audioFlag;
@property (nonatomic, strong) DocForPadView                  *docView;//文档模块
@property (nonatomic, strong) NSMutableArray                 *pointArray;//标注pointArray
@property (nonatomic, strong) XDYHtmlDocView                 *htmlDocView;//动态ppt
@property (nonatomic, strong) XDYDocModel                    *docModel;//文档消息
@property (nonatomic, strong) XDYQuestionnaireView           *questionnaireView;//答题卡
@property (nonatomic, strong) NSString                       *success;
@property (nonatomic, assign) int                            questionItemIdx;
@property (nonatomic, assign) BOOL                           callfire;
@property (nonatomic, assign) BOOL                           questionfire;
@property (nonatomic, strong) UIView                         *screenShareView;//屏幕共享
@property (nonatomic, strong) NSDictionary                   *screenDic;//屏幕共享数据
@property (nonatomic, strong) XDYAVPlayerView                *mediaShareView;//媒体共享
@property (nonatomic, strong) XDYAVPlayerView                *musicShareView;//伴音
@property (nonatomic, strong) NSDictionary                   *signDic;
@property (nonatomic, strong) NSDictionary                   *questionDic;

@property (nonatomic, assign) BOOL                           isMember;//判断是否是成员列表
@property (nonatomic, strong) UITableView                    *memberTableView;//成员表
@property (nonatomic, strong) UILabel                        *memberLabel;//成员
@property (nonatomic, strong) UIButton                       *memberBtn;
@property (nonatomic, strong) UIButton                       *memberBack;

@end

@implementation ClassForPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XDYClient *xdyClient = [XDYClient sharedClient];//创建xdy客户端
    [xdyClient initXDY];//初始化学点云
    [self initVariable];//初始化所有变量
    [self loadData];//数据加载
    [self loadNotification];//通知消息监听

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 2; // 单击
    [self.view addGestureRecognizer:singleTap];
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap.delegate = self;
    
}

- (void)initVariable{
    
    self.view.backgroundColor = kUIColorFromRGB(0xebebeb);
    _audioFlag = false;
    _videoArray = [NSMutableArray array];
    _publishArray = [NSMutableArray array];
    _allMessagesFrame = [NSMutableArray array];
    _memberArray = [NSMutableArray array];
    _screenDic = [NSMutableDictionary dictionary];
    _signDic = [NSDictionary dictionary];
    _questionDic = [NSDictionary dictionary];
    _pointArray = [NSMutableArray array];
    _docModel = [[XDYDocModel alloc]init];
    _itemIdx = -1;
    _questionItemIdx = -1;
    _docModel.htmlDocUrl = @"";
    _docModel.animationStep = 1;
    _docModel.curPageNo = 1;
    _docModel.isFirstStep = true;
    _callfire = false;
    _questionfire = false;
    _success = 0;
    _isMember = false;
    if (XDY_WIDTH > XDY_HEIGHT) {
        _height = XDY_HEIGHT;
        _width = XDY_WIDTH;
    }else{
        
        _height = XDY_WIDTH;
        _width = XDY_HEIGHT;
    }

    //nav导航条
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XDY_HEIGHT, 64)];
    [self.view addSubview:backView];
    NavigationView *navView = [[[NSBundle mainBundle]loadNibNamed:@"NavigationView" owner:self options:nil]lastObject];
    navView.frame = CGRectMake(0, 10, XDY_HEIGHT, 64);
    [backView addSubview:navView];
    self.backButton = navView;
    
    navView.blockBack = ^{//返回登录页面
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出课堂吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
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
            if (_screenShareView != nil) {
                
                [[XDYClient sharedClient]api:@"screen_share_stop" message:_screenDic];
                [_screenShareView removeFromSuperview];
                _screenShareView = nil;
            }
            
            [[XDYClient sharedClient] RTCApi:@"destoryAudioAndVideo" message:nil];
            [[XDYClient sharedClient]api:@"leaveClass" message:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
}

- (void)loadData{
    
    
    //接收所有课堂消息
    [[XDYClient sharedClient] getMessageXDYBlock:^(id type, id message) {
        
        XDYClassEventType index = (int)[[self returnTypeArray] indexOfObject:type];
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            switch (index) {
                case XDYClassEventTypeInit://init
                
                    [self initXDYClass:message];
                
                    break;
                case XDYClassEventTypeInitSuccess://class_init_success
                    
                    [self initSuceess:message];
                    
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
                {
                    [self classUpdateRoster:message];
                    
                }
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
                {
                }
                    break;
                case XDYClassEventTypeScreenShareStop://screen_share_stop
                {
                }
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
                case XDYClassEventTypeMusicSharedUpdate:// @"music_shared_update",//伴音
                {
                    [self loadMusicShare:message];
                    
                    
                }
                    break;
                case XDYClassEventTypeMusicShredDelete://@"music_shared_delete",
                {
                    [self musicShareDelete:message];
                    
                }
                    break;
                case XDYClassEventTypeChatReceiveMessage://chat_receive_message
                {
                    [self chatReceiveMessage:message];
                    
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
                case XDYClassEventTypeWhiteboardAnnotationUpdate://whiteboard_annotation_update  标注
                {
                    [self whiteboardAnnotationUpdate:message];
                    
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
                case XDYClassEventTypeUpadateQuestionTime:
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
    
    [[XDYClient sharedClient]XDYRemoteVideo:^(id type, id message) {
       NSLog(@"type,%@response%@",type,message);
        
        NSArray *typeArray = [NSArray arrayWithObjects:@"Decoded",@"Frame",@"Offline",@"Muted", nil];
        int index = (int)[typeArray indexOfObject:type];
        

        switch (index) {
            case 0://视频编码开始
            {
                [self playVideo:message];
                
               
            }
                break;
            case 1:
                
                break;
            case 2://用户离线
            {
                [_videoView showLayer];
            }
                break;
            case 3://推流停止推流
            {
                [self stopVideo:message];
                
                
            }
                break;
            default:
                break;
        }
        
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        if (![_success isEqualToString:@"1"]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [XDYAlert showBottomWithText:NSLocalizedString(@"加载课堂失败，请重新进入",@"")];
            }];
        }
    });
}
- (void)playVideo:(id)message{
    
    
    
    NSNumber *uid = message[@"uid"];
    
    for (XDYMemberModel *model in _memberArray) {
        if (model.nodeId  == [uid intValue] && [model.userRole isEqualToString:@"host"]) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_videoView.playView,@"playView",uid,@"uid", nil];
            [[XDYClient sharedClient]RTCApi:@"playVideo" message:dic];
            [_videoView hiddenLayer];
            _videoView.uid = [uid intValue];
            
        }else{
            
            if (!_student2.isPlaying) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_student2.playView,@"playView",uid,@"uid", nil];
                [[XDYClient sharedClient]RTCApi:@"playVideo" message:dic];
                [_student2 hiddenLayer];
                _student2.uid = [uid intValue];
                
                return;
            }else if(!_student3.isPlaying){
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_student3.playView,@"playView",uid,@"uid", nil];
                [[XDYClient sharedClient]RTCApi:@"playVideo" message:dic];
                [_student3 hiddenLayer];
                _student3.uid = [uid intValue];
                
                
                return;
            }else if (!_student4.isPlaying){
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_student4.playView,@"playView",uid,@"uid", nil];
                [[XDYClient sharedClient]RTCApi:@"playVideo" message:dic];
                [_student4 hiddenLayer];
                _student4.uid = [uid intValue];
                
                return;
            }
        }
    }
}

- (void)stopVideo:(NSDictionary *)message{
    
    NSNumber *uid = message[@"uid"];
    
    BOOL muted = [message[@"muted"] boolValue] ;
    
    for (VideoModel *videoModel in _videoArray) {
        NSLog(@"%d,%d",videoModel.uid,[uid intValue]);
        XDYPlayView *view =(XDYPlayView *)videoModel.playView;
        
        if (view.uid == [uid intValue]) {
            if(muted){
                [(XDYPlayView*)videoModel.playView showLayer];
            }else{
                [(XDYPlayView*)videoModel.playView hiddenLayer];
            }
        }
    }
    
}

- (void)initSuceess:(NSDictionary *)message{

    [self userVerify:[message[@"passwordRequired"] boolValue]];
}

- (void)joinSuccess:(NSDictionary *)message{
    
    NSLog(@"%@",message);
    
    [self joinXDYSuccess:message];
    self.userId = message[@"userId"];
    
    [XDYLoadingHUD hiddenLoadingAnimation];
    [_backButton setTitle:message];
    [self loadAllView];
    
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
    memberModel.isBannedChat = false;
    
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
    
    [self showHandNum];
    
    
    //控制老师视频的显示隐藏
    if ([memberModel.userRole isEqualToString:@"host"]) {
        
        if (memberModel.openCamera == 0) {
            [_videoView showLayer];
        }else{
            [_videoView hiddenLayer];
        }

    }
    
    if (_isMember) {
        [_memberTableView reloadData];
    }
}

- (void)classInsertRoster:(NSDictionary *)message{
    
    NSDictionary *nodeData = message[@"nodeData"];
    XDYMemberModel *memberModel = [[XDYMemberModel alloc]init];
    memberModel.userId = nodeData[@"userId"];
    memberModel.nodeId = [message[@"nodeId"] intValue];
    memberModel.userRole = nodeData[@"userRole"];
    memberModel.name = nodeData[@"name"];
    memberModel.handUpTime = [nodeData[@"handUpTime"] intValue];
    memberModel.openCamera = [nodeData[@"openCamera"] intValue];
    memberModel.openMicrophones = [nodeData[@"openMicrophones"] intValue];
    memberModel.isBannedChat = false;
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
    
    [self showHandNum];
    
    
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
- (void)loadNotification{
    
    
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndBackgroundAction:) name:@"enterBackground" object:nil];
//    //进入前台
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndForegroundAction:) name:@"enterForeground" object:nil];
    //耳机插播监听
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
}
- (void)EndBackgroundAction:(NSNotification *)notification{
    
    [_publishView unpublishVideo];
    [[XDYClient sharedClient] RTCApi:@"unPublishVideo" message:nil];
    
}
#pragma mark - 禁言
- (void)classUpdateStatus:(NSDictionary *)dic{
  
    [_toolView setModel:dic];
    
    
    if ([dic[@"silence"] boolValue]) {
        _textView.placehoder = [NSString stringWithFormat:@"你已经被禁言"];
        _textView.editable = NO;
        
        _toolbar.userInteractionEnabled = NO;
        _footerView.hidden = NO;
    }else{
        
        
        NSDictionary *silenceUsers = dic[@"silenceUsers"];
        
        
        if ([silenceUsers isKindOfClass:[NSNull class]]) {
            return;
        }
        if ( [[silenceUsers allKeys] containsObject:self.userId]) {
            _textView.placehoder = [NSString stringWithFormat:@"你已经被禁言"];
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


- (void)loadQuestionView:message isHoriz:(BOOL)isHoriz{
    
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
        if (answer.height < 30) {
            answer.height = 30;
        }
        
        [heightArray addObject:height];
        [widthArray addObject:width];
        y+=answer.height+5;
    }
    
    NSArray *array = [widthArray sortedArrayUsingComparator:cmptr];
    NSString *max = [array lastObject];
    if ([max intValue]<60) {
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
        int w =(CGRectGetWidth(_leftView.frame)-5-90);
        if ( answerw > w){
            pointx = 0;
            int h = [heightArray[i-1] floatValue];
            if (h < 30) {
                h = 30;
            }
            pointY += h;
        }
        pointx += [widthArray[i] integerValue]+40;
        
    }
    
    if (isHoriz) {
        self.questionnaireView.frame = CGRectMake(0,CGRectGetHeight(_leftView.frame)-height-37,CGRectGetWidth(_leftView.frame)-5, height);
    }else{
        
        self.questionnaireView.frame = CGRectMake(0, CGRectGetHeight(_leftView.frame)-pointY-20-37-40, CGRectGetWidth(_leftView.frame)-5, pointY+20+40);
    }
    

    [self.leftView addSubview:self.questionnaireView];
    [self.questionnaireView getAnswerXDYBlock:^(NSString *questionId, NSArray *answer) {
        
   
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[_questionDic[@"itemIdx"] intValue]],@"itemIdx",[NSNumber numberWithInt:[_questionDic[@"questionId"] intValue]],@"questionId",answer,@"answer", nil];
        [[XDYClient sharedClient]api:@"sendAnswer" message:dic];
        
    }];
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


- (void)showHandNum{
    int handUpNum = 0;
    
    for (XDYMemberModel *model in _memberArray) {
        if (model.handUpTime != 0) {
            handUpNum ++;
        }else{
            if (model.nodeId == _joinSuccessModel.nodeId) {//教师端控制学生取消举手
                self.showHandUp = NO;
                [_handUpBtn setImage:[UIImage imageNamed:@"hand-normal"] forState:(UIControlStateNormal)];
            }
        }
    }
    
    if (handUpNum > 0) {
        [_memberBtn setTitle:[NSString stringWithFormat:@"(%d)",handUpNum] forState:(UIControlStateNormal)];
    }else{
        [_memberBtn setTitle:[NSString stringWithFormat:@""] forState:(UIControlStateNormal)];
    }
    if (_isMember) {
        _memberLabel.text = [NSString stringWithFormat:@"成员列表(%lu)",(unsigned long)_memberArray.count];
    }
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    self.toolbar.showEmotionButton = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)loadAllView{
    
    if (isPad) {
        _leftHeight =  _height-64;
    }
    
    self.leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, _width/4*3, _leftHeight-10)];
    _leftWidth = _width/4*3;
    
    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftView.userInteractionEnabled = YES;
    [self.view addSubview:self.leftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(_width/4*3, 64, _width/4, _leftHeight)];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rightView];

    _videoView = [[[NSBundle mainBundle] loadNibNamed:@"XDYPlayView" owner:nil options:nil] lastObject];
    _videoView.frame = CGRectMake(2.5, 10, CGRectGetWidth(_rightView.frame)-2.5,( (CGRectGetWidth(_rightView.frame))/4.0*3));
    
    
    [self.rightView addSubview:_videoView];
    
    float stuSpace = 2.5;
    
    if (_joinSuccessModel.classType != 2 && _joinSuccessModel.maxChannels != 1) {
        _publishView = [[[NSBundle mainBundle] loadNibNamed:@"XDYPublishView" owner:nil options:nil] lastObject];
        
        
        if (_joinSuccessModel.maxChannels > 2) {
            
            [_publishView hiddenCamera:YES isMax:YES];
            
            _publishView.frame = CGRectMake(stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace, (CGRectGetWidth(_rightView.frame)-5)/2,( ((CGRectGetWidth(_rightView.frame)-5)/2)/4.0*3));
            
        }else if(_joinSuccessModel.maxChannels == 2){
            
            if (_joinSuccessModel.classType == 3) {
                
                [_publishView hiddenCamera:YES isMax:NO];
            }else{
                
                [_publishView hiddenCamera:NO isMax:NO];
            }
            
            _publishView.frame = CGRectMake(stuSpace, CGRectGetMaxY(_videoView.frame)+stuSpace, CGRectGetWidth(_rightView.frame)-stuSpace,( (CGRectGetWidth(_rightView.frame))/4.0*3));
        }
        
        [self.rightView addSubview:_publishView];

        
        _publishView.publishBlock = ^{
            
            [[XDYClient sharedClient] RTCApi:@"publishVideo" message:nil];
            
            
        };
        _publishView.unPublishBlock = ^{
            
            [[XDYClient sharedClient] RTCApi:@"unPublishVideo" message:nil];
           
        };
        
        [self applyMicOrCamera];
    
    }
    if (_joinSuccessModel.maxChannels == 3) {
        
        _student2 = [[[NSBundle mainBundle] loadNibNamed:@"XDYPlayView" owner:nil options:nil] lastObject];
        _student2.frame = CGRectMake(CGRectGetMaxX(_publishView.frame)+stuSpace, CGRectGetMinY(_publishView.frame), CGRectGetWidth(_publishView.frame), CGRectGetHeight(_publishView.frame));
        [self.rightView addSubview:_student2];
        [_student2 isStudent];
        
        [self addVideoModel:_student2];
        
        
    }else if(_joinSuccessModel.maxChannels == 5){
        
        _student2 = [[[NSBundle mainBundle] loadNibNamed:@"XDYPlayView" owner:nil options:nil] lastObject];
        _student2.frame = CGRectMake(CGRectGetMaxX(_publishView.frame)+stuSpace, CGRectGetMinY(_publishView.frame), CGRectGetWidth(_publishView.frame), CGRectGetHeight(_publishView.frame));
        [self.rightView addSubview:_student2];
        [_student2 isStudent];
        
        [self addVideoModel:_student2];
        
        _student3 = [[[NSBundle mainBundle] loadNibNamed:@"XDYPlayView" owner:nil options:nil] lastObject];
        _student3.frame = CGRectMake(stuSpace, CGRectGetMaxY(_publishView.frame)+stuSpace, CGRectGetWidth(_publishView.frame), CGRectGetHeight(_publishView.frame));
        [self.rightView addSubview:_student3];
        [_student3 isStudent];
        
        [self addVideoModel:_student3];
        
        _student4 = [[[NSBundle mainBundle] loadNibNamed:@"XDYPlayView" owner:nil options:nil] lastObject];
        _student4.frame = CGRectMake(CGRectGetMaxX(_publishView.frame)+stuSpace, CGRectGetMaxY(_publishView.frame)+stuSpace, CGRectGetWidth(_publishView.frame), CGRectGetHeight(_publishView.frame));
        [self.rightView addSubview:_student4];
         [_student4 isStudent];
        
        [self addVideoModel:_student4];
    }

    
    _docView = [[DocForPadView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
    _docView.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:_docView];
    [self.leftView sendSubviewToBack:_docView];
    
    _docView.userInteractionEnabled = YES;
    _docView.drawView.delegate = self;

    UIView *docToolView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_docView.frame), CGRectGetMaxY(_docView.frame), CGRectGetWidth(_docView.frame), 49)];
    docToolView.backgroundColor = kUIColorFromRGB(0xe3e4e6);
    [self.leftView addSubview:docToolView];
    self.docToolView = docToolView;
    
    //举手工具
    if (![self.userRole isEqualToString:@"invisible"]) {
        if (_joinSuccessModel.classType == 1) {
            [self loadDocToolView];
        }else{
            UIButton *handUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [handUpBtn setImage:[UIImage imageNamed:@"hand-normal"] forState:(UIControlStateNormal)];
            handUpBtn.frame = CGRectMake(10, 0, 40, 49);
            [docToolView addSubview:handUpBtn];
            [handUpBtn addTarget:self action:@selector(handUpBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            self.showHandUp = NO;
            _handUpBtn = handUpBtn;
            
        }

    }
    
    
    UILabel *docToolLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(docToolView.frame)-150, 0, 140, 49)];
    docToolLable.backgroundColor = kUIColorFromRGB(0xe3e4e6);
    docToolLable.textAlignment = NSTextAlignmentRight;
    docToolLable.textColor = kUIColorFromRGB(0x333333);
    
    [docToolView addSubview:docToolLable];
    self.docToolLable = docToolLable;
    
    
    
    //聊天视图
    [self loadTableView];
    
    if (_joinSuccessModel.classType != 1) {
        [self loadMemberView];
    }

   
    // 添加输入工具条
    [self setupToolbar];
    // 添加输入控件
    [self setupTextView];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_publishView.publishView,@"publishView", nil];
    [[XDYClient sharedClient]RTCApi:@"initAudioAndVideo" message:dic];
}

- (void)addVideoModel:(XDYPlayView *)view{
    
    VideoModel *model = [[VideoModel alloc]init];
    model.playView = view;
    [_videoArray addObject:model];
    
}

- (void)loadDocToolView{
    
    XDYDocToolView *toolView = [[XDYDocToolView alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_docView.frame)-55, 49) afterSelectColor:^(UIColor *color) {
        //给绘图视图设置颜色
        [_docView.drawView setDrawColor:color];
        [_htmlDocView.drawView setDrawColor:color];
        
    } afterSelectbrush:^(BOOL flag) {
        
        if (flag) {
            _docView.scrollView.scrollEnabled = NO;
            [_docView.drawView openDrawlineWidth:2];
            
            [_htmlDocView.drawView openDrawlineWidth:2];
            
            
        }else{
            
            _docView.scrollView.scrollEnabled = YES;
            [_docView.drawView closeDraw];
            [_htmlDocView.drawView closeDraw];
            
            
        }
        
    } afterSelectUndo:^(BOOL flag) {
        if (flag) {
            
            [[XDYClient sharedClient] api:@"sendGotoPrev" message:nil];
        }
    } afterSelectPage:^(BOOL flag) {
        
    }];
    
    _toolView = toolView;
    
    [self.docToolView addSubview:toolView];
}
#pragma mark -用户列表
- (void)loadMemberView{
    
    UIView *memberTool = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_chatTableView.frame), CGRectGetMinY(_chatTableView.frame)-40, CGRectGetWidth(_chatTableView.frame), 40)];
    
    memberTool.backgroundColor = kUIColorFromRGB(0xe3e4e6);
    [self.rightView addSubview:memberTool];
    UILabel *memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_chatTableView.frame), 40)];
    memberLabel.text = @"聊天";
    memberLabel.textAlignment = NSTextAlignmentCenter;
    memberLabel.textColor = kUIColorFromRGB(0x8c8c8c);
    memberLabel.backgroundColor = [UIColor clearColor];
    [memberTool addSubview:memberLabel];
    _memberLabel = memberLabel;
    
    UIButton *memberBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [memberBtn setImage:[UIImage imageNamed:@"member-icon"] forState:UIControlStateNormal];
    [memberBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    memberBtn.frame = CGRectMake(CGRectGetWidth(memberTool.frame)-60, 0, 60, 40);
    memberBtn.backgroundColor  = [UIColor clearColor];
    [memberTool addSubview:memberBtn];
    memberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _memberBtn = memberBtn;
    
    [memberBtn addTarget:self action:@selector(memberBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self loadmemberTableView];
    
    
    UIButton *memberBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [memberBack setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    memberBack.frame = CGRectMake(0, 0, 40, 40);
    [memberTool addSubview:memberBack];
    memberBack.hidden = YES;
    [memberBack addTarget:self action:@selector(memberBackClick) forControlEvents:(UIControlEventTouchUpInside)];
    _memberBack = memberBack;
    
}
- (void)memberBtnClick{
    _isMember = true;
    self.toolbar.hidden = YES;
    self.memberTableView.hidden = NO;
    [self.memberTableView reloadData];
    _memberBack.hidden = NO;
    _memberLabel.text = @"成员列表";
    _memberBtn.hidden = YES;
    
}
- (void)memberBackClick{
    _memberLabel.text = @"聊天";
    _memberBtn.hidden = NO;
    _isMember = false;
    self.toolbar.hidden = NO;
    _memberBack.hidden = YES;
    self.memberTableView.hidden = YES;
    [self.chatTableView reloadData];
    if (_allMessagesFrame.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1  inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (void)loadmemberTableView{
    
    //TableView的创建
    self.memberTableView = [[UITableView alloc] init];
    self.memberTableView.tag = 1001;
    
    
    switch (_joinSuccessModel.maxChannels) {//判断最大路数
        case 0:
            
            break;
        case 1:
            
            self.memberTableView.frame =CGRectMake(2.5, CGRectGetMaxY(_videoView.frame)+45, CGRectGetWidth(_rightView.frame)-2.5, CGRectGetHeight(self.rightView.frame)-40-CGRectGetMaxY(_videoView.frame)-5);
            
            break;
        case 2:
        case 3:
            
            self.memberTableView.frame =CGRectMake(2.5, CGRectGetMaxY(_publishView.frame)+45, CGRectGetWidth(_rightView.frame)-2.5, CGRectGetHeight(self.rightView.frame)-40-CGRectGetMaxY(_publishView.frame)-5);
            
            break;
        case 4:
        case 5:
            
            self.memberTableView.frame =CGRectMake(2.5, CGRectGetMaxY(_student3.frame)+45, CGRectGetWidth(_rightView.frame)-2.5, CGRectGetHeight(self.rightView.frame)-40-CGRectGetMaxY(_student3.frame)-5);
            
            break;
        default:
            break;
    }
    
    self.memberTableView.dataSource =self ;
    self.memberTableView.delegate = self ;
    self.memberTableView.tableFooterView = [[UIView alloc]init];
    self.memberTableView.backgroundColor = kUIColorFromRGB(0xffffff);
    //注册cell
    [self.memberTableView registerNib:[UINib nibWithNibName:@"XDYMemberCell" bundle:nil] forCellReuseIdentifier:@"XDYMemberCell"];
    
    self.memberTableView.tableFooterView = [[UIView alloc] init];
    self.memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightView addSubview:self.memberTableView];
    self.memberTableView.hidden = YES;
    
}

- (void)loadHTMLDocView{
    _htmlDocView = [[XDYHtmlDocView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
    [_htmlDocView loadDOCServerIP:_joinSuccessModel.DOCServerIP];
    [self.leftView addSubview:_htmlDocView];
    [self.leftView sendSubviewToBack:_htmlDocView];
    
    _htmlDocView.drawView.delegate = self;
    [self.htmlDocView getMessageXDYDocBlock:^(id type, id message) {
        
        if ([type isEqualToString:@"success"]) {
            _docModel.docVisible = message;
        }else if([type isEqualToString:@"loadDocSuccess"]&&[message isEqualToString:@"1"]){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                [self.htmlDocView jumpPage:_docModel.curPageNo];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    
                    for (int i = 1; i<_docModel.aniStepFirst; i++) {
                        [self.htmlDocView nextStep];
                    }
                    
                });
                
            });
        }
        
    }];
}
- (void)handUpBtnClick:(UIButton *)button{
    if (self.showHandUp) {
        self.showHandUp = NO;
        [_handUpBtn setImage:[UIImage imageNamed:@"hand-normal"] forState:(UIControlStateNormal)];
        NSNumber *isHandUp = [NSNumber numberWithBool:false];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:isHandUp,@"isHandUp",nil];
        [[XDYClient sharedClient] api:@"changeHandUpStatus" message:dic];
        
    }else{
        self.showHandUp = YES;
        [_handUpBtn setImage:[UIImage imageNamed:@"hand-press"] forState:(UIControlStateNormal)];
        
        NSNumber *isHandUp = [NSNumber numberWithBool:true];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:isHandUp,@"isHandUp",nil];
        [[XDYClient sharedClient] api:@"changeHandUpStatus" message:dic];
    }
}

- (void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   [XDYLoadingHUD showLoadingAnimationForView:self.view withStatus:@""];
}

#pragma mark - 初始化课堂
- (void)initXDYClass:(NSDictionary *)message{
    _success = message[@"success"];
    
    [self initXDY:message];
}
- (void)showError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"密码输入错误，请重新输入!",@"")preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self userVerify:true];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 加入课堂
- (void)userVerify:(BOOL)flag{
    
    
    [XDYLoadingHUD hiddenLoadingAnimation];
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
    
    
    
}
- (void)stopAllVideoPlay{
    
    
    [[XDYClient sharedClient] RTCApi:@"destoryAudioAndVideo" message:nil];
//    for (VideoModel *model in _videoArray) {
//    
//        NSNumber *media = [NSNumber numberWithInt:model.mediaId];
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:media,@"mediaId",nil];
//        
//        [[XDYClient sharedClient]api:@"unplayVideo" message:dic];
//        
//        [model.view removeFromSuperview];
//    }
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

- (void)chatReceiveMessage:(NSDictionary *)message{
    NSString *dateString = [XDYCurrentTime getChatTime];
    if ([message[@"fromNodeId"] intValue] != _joinSuccessModel.nodeId) {//不是自己发送消息
        
        if ([message[@"fromRole"] isEqualToString:@"host"]) {
            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeTeacher icon:@"XueDianYunSDK.bundle/ClassRoomTeacherIcon" name:message[@"fromName"] imgURL:nil msgType:[message[@"msgType"] intValue]];
        }else{
            [self addMessageWithContent:message[@"message"] time:dateString type:MessageTypeOther icon:@"ClassRoomStudentIcon" name:message[@"fromName"] imgURL:nil msgType:[message[@"msgType"] intValue]];
        }
    }
}
- (void)documentUpdate:(NSDictionary *)message{
    if ([message[@"visible"] intValue] == 1){
        
        _itemIdx = [message[@"itemIdx"] intValue];
        _fileType = message[@"fileType"];
        _docToolLable.text = [NSString stringWithFormat:@"%d /%d页    ",[message[@"curPageNo"] intValue],[message[@"pageNum"] intValue]];
        
        if ([message[@"fileType"] isEqualToString:@"zip"]) {
            _docView.hidden = YES;
            NSString *docImageUrl = message[@"html"];
            
            
            if (![docImageUrl isEqualToString:_docModel.htmlDocUrl]) {
                if (_htmlDocView != nil) {
                    [_htmlDocView removeFromSuperview];
                    _htmlDocView = nil;
                    
                }
                [self loadHTMLDocView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    
                    [self.htmlDocView setSrc:docImageUrl];
                    _docModel.htmlDocUrl = docImageUrl;
                    
                });
            }
            int curpage = [message[@"curPageNo"] intValue];
            if (curpage != _docModel.curPageNo) {
                [self.htmlDocView jumpPage:curpage];
                _docModel.animationStep = 1;
                _docModel.curPageNo = curpage;
            }
            
            int animationStep = [message[@"animationStep"] intValue];
            _docModel.aniStepFirst = animationStep;
            
            if (_docModel.isFirstStep) {
                _docModel.isFirstStep = false;
                for (int i = 1; i<animationStep; i++) {
                    [self.htmlDocView nextStep];
                }
              _docModel.animationStep = animationStep;
            }else{
                if (_docModel.animationStep > animationStep) {
                    [self.htmlDocView preStep];
                    
                }else if (_docModel.animationStep <animationStep){
                    [self.htmlDocView nextStep];
                }
                _docModel.animationStep = animationStep;
            }
            
        }else{
            
            _docModel.htmlDocUrl = @"";
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
        _docToolLable.text = @"";
        [_docView setDocFile:@""];
        _htmlDocView.hidden = YES;
    }
}
- (void)whiteboardAnnotationUpdate:(NSDictionary *)message{
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
    
    float x = [dic[@"w"] floatValue]/100.0 * CGRectGetWidth(_docView.frame);
    float y = [dic[@"h"] floatValue]/100.0 * CGRectGetWidth(_docView.frame);
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
            [self loadQuestionView:message isHoriz:true];
            _questionDic = message;
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
        [self.questionnaireView showQuestionTimer:[message[@"timestamp"] intValue]];
        _questionfire = true;
    }
}
- (void)classExit:(NSDictionary *)message{
    [self classExitXDY:message confirm:^(id data) {
        [self stopAllVideoPlay];
        if (_publishView != nil) {
        }
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
        if (_screenShareView != nil) {
            
            [[XDYClient sharedClient]api:@"screen_share_stop" message:_screenDic];
            [_screenShareView removeFromSuperview];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
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
                self.mediaShareView = [[XDYAVPlayerView alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.leftView.frame)-5, CGRectGetHeight(self.leftView.frame)-49)];
                self.mediaShareView.delegate = self;
                [_leftView addSubview:_mediaShareView];
                _mediaShareView.slider.hidden = NO;
                _mediaShareView.startEndMark.hidden = NO;
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
            
            default:
                break;
        }
        
    }
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time type:(MessageType )type icon:(NSString *)icon name:(NSString *)name imgURL:(UIImage *)imgURL msgType:(int)msgType{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    MessageInfo *msg = [[MessageInfo alloc] init];
    mf.showTime = ![self.previousTime isEqualToString:time];
    msg.content = content;
    msg.time = time;
    msg.icon = icon;
    msg.type = type;
    msg.userName = name;
    mf.messageInfo = msg;
    msg.msgType = msgType;
    msg.imgUrl = imgURL;
    
    mf.messageInfo = msg;
    
    self.previousTime = time;
    [_allMessagesFrame addObject:mf];
    
    
    // 3、滚动至当前行
        [self.chatTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count-1  inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  
}


#pragma mark -添加tableView
- (void)loadTableView{
    self.chatTableView = [[UITableView alloc]init];
    float space = 2.5;
    
    switch (_joinSuccessModel.classType) {
        case 0:
            
            
            break;
        case 1://直播
            self.chatTableView.frame = CGRectMake(space, CGRectGetMaxY(_publishView.frame)+5, CGRectGetWidth(_rightView.frame)-space, CGRectGetHeight(self.rightView.frame)-50-CGRectGetMaxY(_publishView.frame)-5);
            break;
        case 2://1v1
            self.chatTableView.frame = CGRectMake(space, CGRectGetMaxY(_videoView.frame)+50, CGRectGetWidth(_rightView.frame)-space, CGRectGetHeight(self.rightView.frame)-50-CGRectGetMaxY(_videoView.frame));
            break;
        case 3://小班课
        {
            switch (_joinSuccessModel.maxChannels) {
                case 0:
                    
                    break;
                case 1:
                     self.chatTableView.frame =CGRectMake(space, CGRectGetMaxY(_videoView.frame)+45, CGRectGetWidth(_rightView.frame)-space, CGRectGetHeight(self.rightView.frame)-90-CGRectGetMaxY(_videoView.frame)-5);
                    break;
                case 2:
                    
                case 3:
                    self.chatTableView.frame =CGRectMake(space, CGRectGetMaxY(_publishView.frame)+45, CGRectGetWidth(_rightView.frame)-space, CGRectGetHeight(self.rightView.frame)-90-CGRectGetMaxY(_publishView.frame)-5);
                    break;
                case 4:
                    
                case 5:
                    self.chatTableView.frame =CGRectMake(space, CGRectGetMaxY(_student3.frame)+45, CGRectGetWidth(_rightView.frame)-space, CGRectGetHeight(self.rightView.frame)-90-CGRectGetMaxY(_student3.frame)-5);
                    break;
                    break;
                default:
                    break;
            }
        
            
        }
            break;
        default:
            break;
    }
 
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.tag = 1002;
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
#pragma mark - 添加工具条
- (void)setupToolbar{
    // 1.创建
    HMComposeToolbar *toolbar = [[HMComposeToolbar alloc] init];
    toolbar.backgroundColor = kUIColorFromRGB(0xe3e4e6);
    toolbar.delegate = self;
    toolbar.height = 49;
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.x = 2.5;
    toolbar.width = CGRectGetWidth(_rightView.frame)-2.5;
    toolbar.y = CGRectGetHeight(_rightView.frame)-49;
    
    [self.rightView addSubview:toolbar];
    
}

#pragma mark - 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    HMEmotionTextView *textView = [[HMEmotionTextView alloc] init];
    textView.returnKeyType = UIReturnKeySend;
    textView.textColor = [UIColor blackColor];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    textView.frame = CGRectMake(38*2+2, 10, CGRectGetWidth(self.toolbar.frame)-38*3-4, 30);
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
        self.questionnaireView.transform = CGAffineTransformIdentity;
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
         if ((![self.textView.text isEqualToString:@""]) &&(![XDYCommonTool isEmpty:self.textView.text])) {
            [textView resignFirstResponder];
            self.toolbar.showEmotionButton = NO;
            // 1、增加数据源
            NSString *con = [NSString stringWithFormat:@"%@",self.textView.realText];
             
            NSString *content = [NSStringLimit stringConver:con];//替换字符
             
            [self chatMessage:content msgType:0];
            
             NSString *dateString = [XDYCurrentTime getChatTime];
             [self addMessageWithContent:content time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:nil msgType:0];
             
            // 4、清空文本框内容
            textView.text = nil;
            
            
         }
        return NO;
    }
    return YES;
}
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
        case HMComposeToolbarButtonTypePictrue: // 相册
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
//    // 显示表情图片
//    self.toolbar.showEmotionButton = YES;
//
//    // 当前显示的是系统自带的键盘，切换为自定义键盘
//    // 如果临时更换了文本框的键盘，一定要重新打开键盘
//    self.textView.inputView = self.kerboard;
//
//    // 关闭键盘
//    [self.textView resignFirstResponder];
//    // 记录是否正在更换键盘
//    // 更换完毕完毕
//    self.changingKeyboard = NO;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 打开键盘
//        [self.textView becomeFirstResponder];
//    });
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
- (void)sheetSeletedIndex:(NSInteger)index title:(NSString *)title actionSheetTag:(NSInteger)tag{
    
    switch (tag) {
      
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
                case 1:
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
#pragma mark - XDY_ChoicePictureVCDelegate
- (void)XDYChoicePictureVC:(XDY_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    
    UIImage *image = photoArr.firstObject;
    if (image) {
        [XDYLoadingHUD hiddenLoadingAnimation];
    }
    
    NSString *data = [XDYCurrentTime getTimeInterval];
    
    
    [[XDYClient sharedClient]sendChatPictrueMsg:[image fixOrientation] DOCServerIP:_joinSuccessModel.DOCServerIP siteId:_joinSuccessModel.siteId timestamp:data classId:self.classId Success:^(id response) {
        
        NSString *dateString = [XDYCurrentTime getChatTime];
       [self addMessageWithContent:@"" time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:image msgType:1];
        
    } Failer:^(id type, id error) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    


}

#pragma mark - XDY_CameraVCDelegate
- (void)XDYCameraVC:(XDY_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    
    [self XDYChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
    
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

#pragma mark - 消息发送
- (void)sendChatMessage
{
    if ((![self.textView.text isEqualToString:@""]) &&(![XDYCommonTool isEmpty:self.textView.text])) {
        
        [self.textView resignFirstResponder];
        self.toolbar.showEmotionButton = NO;
        // 1、增加数据源
        NSString *con = [NSString stringWithFormat:@"%@",self.textView.realText];
        
        NSString *content = [NSStringLimit stringConver:con];//替换字符
        [self chatMessage:content msgType:0];
        
        NSString *dateString = [XDYCurrentTime getChatTime];
        [self addMessageWithContent:content time:dateString type:MessageTypeMe icon:@"ClassRoomStudentIcon" name:_joinSuccessModel.userName imgURL:nil msgType:0];
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
   
    if (_isMember) {
        static NSString *CellIdentifier = @"XDYMemberCell";
        XDYMemberCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        XDYMemberModel *memberModel = _memberArray[indexPath.row];
        
        //头像标志
        switch (memberModel.deviceType) {
            case 0:
                [cell.userRole setImage:[UIImage imageNamed:@"PC"] forState:UIControlStateNormal];
                break;
            case 1:
            case 2:
                
                [cell.userRole setImage:[UIImage imageNamed:@"APP"] forState:UIControlStateNormal];
                break;
            case 3:
                
                [cell.userRole setImage:[UIImage imageNamed:@"H5"] forState:UIControlStateNormal];
                
                break;
                
            default:
                break;
        }
        
        //个人显示用户名为红色
        if (memberModel.nodeId == _joinSuccessModel.nodeId) {
            cell.name.textColor = [UIColor redColor];
            
        }else{
            cell.name.textColor = kUIColorFromRGB(0x333333);
        }
        //音视频标志
        if (memberModel.openCamera != 0) {
            [cell.camera setImage:[UIImage imageNamed:@"camera_press_list"] forState:UIControlStateNormal];
            [cell.mic setImage:[UIImage imageNamed:@"mic-press_list"] forState:UIControlStateNormal];
        }else{
            
            [cell.camera setImage:[UIImage imageNamed:@"camera_normal_list"] forState:UIControlStateNormal];
            [cell.mic setImage:[UIImage imageNamed:@"mic_normal_list"] forState:UIControlStateNormal];
        }
        
        if (memberModel.openMicrophones != 0) {
            [cell.mic setImage:[UIImage imageNamed:@"mic-press_list"] forState:UIControlStateNormal];
        }else{
            [cell.mic setImage:[UIImage imageNamed:@"mic_normal_list"] forState:UIControlStateNormal];
        }
        //禁言标志
        if (memberModel.isBannedChat) {
            [cell.mute setImage:[UIImage imageNamed:@"forbid"] forState:(UIControlStateNormal)];
            
        }else{
            
            [cell.mute setImage:[UIImage imageNamed:@"chat"] forState:(UIControlStateNormal)];
        }
        //用户名称
        cell.name.text = memberModel.name;
        //举手状态标志
        if (memberModel.handUpTime != 0) {
            cell.handUp.hidden = NO;
        }else{
            cell.handUp.hidden = YES;
        }
        
        
        if (_isMember) {
            _memberLabel.text = [NSString stringWithFormat:@"成员列表(%lu)",(unsigned long)_memberArray.count];
            
        }
        
        cell.backgroundColor = kUIColorFromRGB(0xFFFFFF);
        cell.selectedBackgroundView = [[UIView alloc]init];
        
        return cell;
    }else{
        
        
        
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
#pragma mark - cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_chatTableView.frame), 30)];
        footerView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];

        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(CGRectGetWidth(footerView.frame)/2-50, 5, 100, 20);
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.toolbar.showEmotionButton = NO;
    
    [self.view endEditing:YES];
}



#pragma mark - 画笔监听
-(void)XDYDrawrawPath:(NSArray *)array drawColor:(UIColor *)color drawWidth:(CGFloat)drawWidth{
   
    NSNumber *type = [NSNumber numberWithInt:0];
    NSNumber *thickness = [NSNumber numberWithInt:drawWidth];

    NSString *rgb = [[[XDYUIColorToRGB alloc]init] changeUIColorToRGB:color];
    
    //发画笔绘制消息
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:type,@"type",array,@"pointGroup",rgb,@"color",thickness,@"thickness",nil];
    
    [[XDYClient sharedClient] api:@"sendInsertAnnotaion" message:param];
    
}
- (XDYQuestionnaireView *)questionnaireView {
    if (!_questionnaireView) {
        _questionnaireView = [[XDYQuestionnaireView alloc] init];
    }
    return _questionnaireView;
}


#pragma mark - 初始化方法
- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = _width;
        self.kerboard.height = 216;
    }
    return _kerboard;
}

//#pragma mark - 在ipad设备下强制横屏，在iphone设备下强制竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation     NS_AVAILABLE_IOS(6_0)
{
    
    return UIInterfaceOrientationLandscapeLeft;
    
}
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"您的设备网络断开状态，请重新进入",@"") preferredStyle:UIAlertControllerStyleAlert];
    
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
            if (_screenShareView != nil) {
                
                [[XDYClient sharedClient]api:@"screen_share_stop" message:_screenDic];
                [_screenShareView removeFromSuperview];
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
