//
//  XDYJoinSuccessModel.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDYJoinSuccessModel : NSObject

@property (nonatomic, assign) int classType;

@property (nonatomic, strong) NSString *siteId;

@property (nonatomic, strong) NSString *DOCServerIP;
@property (nonatomic, strong) NSString *serverAndLoacTimeDistanc;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) int maxChannels;
@property (nonatomic, assign) int nodeId;
@property (nonatomic, strong) NSString *userId;


@end
