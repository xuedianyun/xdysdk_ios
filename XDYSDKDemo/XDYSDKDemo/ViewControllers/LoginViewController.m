//
//  LoginViewController.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "LoginViewController.h"
#import "ClassViewController.h"
#import "RePlayViewController.h"
#import "XDYNavigationController.h"
#import "ClassForPadViewController.h"
#import "RePlayForPadViewController.h"
#import "AppDelegate.h"
#import "LoginTagView.h"

#import "XDYQrCodeScanne.h"

@interface LoginViewController ()

@property (strong, nonatomic)  LoginTagView *classId;

@property (strong, nonatomic)  LoginTagView *userRole;

@property (strong, nonatomic)  LoginTagView *portal;

@property (strong, nonatomic)  LoginTagView *userId;

@property (strong, nonatomic)  LoginTagView *userName;


@property (nonatomic, assign) float space;

@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.translucent = NO;//设置导航栏为不透明
    
    if (isPad) {
        _space =40;
    }else{
        _space = (XDY_HEIGHT - 360)/5;
    }
    
    UIButton *scanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [scanBtn setImage:[UIImage imageNamed:@"QR.png"] forState:(UIControlStateNormal)];
    scanBtn.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:scanBtn];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *loginIcon = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginIcon setImage:[self setImageOriginal:@"XueDianYunSDK.bundle/login"] forState:(UIControlStateNormal)];
    loginIcon.frame = CGRectMake(0, _space+20, XDY_WIDTH, 40);
    [self.view addSubview:loginIcon];
    loginIcon.userInteractionEnabled = NO;
    
    LoginTagView *classIDTag = [[LoginTagView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(loginIcon.frame)+_space, XDY_WIDTH-80, 50)];
    classIDTag.nameLabel.text = @"classId";
    classIDTag.textField.text = @"2106108706";
    [self.view addSubview:classIDTag];
    self.classId = classIDTag;
    
    LoginTagView *userRoleTag = [[LoginTagView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(classIDTag.frame), XDY_WIDTH-80, 50)];
    userRoleTag.nameLabel.text = @"userRole";
    userRoleTag.textField.text = @"normal";//invisible监课  normal学生
    [self.view addSubview:userRoleTag];
    self.userRole = userRoleTag;
    
    LoginTagView *portalTag = [[LoginTagView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(userRoleTag.frame), XDY_WIDTH-80, 50)];
    portalTag.nameLabel.text = @"portal";
    portalTag.textField.text = @"saas.xuedianyun.com";
    
//    portalTag.textField.text = @"59.110.127.247:80";
    [self.view addSubview:portalTag];
    self.portal = portalTag;
    
    LoginTagView *userIdTag = [[LoginTagView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(portalTag.frame), XDY_WIDTH-80, 50)];
    userIdTag.nameLabel.text = @"userId";
    userIdTag.textField.text = @"0";
    [self.view addSubview:userIdTag];
    self.userId = userIdTag;
    
    LoginTagView *userNameTag = [[LoginTagView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(userIdTag.frame), XDY_WIDTH-80, 50)];
    userNameTag.nameLabel.text = @"stuName";
    userNameTag.textField.text = @"lv";
    [self.view addSubview:userNameTag];
    self.userName = userNameTag;
    
    UIButton *joinClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    joinClass.backgroundColor = kUIColorFromRGB(0x3598db);
    joinClass.frame = CGRectMake(40, CGRectGetMaxY(_userName.frame)+_space, XDY_WIDTH-80, 44);
    joinClass.layer.cornerRadius = 2.5;
    [joinClass setTitle:NSLocalizedString(@"进入课堂",@"") forState:UIControlStateNormal];
    joinClass.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [joinClass addTarget:self action:@selector(joinClass:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:joinClass];
    
    UIButton *vodClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    vodClass.backgroundColor = kUIColorFromRGB(0x26c8a3);
    vodClass.frame = CGRectMake(40, CGRectGetMaxY(joinClass.frame)+20, XDY_WIDTH-80, 44);
    vodClass.layer.cornerRadius = 2.5;
    [vodClass setTitle:NSLocalizedString(@"进入录制回放",@"") forState:UIControlStateNormal];
    vodClass.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [self.view addSubview:vodClass];
    [vodClass addTarget:self action:@selector(Vod:) forControlEvents:(UIControlEventTouchUpInside)];
  
}

