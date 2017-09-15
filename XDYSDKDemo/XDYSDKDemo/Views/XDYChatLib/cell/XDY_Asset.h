//
//  XDY_Asset.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface XDY_Asset : ALAsset
@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) BOOL selected;
- (id)initWithAsset:(ALAsset *)asset;
@end
