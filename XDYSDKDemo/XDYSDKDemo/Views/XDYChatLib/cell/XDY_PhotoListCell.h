//
//  XDY_PhotoListCell.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol XDY_PhotoListCellDelegate <NSObject>
@optional
- (BOOL)XDYPhotoListCurrentChoiceState:(BOOL)selected;

- (void)XDYPhotoListCancelChoicePhoto;
@end

@interface XDY_PhotoListCell : UITableViewCell

@property (nonatomic , assign)id<XDY_PhotoListCellDelegate>delegate;

@property (nonatomic , assign)NSInteger listColumn;

- (void)setAssets:(NSArray*)assets;

+ (CGFloat)cellHeight;

@end
