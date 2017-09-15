//
//  XDYBaseViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/9/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
#import "XDYClient.h"

@interface XDYBaseViewController ()


@end

@implementation XDYBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加网络状态通知子类级所有人
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AFNetworkingReachabilityDidChang:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //音量初始化设置
    if (![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayAndRecord] || !([AVAudioSession sharedInstance].categoryOptions == (AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers))) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
   
    

    // Do any additional setup after loading the view.
}

- (void)initXDY:(NSDictionary *)message{
    
    NSString *success = message[@"success"];
  
    if ([success isEqualToString:@"1"]) {
        NSArray *cameras = [NSArray arrayWithObjects:@"摄像头1", nil];
        NSArray *microphones = [NSArray arrayWithObjects:@"麦克风1", nil];
        // 初始化课堂
        NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.classId,@"classId",self.userRole,@"userRole",self.portal,@"portal",self.userId,@"userId",cameras,@"cameras",microphones,@"microphones",nil];
        [[XDYClient sharedClient] api:@"init" message:dictionary];
    }
}
- (void)joinXDYSuccess:(NSDictionary *)message{
    
    XDYJoinSuccessModel *joinSuccessModel = [[XDYJoinSuccessModel alloc]init];
    joinSuccessModel.classType = [message[@"classType"] intValue];
    NSString *docServer = [NSString stringWithFormat:@"%@:%@",message[@"DOCServerIP"],message[@"DOCServerPort"]];
    joinSuccessModel.DOCServerIP = docServer;
    joinSuccessModel.serverAndLoacTimeDistanc = message[@"serverAndLoacTimeDistanc"];
    joinSuccessModel.siteId = message[@"siteId"];
    int maxVideoChannels = [message[@"maxVideoChannels"] intValue];
    int maxAudioChannels = [message[@"maxAudioChannels"] intValue];
    
    joinSuccessModel.maxChannels = maxVideoChannels>maxAudioChannels?maxVideoChannels:maxAudioChannels;
    joinSuccessModel.userName = message[@"userName"];
    joinSuccessModel.nodeId = [message[@"nodeId"] intValue];
    joinSuccessModel.userId = message[@"userId"];
    _joinSuccessModel = joinSuccessModel;
}


- (void)userXDYVerify:(BOOL)flag
              confirm:(void(^)(id data))confirmMessage
               cancel:(void(^)(id data))cancelMessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"登录",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
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
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *username = alertController.textFields.firstObject;
        UITextField *password = alertController.textFields.lastObject;
        
        NSDictionary *dic;
        if ([username.text isEqualToString:@""]) {
            dic =[NSDictionary dictionaryWithObjectsAndKeys:@0,@"success", nil];
            
        }else{
            //获取txt内容即可
            NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:username.text,@"userName",password.text,@"password",nil];
            
            [[XDYClient sharedClient] api:@"joinClass" message:dictionary];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"success", nil];
        }
        confirmMessage(dic);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cancelMessage(@"取消");
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

    
}

- (void)classExitXDY:(NSDictionary *)message
             confirm:(void(^)(id data))confirmMessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"退出",@"") message:NSLocalizedString(@"课堂已结束",@"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirmMessage(@1);
        
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)erorEventXDY:(NSDictionary *)message
             confirm:(void(^)(id data))confirmMessage{
    if ([message[@"code"] intValue] == 206) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"密码输入错误，请重新输入!",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirmMessage(@1);
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([message[@"code"] intValue] == 20000){
        
    }else if ([message[@"code"] intValue] == 501){
        
    }else if ([message[@"code"] intValue] == 804){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:@"不能再打开更多设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",@"") message:message[@"reson"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
- (NSArray *)returnTypeArray{
    return   [NSArray arrayWithObjects:
                  @"init",
                  @"class_init_success",
                  @"class_join_success",
                  @"class_update_status",
                  @"class_update_roster",
                  @"class_insert_roster",
                  @"class_delete_roster",
                  @"video_play",
                  @"video_stop",
                  @"audio_play",
                  @"audio_stop",
                  @"video_broadcast",
                  @"audio_broadcast",
                  @"media_stop_publish",
                  @"screen_share_play",
                  @"screen_share_stop",
                  @"media_shared_update",
                  @"media_shared_delete",
                  @"music_shared_update",
                  @"music_shared_delete",
                  @"chat_receive_message",
                  @"document_update",
                  @"document_delete",
                  @"whiteboard_annotation_update",
                  @"cursor_update",
                  @"start_answer_question",
                  @"stop_answer_question",
                  @"update_question_time",
                  @"class_exit",
                  @"error_event",
                  nil];
}

- (void)applyMicOrCamera{
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    BOOL micAvailable = true;
    BOOL cameraAvailable = true;
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        micAvailable = true;
        cameraAvailable = true;
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            
            cameraAvailable = false;
        }
        
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            
            micAvailable = false;
        }
        
        
    }
    if ((!micAvailable) && (!cameraAvailable)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"请在iPhone的设”设置-隐私-麦克风/相机“选项中，允许学点云访问你的麦克风/相机！",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if ((!micAvailable) && cameraAvailable) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"请在iPhone的设”设置-隐私-麦克风“选项中，允许学点云访问你的麦克风！",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if ((!cameraAvailable) && micAvailable) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"请在iPhone的设”设置-隐私-相机“选项中，允许学点云访问你的相机！",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",@"") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
- (UIImage *)setImageOriginal:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
    
}
//AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
//AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络
//AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
//AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
//所有的子类实现这个函数 来判断网络的状态

- (void)AFNetworkingReachabilityDidChang:(NSNotification *)note
{
    
    NSDictionary *usderInfo = note.userInfo;
    
    AFNetworkReachabilityStatus status = [[usderInfo valueForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    
    NSLog(@"status%ld",(long)status);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
