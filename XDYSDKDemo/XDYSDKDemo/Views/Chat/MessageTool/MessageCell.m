//
//  MessageCell.m
//  QQ聊天布局
//  XDY
//
//  Created by 3mang on 16/1/15.
//  Copyright © 2016年 sanmang. All rights reserved.
//

#import "MessageCell.h"
#import "MessageInfo.h"
#import "MessageFrame.h"
#import "NSAttributedString+JTATEmoji.h"
#import "UIImage+LYY.h"
//#import "UIImageView+WebCache.h"




@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView  *_iconView;
    UIButton     *_userName;
    UIButton     *_contentBtn;
    UIImageView  *_contentImageView;
    
    UITextView   *_contentTextView;
    UIButton     *_teachBtn;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"XDYEmoji.bundle/chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        //附加老师标志
        _teachBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _teachBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:157/255.0 blue:85/255.0 alpha:1];
        [_teachBtn setTitle:@"老师" forState:(UIControlStateNormal)];
        _teachBtn.titleLabel.font = kTeacherFont;
        _teachBtn.enabled = NO;
        [self.contentView addSubview:_teachBtn];
        
        // 3、创建用户名
        _userName = [[UIButton alloc]init];
        _userName.enabled = NO;
        _userName.titleLabel.font = kTimeFont;
        [self.contentView addSubview:_userName];
        
        // 4、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
    
        [self.contentView addSubview:_contentBtn];
        
        _contentTextView = [[UITextView alloc]init];
        
        [self.contentView addSubview:_contentTextView];
        
        //5.图片选择
        _contentImageView  = [[UIImageView alloc]init];
        [self.contentView addSubview:_contentImageView];
        
        
    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    MessageInfo *messageInfo = _messageFrame.messageInfo;
    
    // 1、设置时间
    [_timeBtn setTitle:messageInfo.time forState:UIControlStateNormal];
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    _iconView.image = [UIImage imageNamed:messageInfo.icon];
    _iconView.frame = _messageFrame.iconF;
    
    //附加老师标志
    _teachBtn.layer.cornerRadius = 3;
    
    _teachBtn.frame = _messageFrame.teachF;
    
    // 3、设置用户名
    [_userName setTitle:messageInfo.userName forState:UIControlStateNormal];
    [_userName setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:(UIControlStateNormal)];
    
    _userName.layer.cornerRadius = 5;
    _userName.backgroundColor = [UIColor clearColor];
    _userName.frame = _messageFrame.nameF;
    
    
    // 4、设置内容
 
        if (messageInfo.type == MessageTypeMe) {
            
            [_contentBtn setAttributedTitle:[NSAttributedString emojiAttributedString:messageInfo.content withFont:_contentBtn.titleLabel.font withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        }else{
            [_contentBtn setAttributedTitle:[NSAttributedString emojiAttributedString:messageInfo.content withFont:_contentBtn.titleLabel.font withColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]] forState:UIControlStateNormal];
        }
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
        
        _contentBtn.frame = _messageFrame.contentF;
        
        
        [_contentBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        if (messageInfo.type == MessageTypeMe) {
            _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
        }
        
        UIImage *normal , *focused;
        if (messageInfo.type == MessageTypeMe) {
            
            normal = [UIImage resizedImageWithName:@"XueDianYunSDK.bundle/sendBack"];
            focused = [UIImage resizedImageWithName:@"XueDianYunSDK.bundle/sendBack"];
            
        }else{
            
            normal = [UIImage resizedImageWithName:@"XueDianYunSDK.bundle/receiveBack"];
            focused = [UIImage resizedImageWithName:@"XueDianYunSDK.bundle/receiveBack"];
            
        }
        
        UIEdgeInsets insets;
        if (messageInfo.type == MessageTypeMe) {
            insets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
            
        }else{
            insets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
        }
        
        [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
        [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
        

   
}

@end
