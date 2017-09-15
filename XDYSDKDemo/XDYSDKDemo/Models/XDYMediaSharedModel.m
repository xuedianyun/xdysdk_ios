//
//  XDYMediaSharedModel.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/8.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYMediaSharedModel.h"

@implementation XDYMediaSharedModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _itemIdx = [dict[@"itemIdx"] intValue];
        _owner = [dict[@"owner"] intValue];
        _from = [dict[@"_from"] intValue];
        _fileType = dict[@"fileType"];
        _creatUserId = dict[@"creatUserId"];
        _url = dict[@"url"];
        _status = [dict[@"status"] intValue];
        _fileId = dict[@"fileId"];
        _fileName = dict[@"fileName"];
        _seek = [dict[@"seek"] intValue];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
