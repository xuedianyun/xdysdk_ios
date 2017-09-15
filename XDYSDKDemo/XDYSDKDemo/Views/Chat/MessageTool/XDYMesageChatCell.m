//
//  XDYMeesageChatCell.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/21.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYMesageChatCell.h"

#import "MessageInfo.h"
#import "MessageFrame.h"
#import "NSAttributedString+JTATEmoji.h"
#import "UIImage+LYY.h"
#import "XDYFacebookImageViewer.h"
#import "UIImageView+XDYFacebookImageView.h"


@interface XDYMesageChatCell ()
{
    UIButton     *_timeBtn;
    UIImageView  *_iconView;
    UIButton     *_userName;
    UIButton     *_contentBtn;
    UIImageView  *_contentImageView;
    UITextView   *_contentTextView;
    UIButton     *_teachBtn;
    UILabel      *_sendLabel;
    
}
@end
@implementation XDYMesageChatCell

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
        
        //6.发送失败提醒
        _sendLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_sendLabel];
        _sendLabel.backgroundColor = [UIColor redColor];
        _sendLabel.hidden = YES;
        
        
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
  
    _contentImageView.frame = _messageFrame.contentF;
    
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    _contentImageView.layer.cornerRadius = 8;
    
    [_contentImageView.layer setMasksToBounds:YES];
    
    
    if (messageInfo.imgUrl == nil) {
//        [_contentImageView sd_setImageWithURL:(NSURL *)messageInfo.content placeholderImage:nil];
        [_contentImageView setImageURL:(NSURL *)messageInfo.content];
        
    }else{
        [_contentImageView setImage:messageInfo.imgUrl];
    }
    

    [_contentImageView setupImageViewerWithCompletionOnOpen:^{
        
    } onClose:^{
        
    }];
    
    if (messageInfo.type == MessageTypeMe && messageInfo.isSuccess) {
        _sendLabel.frame = _messageFrame.sendF;
        _sendLabel.hidden = NO;
    }
    
    
    
}




@end
