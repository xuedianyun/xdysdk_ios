//
//  XDYDocToolView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYDocToolView.h"
#import "XDYDocButton.h"
#import "XDYSelectColorView.h"

#define kButtonSpace 15.0

//注意，枚举的顺序要和按钮名称的顺序保持一致
typedef enum
{
    kButtonColor = 0,
    kButtonBrush,
    kButtonUndo,
    kButtonPage
}kButtonActionType;

@interface XDYDocToolView()
{
    SelectColorBlock _selectColorBlock;
    ToolViewActionBlock _toolViewSelectUndoBlock;
    ToolViewActionBlock _toolViewSelectPageBlock;
    ToolViewActionBlock _toolViewSelectBrushBlock;
}

@property (weak, nonatomic)XDYDocButton *selectButton;

@property (weak, nonatomic)XDYSelectColorView *colorView;


@end

@implementation XDYDocToolView

- (void)setModel:(NSDictionary *)dic{
    if ([dic[@"isEnableDraw"] boolValue]) {
        
        [self.brushBtn setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
        self.brushBtn.userInteractionEnabled = YES;
        
    }else{
        
        [self.brushBtn setImage:[UIImage imageNamed:@"pen_forbid"] forState:(UIControlStateNormal)];
        self.brushBtn.userInteractionEnabled = NO;
        
    }
}

-(id)initWithFrame:(CGRect)frame
  afterSelectColor:(SelectColorBlock)afterSelectColor
  afterSelectbrush:(ToolViewActionBlock)afterSelectbrush
   afterSelectUndo:(ToolViewActionBlock)afterSelectUndo
   afterSelectPage:(ToolViewActionBlock)afterSelectPage
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _selectColorBlock = afterSelectColor;
        _toolViewSelectBrushBlock = afterSelectbrush;
        _toolViewSelectUndoBlock = afterSelectUndo;
        _toolViewSelectPageBlock = afterSelectPage;
        
        [self setBackgroundColor:kUIColorFromRGB(0xe3e4e6)];
        
        //通过循环的方式创建按钮
        NSArray *array = @[@"颜色",@"画笔",@"撤销",@"页码"];
        
        [self createButtonsWithArray:array];
        
    }
    
    return self;
}

#pragma mark - 创建工具视图中的按钮
-(void)createButtonsWithArray:(NSArray *)array
{
    //需要按钮的宽度，起始点位置
    NSInteger index = 0;
    CGFloat width = 30;
//    CGFloat height = self.bounds.size.height;
    
    for(int i = 0;i<array.count; i++){
    
        XDYDocButton *button = [XDYDocButton buttonWithType:UIButtonTypeCustom];

        CGFloat startX =  index * (width + kButtonSpace);
        [button setFrame:CGRectMake(startX, self.frame.size.height / 2-15, width, width)];
        
        [button setTag:index];
        
        
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
        switch (index) {
            case 0:
            {
                button.backgroundColor = kUIColorFromRGB(0x0071bc);
                button.layer.borderWidth = 2;
                button.layer.borderColor = [UIColor whiteColor].CGColor;
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = true;
            }
                break;
            case 1:
            {
                [button setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
                
                button.selected = false;
                _brushBtn = button;
            }
                
                break;
            case 2:
            {
                [button setImage:[UIImage imageNamed:@"cancel-normal"] forState:(UIControlStateNormal)];
                [button setImage:[UIImage imageNamed:@"cancel-press"] forState:(UIControlStateHighlighted)];
            }
                break;
            default:
                break;
        }
        [self addSubview:button];
        
        
        index++;
    }
}

#pragma mark - 按钮监听方法
-(void)tapButton:(XDYDocButton *)button
{

    //方法1:遍历所有的按钮，将selectedMyButton设置为NO，取消所有的下方红线
    //方法2:在属性中记录前一次选中的按钮，将该按钮的属性设置为NO
    if (self.selectButton != nil && self.selectButton != button) {
        [self.selectButton setSelectedMyButton:NO];
    }
    
    //通过设置当前按钮selectedMyButton属性，在下方绘制红线
    [button setSelectedMyButton:YES];
    self.selectButton = button;
    
    switch (button.tag) {
        case kButtonColor:
            //显示/隐藏颜色选择视图
            [self showColorView:button];
            break;
        case kButtonBrush:
        {
            if (button.selected) {
                button.selected = false;
                [button setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
            }else{
                button.selected = true;
                [button setImage:[UIImage imageNamed:@"pen-press"] forState:(UIControlStateNormal)];
            }
            _toolViewSelectBrushBlock(button.selected);
        }
            break;
        case kButtonUndo:
            //以变量的方式调用视图控制器的块代码
            _toolViewSelectUndoBlock(true);
            break;
        case kButtonPage:
            break;
        default:
            break;
    }
    
}


#pragma mark 显示/隐藏颜色选择视图
-(void)showColorView:(UIButton *)button
{
    //1.懒加载颜色视图
    if (self.colorView == nil) {
        XDYSelectColorView *view = [[XDYSelectColorView alloc]initWithFrame:CGRectMake(45, 0, 200, 44) afterSelectColor:^(UIColor *color){
            
            //以函数的方式调用块代码变量
            _selectColorBlock(color);
            [button setBackgroundColor:color];
            _colorView = nil;
            
            
        }];
        
        [self addSubview:view];
        
        self.colorView = view;
    }
}

@end
