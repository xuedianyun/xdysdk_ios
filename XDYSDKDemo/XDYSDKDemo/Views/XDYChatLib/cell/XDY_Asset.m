//
//  XDY_Asset.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDY_Asset.h"
@implementation XDY_Asset
- (id)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if(self){
        _asset = asset;
        _selected = NO;
    }
    return self;
}
@end
