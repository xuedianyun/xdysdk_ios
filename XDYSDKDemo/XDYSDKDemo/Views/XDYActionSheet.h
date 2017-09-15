//
//  DBActionSheet.h
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/10.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popActionSheetDelegate <NSObject>
/**
 点击cell的代理方法

 @param index 选中的cell的indexPath.row
 @param title 选中的cell上的值
 */
- (void)sheetSeletedIndex:(NSInteger)index title:(NSString *)title actionSheetTag:(NSInteger)tag;



@end

@interface XDYActionSheet : UIView


@property (nonatomic , weak)id<popActionSheetDelegate>delegate;

//字体颜色
@property (nonatomic , strong) UIColor * titleColor;

//字体大小
@property (nonatomic , strong) UIFont * titleFont;

/**
 初始化view

 @param frame      CGSizeZero
 @param object     当前的UIViewController
 @param titleArray 显示的个数
 @param rowHeight  tableView行高
 
 */
- (instancetype)initWithFrame:(CGRect)frame
                       object:(UIViewController *)object
                   titleArray:(NSArray *)titleArray
                    rowHeight:(CGFloat)rowHeight
                  setTableTag:(NSInteger)tag;

@end
