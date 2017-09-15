//
//  XDYDrawView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/3/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYDrawView.h"
#import "XDYDrawPath.h"


@interface XDYDrawView ()

@property (nonatomic, assign) BOOL openDraw;

@property (assign, nonatomic)CGFloat lineWidth;

@property (strong, nonatomic)UIColor *drawColor;

@property (strong, nonatomic)UIImage *image;

//当前绘图路径
@property (assign, nonatomic)CGMutablePathRef drawPath;
//绘图路径数组
@property (strong, nonatomic)NSMutableArray *drawPathArray;
//路径是否被释放
@property (assign, nonatomic)BOOL pathReleased;

@property (nonatomic, strong) NSMutableArray *ownerDrawPathArray;

@end

@implementation XDYDrawView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        //设置属性值
        self.openDraw = false;
        self.lineWidth = 2.0;
        self.drawColor = kUIColorFromRGB(0x0071bc);
        
        _cursorView = [[UIView alloc]init];
        [self addSubview:_cursorView];
    }
    return self;
}

-(void)layoutSubviews{
    
    _cursorView.frame = CGRectMake(0, 0, 10, 10);
    _cursorView.backgroundColor=[UIColor redColor];
    //v.layer.masksToBounds=YES;这行去掉
    _cursorView.layer.cornerRadius=5;
    _cursorView.layer.shadowColor=[UIColor redColor].CGColor;
    _cursorView.layer.shadowOffset=CGSizeMake(0, 0);
    _cursorView.layer.shadowOpacity=0.8;
    _cursorView.layer.shadowRadius=5;
    _cursorView.hidden =YES;
    
}

#pragma mark - 绘制视图
//注意：drawRect方法每次都是完整的绘制视图中需要绘制部分内容
-(void)drawRect:(CGRect)rect
{
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
#pragma mark - 绘图视图内容的方法
-(void)drawView:(CGContextRef)context
{
    //--------------------------------------
    //首先将绘图数组中的路径全部绘制出来
    for(XDYDrawPath *path in self.drawPathArray){

        @try
        {
            CGContextAddPath(context, path.drawPath.CGPath);
            
        }@catch (NSException * e) {
           
        }
        
        [path.drawColor set];
        CGContextSetLineWidth(context, path.lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);

    }
    
    //--------------------------------------
    //以下代码绘制当前路径的内容，就是手指还没有离开屏幕
    //内存管理部分提到，所有create创建的都要release，而不能设置成NULL
    if (!self.pathReleased) {
        //1.添加路径
        CGContextAddPath(context, self.drawPath);
        //2.设置上下文属性
        [self.drawColor set];
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        //3.绘制路径
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)setDrawColor:(UIColor *)color{
    _drawColor = color;
}

- (void)openDrawlineWidth:(CGFloat)lineWidth{
    _openDraw = true;
    _lineWidth = lineWidth;
    
}
- (void)closeDraw{
    _openDraw = false;
}

- (void)drawPath:(NSArray *)pathArray drawColor:(UIColor *)drawColor lineWidth:(CGFloat)lineWidth{
    
    for (int i = 0; i<pathArray.count; i++) {
        NSValue *val = [pathArray objectAtIndex:i]; //例如取出第一项
        CGPoint point = [val CGPointValue];
        
        if (i == 0) {
            self.drawPath = CGPathCreateMutable();
            
            //记录路径没有被释放
            self.pathReleased = NO;
            
            //在路径中记录触摸的初始点
            CGPathMoveToPoint(self.drawPath, NULL, point.x, point.y);
            
        }else{
            
            //将触摸点添加至路径
            CGPathAddLineToPoint(self.drawPath, NULL, point.x, point.y);
            
            [self setNeedsDisplay];
        }
    }
    if (self.drawPathArray == nil) {
        self.drawPathArray = [NSMutableArray array];
    }
    //要将CGPathRef添加到NSArray之中，需要借助贝塞尔曲线对象
    //贝塞尔曲线时UIKit对CGPathRef的一个封装，贝塞尔路径的对象可以直接添加到数组
    //UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.drawPath];
    
    XDYDrawPath *path = [XDYDrawPath drawPathWithCGPath:self.drawPath color:drawColor lineWidth:lineWidth];
    
    //需要记录当前绘制路径的颜色和线宽
    [self.drawPathArray addObject:path];
    
    
    //    [self setNeedsDisplay];
    
//    CGPathRelease(self.drawPath);
    
    //记录路径被释放
    self.pathReleased = YES;
    
}


#pragma mark - 触摸事件
#pragma mark - 触摸开始，创建绘图路径
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_openDraw) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        self.drawPath = CGPathCreateMutable();
        //记录路径没有被释放
        self.pathReleased = NO;
        //在路径中记录触摸的初始点
        if (!isnan(location.x) && !isnan(location.y)){
           CGPathMoveToPoint(self.drawPath, NULL, location.x, location.y);
        }
    }
    
}
#pragma mark - 移动过程中，将触摸点不断添加到绘图路径
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_openDraw) {
        //可以获取用户当前触摸的点
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        
        //将触摸点添加至路径
        if (!isnan(location.x) && !isnan(location.y)){
            
                CGPathAddLineToPoint(self.drawPath, NULL, location.x, location.y);
            
            
        }
        [self setNeedsDisplay];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",location.x / self.frame.size.width *100],@"w",[NSString stringWithFormat:@"%.2f",location.y / self.frame.size.width *100],@"h", nil];
        
        [self.ownerDrawPathArray addObject:dic];
    }
}

