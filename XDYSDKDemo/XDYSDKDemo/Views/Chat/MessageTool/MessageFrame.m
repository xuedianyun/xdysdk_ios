//
//  MessageFrame.m
//  QQ聊天布局
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//



#import "MessageFrame.h"
#import "MessageInfo.h"


#import "NSAttributedString+JTATEmoji.h"


@implementation MessageFrame
- (void)setMessageInfo:(MessageInfo *)messageInfo{
    _messageInfo = messageInfo;
    
    // 0、聊天容器宽度
    CGFloat screenW;
    if (isPad) {
        screenW = XDY_WIDTH/4-15;
    }else{
        screenW = XDY_WIDTH;
    }
    _kContentW = screenW;
    
    // 1、计算时间的位置
    if (_showTime){
        
        CGFloat timeY = kMargin;
//        CGSize timeSize = [_message.time sizeWithAttributes:@{UIFontDescriptorSizeAttribute: @"16"}];
//        CGSize timeSize = [_messageInfo.time sizeWithFont:kTimeFont];
         NSDictionary *attribute = @{UIFontDescriptorSizeAttribute: @"12"};
        CGSize timeSize = [_messageInfo.time sizeWithAttributes:attribute];
        CGFloat timeX = (screenW - timeSize.width-kTimeMarginW) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    }
    
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    
    
    // 2.1 如果是自己发得，头像在右边
    if (_messageInfo.type == MessageTypeMe) {
        iconX = screenW - kMargin - kIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + kMargin;
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    if (_messageInfo.type == MessageTypeTeacher) {
        CGFloat teacherX = CGRectGetMaxX(_iconF) + kMargin;
        CGFloat teacherY = iconY;
        _teachF = CGRectMake(teacherX, teacherY, 30, kNameH);
    }
    
    //3、用户名位置
    CGFloat nameX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat nameY = iconY;
    
    if (_messageInfo.type == MessageTypeTeacher) {
        nameX = CGRectGetMaxX(_iconF) + kMargin +32;
    }
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:kContentFont,NSFontAttributeName,nil];
    CGSize  nameContentSize =[_messageInfo.userName boundingRectWithSize:CGSizeMake(_kContentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    if (_messageInfo.type == MessageTypeMe) {
        nameX = iconX - kMargin - nameContentSize.width;
    }
    _nameF = CGRectMake(nameX, nameY, nameContentSize.width, kNameH);
   
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY + kNameH + 5;
//    CGSize contentSize = [_messageInfo.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(_kContentW, CGFLOAT_MAX)];

    
    CGSize textBlockMinSize = {screenW-60, CGFLOAT_MAX};
//    CGSize retSize;
    NSAttributedString *attributedString;
    
    CGSize contentSize;
    
    if (_messageInfo.msgType) {
        
        contentSize = CGSizeMake(100.0f, 100.0f);
        
    }else{
    
        if (_messageInfo.type == MessageTypeMe) {
            attributedString = [NSAttributedString emojiAttributedString:_messageInfo.content withFont:kContentFont withColor:[UIColor whiteColor]];
        }else{
            attributedString = [NSAttributedString emojiAttributedString:_messageInfo.content withFont:kContentFont withColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        }
        CGRect boundingRect = [attributedString boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        contentSize = boundingRect.size;
    }
    
//    CGSize contentSize = retSize;
    
    if (_messageInfo.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
    
    
    // 4、计算高度
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
    
    
    _sendF = CGRectMake(contentX-50, contentY+40, 50, 20);
    
}


@end
