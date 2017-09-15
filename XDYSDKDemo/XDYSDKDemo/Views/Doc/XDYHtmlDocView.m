//
//  XDYHtmlDocView.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYHtmlDocView.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface XDYHtmlDocView ()<UIWebViewDelegate>
{
    BOOL initflag;
    BOOL initDoc;
    
    
}
@property (nonatomic, weak) JSContext              *context;     //js交互信息
@property (strong, nonatomic) UIWebView            *docWebView;
@property (nonatomic, strong) UIImageView          *docLayerView;

@end

@implementation XDYHtmlDocView




-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _docWebView = [[UIWebView alloc]init];
        [self addSubview:_docWebView];
        
        _drawView = [[XDYDrawView alloc]init];
        [_docWebView addSubview:_drawView];
        
        _docLayerView = [[UIImageView alloc]init];
        [_docWebView addSubview:_docLayerView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    initflag = true;
    initDoc = true;
    _docLayerView.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    float x = 0;
    float height = self.frame.size.width/4*3;
    float y = (self.frame.size.height - height)/2;
    _drawView.frame = CGRectMake(x, y, self.frame.size.width, height);
    _docWebView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _docWebView.scrollView.bounces=NO;
    _docWebView.delegate = self; 
}
-(void)setCursorX:(CGFloat)x Y:(CGFloat)y{
    [_drawView setCursorX:x Y:y];
    
}
- (void)loadDOCServerIP:(NSString *)ip{
    int random = arc4random() % 10000;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://pclive.xuedianyun.com/app/index.html?%d",random]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_docWebView loadRequest:request];
}
- (void)setSrc:(NSString *)url{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"src", nil];
    [self sendMessage:@"0" message:dic];
    initDoc = true;

}

- (void)prePage{
    [self sendMessage:@"1" message:nil];//上一页
}

- (void)nextPage{
     [self sendMessage:@"2" message:nil];//下一页
}

- (void)jumpPage:(int)num{
    NSNumber *pageNum = [NSNumber numberWithInt:num];
    [self sendMessage:@"3" message:@{@"current":pageNum}];//指定页码
   
}

- (void)preStep{
    [self sendMessage:@"4" message:nil];//上一步
}

- (void)nextStep{
    [self sendMessage:@"5" message:nil];//下一步
}

#pragma mark - 向js发送消息
- (NSString *)sendMessage:(NSString *)type message:(NSDictionary *)message{
    
    NSString * jsonString;
    if (message != nil) {
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }else{
        
        jsonString = @"";
        
    }
    
    
    
    NSString *str = [NSString stringWithFormat:@"_native2js('%@','%@')",type,jsonString];
    
    NSString *obj = [_docWebView stringByEvaluatingJavaScriptFromString:str];
    
    
    return obj;
    
}
#pragma mark - webView代理方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType//开始相应请求触发
{
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView//开始加载网页
{
}
#pragma mark - 接收js发送的消息
-(void)webViewDidFinishLoad:(UIWebView *)webView//加载完毕
{
    
    if (initflag) {//加载js成功后给用户返回，此时才允许用户做相应操作
        initflag = false;
        _XDYDocBlock(@"success",@"1");
    }

    _context = [_docWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _context[@"_js2native"] = ^(){//此处为js调用返回相应的数据（目前为两个参数）
    
        //这个地方取到的值是jsvalue  而不是nsstring 如果需要做判断需要进行转类型
        NSArray *args = [JSContext currentArguments];
        JSValue *block = args[0];
        NSString *msg =  block.toString;
        
        NSDictionary *msgDic = [self dictionaryWithJsonString:msg];
        int slideIndex = [msgDic[@"slideIndex"] intValue];
        if (initDoc) {//加载js成功后给用户返回，此时才允许用户做相应操作
            initDoc = false;
            _XDYDocBlock(@"loadDocSuccess",[NSString stringWithFormat:@"%d",slideIndex]);
            
        }else{
            _XDYDocBlock(@"slideIndex",[NSString stringWithFormat:@"%d",slideIndex]);
        }
        
        
    };
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return  nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        return nil;
    }
    return dic;
}

- (void)getMessageXDYDocBlock:(BLOCK)XDYDocBlock{
    _XDYDocBlock = XDYDocBlock;
}



- (void)setWriteBoard:(NSDictionary *)message
       annotaionArray:(void(^)(id data))annotationArray{
    
    if ([message[@"isFresh"] boolValue]) {
        //清空画面
        [self.drawView clearScreen];
        
    }
    
    NSArray *anno = message[@"annotaionItems"];
    for (int i = 0; i<anno.count; i++) {
        
        NSString *color = anno[i][@"color"];
        CGFloat lineWidth = [anno[i][@"thickness"] floatValue];
        NSArray *pointGroup = anno[i][@"pointGroup"];
        
        //                        if ((initiator !=_nodeId) && [message[@"isFresh"]boolValue]) {
        NSMutableArray *pointArray = [NSMutableArray array];
        for (int j = 0; j<pointGroup.count; j++) {
            
            NSDictionary *dic = pointGroup[j];
            float x = [dic[@"w"] floatValue]/100.0 * CGRectGetWidth(self.frame);
            float y = [dic[@"h"] floatValue]/100.0 * CGRectGetWidth(self.frame);
            
            [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            
        }
        
        [self.drawView drawPath:pointArray drawColor:XDYHexColor(color) lineWidth:lineWidth];
        
    }
    annotationArray(anno);
}

- (void)catchJsLog{
    
//    JSContext *ctx = [_docWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
//    ctx[@"console"][@"log"] = ^(JSValue * msg) {
//        Log(@"log : %@", msg);
//    };
//    
//    ctx[@"console"][@"warn"] = ^(JSValue * msg) {
//        NSLog(@"warn : %@", msg);
//    };
//    
//    ctx[@"console"][@"error"] = ^(JSValue * msg) {
//        NSLog(@"error : %@", msg);
//    };
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
