//
//  XDYQuestionnaireView.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDYChooseBtnAndTitle.h"
typedef void(^AnswerButtonClick)(NSString *questionId, NSArray *answer);

@interface XDYQuestionnaireView : UIScrollView

//这个属性需要暴漏出来，因为需要上传答案，我们这边需要cookie等信息，所以把上传答案的逻辑封装到SDK中不是方便
@property (nonatomic, copy) AnswerButtonClick answerButtonClick;


/**
 显示问卷页面

 @param duration 显示的时间，单位秒，0代表没有时间限制
 @param titleArray  题目
 @param isCheck 学点云提供的questionId
 */
- (void)showWithDuration:(NSTimeInterval)duration
                    type:(int)type
              titleArray:(NSArray *)titleArray
                 isCheck:(BOOL)isCheck;

- (void)showQuestionTimer:(NSInteger)duration;
/**
 关闭问卷页面
 */
- (void)hide;

- (void)getAnswerXDYBlock:(AnswerButtonClick)answerButtonClick;


@end
