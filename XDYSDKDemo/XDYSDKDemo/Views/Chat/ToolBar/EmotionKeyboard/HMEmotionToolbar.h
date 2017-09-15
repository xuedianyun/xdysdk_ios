//
//  HMEmotionToolbar.h
//  黑马微博
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 heima. All rights reserved.
//  表情底部的工具条

#import <UIKit/UIKit.h>
@class HMEmotionToolbar;

typedef enum {
    HMEmotionTypeRecent, // 最近
    HMEmotionTypeEmoji, // Emoji
//    HMEmotionTypeSend,//发送
} HMEmotionType;

@protocol HMEmotionToolbarDelegate <NSObject>

@optional
- (void)emotionToolbar:(HMEmotionToolbar *)toolbar didSelectedButton:(HMEmotionType)emotionType;
@end

@interface HMEmotionToolbar : UIView
@property (nonatomic, weak) id<HMEmotionToolbarDelegate> delegate;
@end
