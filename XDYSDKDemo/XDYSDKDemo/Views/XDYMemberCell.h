//
//  MeTableViewCell.h
//  TravelDiary
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 YDB MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDYMemberModel.h"

@interface XDYMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *handUp;
@property (weak, nonatomic) IBOutlet UIButton *camera;
@property (weak, nonatomic) IBOutlet UIButton *mic;
@property (weak, nonatomic) IBOutlet UIButton *mute;
@property (weak, nonatomic) IBOutlet UIButton *userRole;

- (void)setModel:(XDYMemberModel *)model nodeid:(int)nodeid;

@end
