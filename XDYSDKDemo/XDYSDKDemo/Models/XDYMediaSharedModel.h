//
//  XDYMediaSharedModel.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/8.
//  Copyright © 2017年 liyanyan. All rights reserved.
//  媒体共享model

#import <Foundation/Foundation.h>

@interface XDYMediaSharedModel : NSObject

@property (nonatomic, assign) int        itemIdx;
@property (nonatomic, assign) int        owner;
@property (nonatomic, assign) int        from;
@property (nonatomic, strong) NSString   *fileType;
@property (nonatomic, strong) NSString   *creatUserId;
@property (nonatomic, strong) NSString   *url;
@property (nonatomic, assign) int        status;
@property (nonatomic, strong) NSString   *fileId;
@property (nonatomic, strong) NSString   *fileName;
@property (nonatomic, assign) int        seek;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
