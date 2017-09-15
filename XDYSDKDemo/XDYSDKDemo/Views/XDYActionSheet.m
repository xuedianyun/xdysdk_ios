//
//  DBActionSheet.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/10.
//  Copyright © 2017年 liyanyan. All rights reserved.
//
#define UI_width [UIScreen mainScreen].bounds.size.width
#define UI_height [UIScreen mainScreen].bounds.size.height

#import "XDYActionSheet.h"
@interface XDYActionSheet ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) UIView * blackView;//黑色半透明背景

@property (nonatomic , strong) NSArray * dataArray;//数据源

@property (nonatomic , assign) CGFloat height;//行高
@end

@implementation XDYActionSheet

- (instancetype)initWithFrame:(CGRect)frame object:(UIViewController *)object titleArray:(NSArray *)titleArray rowHeight:(CGFloat)rowHeight  setTableTag:(NSInteger)tag{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArray = titleArray;
        self.height = rowHeight;
        self.frame = CGRectMake(0, UI_height, UI_width, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, (UI_height)-((rowHeight * _dataArray.count) + (rowHeight + 10)), UI_width, ((rowHeight * _dataArray.count) + (rowHeight + 10)));
        }];

        [self initTableView:tag];
        
        //黑色半透明背景
        self.blackView = [[UIView alloc] init];
        self.blackView.frame = CGRectMake(0, 0, UI_width, UI_height);
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.3;
        [object.view addSubview:self.blackView];
        
        //点击屏幕的事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSheetDismiss)];
        tap.numberOfTapsRequired = 1;
        [self.blackView addGestureRecognizer:tap];
    }
    return self;
}

- (void)actionSheetDismiss {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0;
        self.frame = CGRectMake(0, UI_height, UI_width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tableView life style
- (void)initTableView:(NSInteger)tag {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_width, UI_height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
    self.tableView.tag = tag;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_width, 60)];
    view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 10, UI_width, 50);
    [deleteBtn setTitle:NSLocalizedString(@"取消",@"") forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteBtn addTarget:self action:@selector(actionSheetDismiss) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.height + 10;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"actionSheetCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, UI_width-24, 50)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = _dataArray[indexPath.row];
    titleLabel.textColor = _titleColor;
    titleLabel.font = _titleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetSeletedIndex:title:actionSheetTag:)]) {
        [self.delegate sheetSeletedIndex:indexPath.row title:_dataArray[indexPath.row] actionSheetTag:tableView.tag];
        [self actionSheetDismiss];
    }
}

@end
