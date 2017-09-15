//
//  XDYGetLabelRect.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/30.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYGetLabelRect.h"

@implementation XDYGetLabelRect
#pragma mark - 根据文字获取Label的实时大小
+ (CGRect)getAttributedStringHeight:(NSString*)strDes andSpaceWidth:(CGFloat)fWidth andFont:(UIFont*)font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[strDes dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [attributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     font,
                                     NSFontAttributeName,
                                     [UIColor grayColor],
                                     NSForegroundColorAttributeName,nil]
                              range:NSMakeRange(0, attributedString.length)];
    
    UITextView *temp = [[UITextView alloc]initWithFrame:CGRectMake(100.0f, 100.0f, [UIScreen mainScreen].bounds.size.width - fWidth, 1)];
    [temp setBackgroundColor:[UIColor whiteColor]];
    temp.textColor = [UIColor grayColor];
    temp.font = font;
    [temp setEditable:NO];
    [temp setScrollEnabled:NO];
    temp.attributedText = attributedString;
    // 计算 text view 的高度
    CGRect textSize;
    textSize = temp.bounds;
    // 计算 text view 的高度
    CGSize maxSize=CGSizeMake(textSize.size.width,CGFLOAT_MAX);
    CGSize newSize1=[temp sizeThatFits:maxSize];
    textSize.size = newSize1;
    //XNLog(@"%f",temp.contentSize.height);
    return textSize;
}

@end
