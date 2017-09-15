//
//  MeTableViewCell.m
//  TravelDiary
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 YDB MAC. All rights reserved.
//

#import "XDYMemberCell.h"


@implementation XDYMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _handUp.hidden = YES;
    
    if (!isPad) {
        [_camera setImage:[UIImage imageNamed:@"video_iphone"] forState:(UIControlStateNormal)];
        [_mic setImage:[UIImage imageNamed:@"mac_iphone"] forState:(UIControlStateNormal)];
        [_mute setImage:[UIImage imageNamed:@"chat_iphone"] forState:(UIControlStateNormal)];
    }
    
}


- (void)setModel:(XDYMemberModel *)model nodeid:(int)nodeid{
    //头像标志
    switch (model.deviceType) {
        case 0:
            [self.userRole setImage:[UIImage imageNamed:@"PC"] forState:UIControlStateNormal];
            break;
        case 1:
        case 2:
            
            [self.userRole setImage:[UIImage imageNamed:@"APP"] forState:UIControlStateNormal];
            break;
        case 3:
            
            [self.userRole setImage:[UIImage imageNamed:@"H5"] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
    
    
    //个人显示用户名为红色
    if (model.nodeId == nodeid) {
        self.name.textColor = [UIColor redColor];
    }else{
        self.name.textColor = kUIColorFromRGB(0x333333);
    }
    
    //音视频标志
    if (model.openCamera != 0) {
        [self.camera setImage:[UIImage imageNamed:@"video-open_iphone"] forState:UIControlStateNormal];
        [self.mic setImage:[UIImage imageNamed:@"mic-open_iphone"] forState:UIControlStateNormal];
    }else{
        [self.camera setImage:[UIImage imageNamed:@"video_iphone"] forState:UIControlStateNormal];
        [self.mic setImage:[UIImage imageNamed:@"mac_iphone"] forState:UIControlStateNormal];
    }
    if (model.openMicrophones != 0) {
        [self.mic setImage:[UIImage imageNamed:@"mic-open_iphone"] forState:UIControlStateNormal];
    }else{
        [self.mic setImage:[UIImage imageNamed:@"mac_iphone"] forState:UIControlStateNormal];
    }
    
    //禁言标志
    if (model.isBannedChat) {
        [self.mute setImage:[UIImage imageNamed:@"forbid_iphone"] forState:(UIControlStateNormal)];
        
    }else{
        
        [self.mute setImage:[UIImage imageNamed:@"chat_iphone"] forState:(UIControlStateNormal)];
    }
    //用户名称
    self.name.text = model.name;
    
    //举手状态标志
    if (model.handUpTime != 0) {
        self.handUp.hidden = NO;
    }else{
        self.handUp.hidden = YES;
    }
    

}
@end