- (void)scanBtnClick:(UIButton *)sender{
    
    XDYQrCodeScanne *scanVC = [[XDYQrCodeScanne alloc]init];
    scanVC.scanneScusseBlock = ^(SYCodeType codeType, NSString *string){
        
        if (SYCodeTypeUnknow == codeType) {
            
        }else{
            //成功回调
            NSString *classId = [self companentString:string SeparateString:@"classId="];
            NSString *userId = [self companentString:string SeparateString:@"userId="];
            NSString *userRole = [self companentString:string SeparateString:@"userRole="];
            NSString *portalIP = [self companentString:string SeparateString:@"portalIP="];
            NSString *portalPort = [self companentString:string SeparateString:@"portalPort="];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    
                    AppDelegate  * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    app.shouldChangeOrientation = YES;
                    ClassForPadViewController * vc = [[ClassForPadViewController alloc] init];
                    vc.classId = classId;
                    vc.userRole = userRole;
                    vc.portal = [NSString stringWithFormat:@"%@:%@",portalIP,portalPort];
                    vc.userId = userId;
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }else{
                    
                    ClassViewController *vc = [[ClassViewController alloc]init];
                    vc.classId = classId;
                    vc.userRole = userRole;
                    vc.portal = [NSString stringWithFormat:@"%@:%@",portalIP,portalPort];
                    vc.userId = userId;
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }
                
            });
        }
    };
    [scanVC scanning];
    
}



- (NSString *)companentString:(NSString *)comStr SeparateString:(NSString *)sepStr {
    
    NSArray *array = [comStr componentsSeparatedByString:sepStr];
    
    NSString *string = [array.lastObject componentsSeparatedByString:@"&"].firstObject;
    
    return string;
}
- (void)authorizationDenied{
    
    NSLog(@"获取权限失败");
}

- (void)joinClass:(UIButton *)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        AppDelegate  * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.shouldChangeOrientation = YES;
        ClassForPadViewController * vc = [[ClassForPadViewController alloc] init];
        
        vc.classId = self.classId.textField.text;
        vc.userRole = self.userRole.textField.text;
        vc.portal = self.portal.textField.text;
        vc.userId = self.userId.textField.text;
        
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        ClassViewController *vc = [[ClassViewController alloc]init];
        vc.classId = self.classId.textField.text;
        vc.userRole = self.userRole.textField.text;
        vc.portal = self.portal.textField.text;
        vc.userId = self.userId.textField.text;
        vc.studentName = self.userName.textField.text;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)Vod:(UIButton *)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        AppDelegate  * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.shouldChangeOrientation = YES;
        RePlayForPadViewController *vc = [[RePlayForPadViewController alloc]init];
        vc.classId = self.classId.textField.text;
        vc.userRole = self.userRole.textField.text;
        vc.portal = self.portal.textField.text;
        vc.userId = self.userId.textField.text;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        RePlayViewController *vc = [[RePlayViewController alloc]init];
        vc.classId = self.classId.textField.text;
        vc.userRole = self.userRole.textField.text;
        vc.portal = self.portal.textField.text;
        vc.userId = self.userId.textField.text;
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}
- (UIImage *)setImageOriginal:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 在ipad设备下强制横屏，在iphone设备下强制竖屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation     NS_AVAILABLE_IOS(6_0)
//{
//   return UIInterfaceOrientationPortrait;
//}
//- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
//{
//    return YES;
//}

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
