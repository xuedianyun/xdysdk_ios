//
//  XDYHeader.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/10.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#ifndef XDYHeader_h
#define XDYHeader_h


#endif /* XDYHeader_h */

#import "UIImage+fixOrientation.h"

#import "XDYDocModel.h"
#import "XDYMesageChatCell.h"
#import "XDYJoinSuccessModel.h"

#import "XDYBottomView.h"

#import "NSString+Extension.h"

#import "UIImage+UnfindImageName.h"
#import "XDYAlert.h"
#import "XDYActionSheet.h"

#import "AFNetworkReachabilityManager.h"

#import "HorizontalMenuView.h"
#import "DocView.h"
#import "DocForPadView.h"
#import "NSStringLimit.h"
#import "XDYToolBar.h"
#import "XDYCurrentTime.h"
#import "XDYAlertView.h"
#import "XDYLoadingHUD.h"

#import <UIImageView+YYWebImage.h>
#import "XDYGetImageSize.h"


#import "XDYNavigationController.h"
#import "XDYAVPlayerView.h"

#import "XDYMemberCell.h"

#import "XDYHtmlDocView.h"
#import "XDYVideoBackView.h"

#import "XDYMemberModel.h"
#import "XDYMediaSharedModel.h"
#import "XDYCallView.h"


#import "XDYDocToolView.h"

#import "XDYUIColorToRGB.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#ifdef DEBUG

//根据是否为调试模式, 来开启打印
#ifdef AvplayerDebug
#define Log(, ...) NSLog((@"函数名: %s [行: %d]" ), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define Log(...) //
#endif

#else
#define Log(...) //
#endif


/*相机*/
#import "XDY_PhotoListCell.h"
#import "XDY_PictureListVC.h"
#import "XDY_CameraVC.h"


#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "AFNetworking.h"

/** 表情相关 */
#import "UIImage+Extension.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"


// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)
// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"
/******/

#define NavigationHeight self.navigationController.navigationBar.frame.size.height

//判断是否为ipad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define XDY_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define XDY_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define XDY_VIDEOHEIGHT ([UIScreen mainScreen].bounds.size.height)/5*2

/**加载提示**/
#define kScreenWidth                ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight               ([UIScreen mainScreen].bounds.size.height)
#define kScreenBounds               ([UIScreen mainScreen].bounds)
#define HCApplication                [UIApplication sharedApplication]
#define kWindow                      HCApplication.keyWindow

#define kTabBarHight self.tabBarController.tabBar.height
#define ALD(x)                      ((x) * kScreenWidth/750.0)
#define ALDHeight(y)                ((y) * kScreenHeight/1334.0)

#define kTabbarWidtn  (kScreenWidth)
#define kStatusBarHeight [HCApplication statusBarFrame].size.height

#define kNavigationBarHeight 44.f
#define StatusbarSize ((ISIOS7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)
#define kUpSpare ((kStatusBarHeight)+(kNavigationBarHeight))
#define kTabBarHeight   49.0f

#define kSpaceHeight 30.f
#define HCFontWithPixel(a)     [UIFont systemFontOfSize:ALD(a)]

#import "XDYCommonTool.h"
#define MAS_SHORTHAND_GLOBALS
#import "masonry.h"
#define XDYHexColor(hexColor) [XDYCommonTool colorWithHexColorString:hexColor]

/***********/
/*国际化*/
#define NSLocalizedString(key, comment) \
[NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
#define NSLocalizedStringFromTable(key, tbl, comment) \
[NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:(tbl)]
#define NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
[bundle localizedStringForKey:(key) value:@"" table:(tbl)]
#define NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
[bundle localizedStringForKey:(key) value:(val) table:(tbl)]

typedef NS_ENUM(NSUInteger, XDYClassEventType) {
    XDYClassEventTypeInit,                      //!<学点云实例化成功
    XDYClassEventTypeInitSuccess,               //!<课堂初始化成功
    XDYClassEventTypeJoinSuccess,               //!<加入课堂成功
    XDYClassEventTypeClassUpdateStatus,         //!<课堂状态更新
    XDYClassEventTypeClassUpdateRoster,         //!<课堂人员更新
    XDYClassEventTypeClassInsertRoster,         //!<课堂人员加入消息
    XDYClassEventTypeClassDeleteRoster,         //!<课堂人员离开消息
    
    XDYClassEventTypeVideoPlay,                 //!<视频播放消息
    XDYClassEventTypeVideoStop,                 //!<视频停止消息
    XDYClassEventTypeAudioPlay,                 //!<音频播放消息
    XDYClassEventTypeAudioStop,                 //!<音频停止消息
    XDYClassEventTypeVideoBroadcast,            //!<视频控制消息
    XDYClassEventTypeAudioBroadcast,            //!<音频控制消息
    
    
    XDYClassEventTypeMediaStopPublish,          //!<停止正在推流视频消息
    XDYClassEventTypeScreenSharePlay,           //!<屏幕共享开始消息
    XDYClassEventTypeScreenShareStop,           //!<屏幕共享停止消息
    XDYClassEventTypeMediaSharedUpdate,         //!<媒体共享更新消息
    XDYClassEventTypeMediaSharedDelete,         //!<媒体共享删除消息
    XDYClassEventTypeMusicSharedUpdate,         //!<伴音消息更新
    XDYClassEventTypeMusicShredDelete,          //!<伴音消息删除
    
    XDYClassEventTypeChatReceiveMessage,        //!<聊天接收消息
    XDYClassEventTypeDocumentUpdate,            //!<文档更新消息
    XDYClassEventTypeDocumentDelete,            //!<文档删除消息
    XDYClassEventTypeWhiteboardAnnotationUpdate,//!<文档标注消息
    XDYClassEventTypeCursorUpdate,              //!<激光笔消息更新
    XDYClassEventTypeStartAnswerQuestion,       //!<开始答题\签到消息
    XDYClassEventTypeStopAnswerQuestion,        //!<停止答题\签到消息
    XDYClassEventTypeUpadateQuestionTime,       //!<答题\签到定时时间更新
    XDYClassEventTypeClassExit,                 //!<退出课堂消息
    XDYClassEventTypeErrorEvent                 //!<异常消息
};


//动态ppt
//enum{
//    XDYCHANGESRC,//更改ppt地址
//    XDYPREPAGE,//上一页
//    XDYNEXTPAGE,//下一页
//    XDYSLIDERPAGE,//指定的页码
//    XDYPRESTEP,//上一步
//    XDYNEXTSTEP,//下一步
//} XDYControl;