#pragma mark - 触摸结束，释放路径
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_openDraw) {
        //一笔画完之后将完整的路径添加到路径数组中
        //使用数组的懒加载
        if (self.drawPathArray == nil) {
            self.drawPathArray = [NSMutableArray array];
        }
        //要将CGPathRef添加到NSArray之中，需要借助贝塞尔曲线对象
        //贝塞尔曲线时UIKit对CGPathRef的一个封装，贝塞尔路径的对象可以直接添加到数组
        //UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.drawPath];
        
        XDYDrawPath *path = [XDYDrawPath drawPathWithCGPath:self.drawPath color:self.drawColor lineWidth:self.lineWidth];
        
        //需要记录当前绘制路径的颜色和线宽
        [self.drawPathArray addObject:path];
        
//        CGPathRelease(self.drawPath);
        
        //记录路径被释放
        self.pathReleased = YES;
        
        //测试线宽的代码
        //self.lineWidth = arc4random() % 20 + 1.0;
        
        if ([self.delegate respondsToSelector:@selector(XDYDrawrawPath:drawColor:drawWidth:)]) {
            [self.delegate XDYDrawrawPath:self.ownerDrawPathArray drawColor:_drawColor drawWidth:_lineWidth];
        }
        _ownerDrawPathArray = nil;
    }
}

#pragma mark - 工具视图执行方法
-(void)undoStep
{
    //在执行撤销操作时，当前没有绘图路径
    //要做撤销操作，需要把路径数组中最后一条路径删除
    [self.drawPathArray removeLastObject];
    
    [self setNeedsDisplay];
}

-(void)clearScreen
{
    //在执行清屏操作时，当前没有绘图路径
    //要做清屏操作，只要把路径数组清空即可
    if (self.drawPathArray.count>0) {
        
        [self.drawPathArray removeAllObjects];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - image的setter方法
-(void)setImage:(UIImage *)image
{
    /*目前绘图的方法：
     1.用self.drawPathArray记录已经完成（抬起手指）的路径
     2.用self.drawPath记录当前正在拖动中的路径
     
     绘制时，首先绘制self.drawPathArray，然后再绘制self.drawPath
     
     image传入时，drawPath没有被创建（被release但不是NULL）
     
     如果，
     1.将image也添加到self.drawPathArray（DrawPath）
     2.在绘图时，根据是否存在image判断是否绘制路径还是图像，就可以
     实现用一个路径数组即绘制路径，又绘制图像的目的
     
     之所以要用一个数组，时因为绘图是有顺序的
     
     接下来，首先需要扩充DrawPath，使其支持image
     */
    //1.实例化一个新的DrawPath
    XDYDrawPath *path = [[XDYDrawPath alloc]init];
//    [path setImage:image];
    
    //2.将其添加到self.drawPathArray，这个数组是懒加载
    if (self.drawPathArray == nil) {
        self.drawPathArray = [NSMutableArray array];
    }
    
    [self.drawPathArray addObject:path];
    
    //3.重绘
    [self setNeedsDisplay];
}
- (NSMutableArray *)ownerDrawPathArray{
    if (!_ownerDrawPathArray) {
        _ownerDrawPathArray = [NSMutableArray array];
    }
    return _ownerDrawPathArray;
}


-(void)setCursorX:(CGFloat)x Y:(CGFloat)y{
    
    _cursorView.frame = CGRectMake(x, y, 10, 10);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
