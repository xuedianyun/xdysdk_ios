//
//  HorizontalMenuView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/10.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "HorizontalMenuView.h"



@implementation HorizontalMenuView


- (void)setModel:(NSDictionary *)message{
    if ([message[@"isEnableDraw"] boolValue]) {
        
        [self.brushButton setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
        self.brushButton.userInteractionEnabled = YES;
        
    }else{
        
        [self.brushButton setImage:[UIImage imageNamed:@"pen_forbid"] forState:(UIControlStateNormal)];
        self.brushButton.userInteractionEnabled = NO;
        
    }

}
#pragma mark- 创建菜单名数组和设置菜单名方法
-(void)setNameWithArray:(NSArray*)menuArray  menuModel:(int)menuModel{
    
    switch (menuModel) {  //0.监课模式    1.举手    2.兼课
        case 0:
            
            break;
        case 1:
        {
            UIButton *handButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [handButton setImage:[UIImage imageNamed:@"hand-normal-"] forState:(UIControlStateNormal)];
            handButton.frame = CGRectMake(self.frame.size.width-50, 0, 40, self.frame.size.height);
            handButton.tag = 100;
            handButton.selected = false;
            
            [handButton addTarget:self action:@selector(handBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:handButton];
            _handButton = handButton;
            

        }
            break;
        case 2:
        {
            UIButton *undoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [undoButton setImage:[UIImage imageNamed:@"cancel-normal"] forState:(UIControlStateNormal)];
            [undoButton setImage:[UIImage imageNamed:@"cancel-press"] forState:(UIControlStateFocused)];
            undoButton.frame = CGRectMake(self.frame.size.width-50, 0, 40, self.frame.size.height);
            undoButton.tag = 3;
            [undoButton addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:undoButton];
            
            
            UIButton *brushButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [brushButton setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
            brushButton.frame = CGRectMake(self.frame.size.width-95, 0, 40, self.frame.size.height);
            brushButton.selected = false;
            brushButton.tag = 101;
            [brushButton addTarget:self action:@selector(brushBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:brushButton];
            _brushButton = brushButton;
            

        }
            
            break;
        default:
            break;
    }
  
    
    _menuArray = menuArray;
    
    //一个间隔
    CGFloat SPACE = (self.frame.size.width/5*3)/[_menuArray count];
    
    for (int i = 0; i<[menuArray count];i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SPACE*i, 0, SPACE, self.frame.size.height);

        
        btn.tag = i;
        if (btn.tag == 0) {
            btn.enabled = NO;
        }
        
        //设置按钮字体大小 颜色 状态
        
        //[btn setTitle:menuArray[i] forState:UIControlStateNormal];下面的代替
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
        [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:kUIColorFromRGB(0x666666)} range:NSMakeRange(0, [str  length])];
        [btn setAttributedTitle:str forState:UIControlStateNormal];
        
        NSMutableAttributedString *selStr = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
        [selStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:kUIColorFromRGB(0x3598db)} range:NSMakeRange(0, [str  length])];
        [btn setAttributedTitle:selStr forState:UIControlStateDisabled];
        
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
//    //底部划线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    line.backgroundColor = kUIColorFromRGB(0xe5e5e5);
    [self addSubview:line];
    
    //标识当选被选中下划线
    UIView *markLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, SPACE+1, 2)];
    markLine.tag = 999;
    markLine.backgroundColor = kUIColorFromRGB(0x3598db);
    [self addSubview:markLine];
}

#pragma mark- 菜单按钮点击事件
- (void)btnClick:(UIButton*)sender{
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                [subBtn setEnabled:NO];
            }else {
                [subBtn setEnabled:YES];
            }
        }
    }
    //计算每个按钮间隔
    CGFloat SPACE = (self.frame.size.width/5*3)/[_menuArray count];
    
    UIView *markView = [self viewWithTag:999];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect markFrame =markView.frame;
        markFrame.origin.x = sender.tag*SPACE;
        markView.frame = markFrame;
    }];
    

    [self click:sender];
    
}
- (void)click:(UIButton *)sender{
    if ([self.myDelegate respondsToSelector:@selector(getTag:)]) {
        [self.myDelegate getTag:sender.tag];
    }

}
- (void)handBtnClick:(UIButton*)sender{
    
    if (sender.selected) {
        sender.selected = false;
        [sender setImage:[UIImage imageNamed:@"hand-normal-"] forState:(UIControlStateNormal)];
    }else{
        sender.selected = true;
        [sender setImage:[UIImage imageNamed:@"hand-selected"] forState:(UIControlStateNormal)];
    }
    
    if ([self.myDelegate respondsToSelector:@selector(isHand:)]) {
        [self.myDelegate isHand:sender.selected];
    }
}

- (void)brushBtnClick:(UIButton*)sender{
    if (sender.selected) {
        sender.selected = false;
        [sender setImage:[UIImage imageNamed:@"pen-normal"] forState:(UIControlStateNormal)];
    }else{
        sender.selected = true;
        [sender setImage:[UIImage imageNamed:@"pen-press"] forState:(UIControlStateNormal)];
    }
    
    if ([self.myDelegate respondsToSelector:@selector(isBrush:)]) {
        [self.myDelegate isBrush:sender.selected];
    }
}



-(void)dealloc{
    _menuArray = nil;
    _myDelegate = nil;
}
/*
 使用方法
 #import "ViewController.h"
 
 #import "HorizontalMenuView.h"  //1.包含头文件
 
 @interface ViewController ()<HorizontalMenuProtocol>   //2.添加协议委托代理
 
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     
 //3.创建并初始化，添加至视图
     HorizontalMenuView *menuView = [[HorizontalMenuView alloc]init];
     menuView.frame = CGRectMake(0, 80,self.view.frame.size.width,45 );
     menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
     [self.view addSubview:menuView];
 //4.设置菜单名数组
     NSArray *menuArray = [NSArray arrayWithObjects:@"今日最新",@"今日推荐",@"全部", nil];
     [menuView setNameWithArray:menuArray];
 //5.设置委托代理
     menuView.myDelegate=self;
 
 }
 //6.实现协议方法
 -(void)getTag:(NSInteger)tag{
     NSLog(@"菜单%ld",tag);
 }
 
 */

@end
