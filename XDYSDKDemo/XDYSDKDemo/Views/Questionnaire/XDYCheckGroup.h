//
//  XDYCheckGroup.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDYChooseBtnAndTitle.h"
@interface XDYCheckGroup : UIView<XDYChooseBtnAndTitleDelegate>
@property (nonatomic, strong) NSString *selectText;
@property (nonatomic) NSInteger selectValue;
@property (nonatomic, strong) NSMutableArray *selectTextArr;
@property (nonatomic, strong) NSMutableArray *selectValueArr;
@property (nonatomic,assign) BOOL isCheck;//是否复选
- (id)initWithFrame:(CGRect)frame WithCheckBtns:(NSArray*)checkBtns;

- (void)removeAllCheckBtn;


@end
