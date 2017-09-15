//
//  AppDelegate.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/2/4.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //开启网络监测
    [self isNetWorking];
    
    
    return YES;
}
-(void)isNetWorking{
    
    //开启网络指示器，开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    
    __block UIBackgroundTaskIdentifier bgTask;// 后台任务标识
    // 结束后台任务
    void (^endBackgroundTask)() = ^(){
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    };
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        endBackgroundTask();
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //发送关闭视频推流窗口通知
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"enterBackground" object:nil]];
        
        
    });
    
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //发送关闭视频推流窗口通知
//        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"enterForeground" object:nil]];
        
        
    });
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//禁止锁屏
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    
    if (self.shouldChangeOrientation == YES) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    //    return UIInterfaceOrientationMaskAll;
}

@end
