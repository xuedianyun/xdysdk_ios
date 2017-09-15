//
//  XDY_PhotoListCell.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//



#import "XDY_PhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XDY_Asset.h"
#define kCellHeight     (80.0)
#define kPad            (5.0)
#define kCircleRadius   (10.0)
@interface XDY_PhotoListCell (){
    NSArray          *  assetGroup;
    NSMutableArray   *  overlayImageArr;
    NSMutableArray   *  imageViewArr;
    UIImage          *  overlayImage;
    CGFloat             imageWidth;
}

@end

@implementation XDY_PhotoListCell

+ (CGFloat)cellHeight{
    return kCellHeight;
}

- (void)makeOverlayImageWithWidth:(CGFloat)width{
    if(overlayImage == nil){
        UIGraphicsBeginImageContext(CGSizeMake(width, kCellHeight - kPad));
        CGContextRef  context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor);
        CGContextAddRect(context, CGRectMake(0.0, 0.0, width, kCellHeight - kPad));
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextSetLineWidth(context, 1.5);
        CGContextAddArc(context, width - kPad - kCircleRadius, kCellHeight - kPad * 2.0 - kCircleRadius, kCircleRadius, 0, M_PI * 2.0, NO);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, width - kCircleRadius * 2.0 , kCellHeight - kPad * 2.0 - kCircleRadius);
        CGContextAddLineToPoint(context, width - kPad - kCircleRadius, kCellHeight - kPad * 3.0);
        CGContextAddLineToPoint(context, width - kPad * 2.0, kCellHeight - kPad * 3.0 - kCircleRadius);
        CGContextDrawPath(context, kCGPathStroke);
        CGContextRestoreGState(context);
        
        overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UITapGestureRecognizer  * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellForTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        
        imageViewArr = [NSMutableArray array];
        overlayImageArr = [NSMutableArray array];
    }
    return self;
}

-(void)setAssets:(NSArray*)assets{
    imageWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - (_listColumn + 1) * kPad) / _listColumn;
    [self makeOverlayImageWithWidth:imageWidth];
    assetGroup = assets;
    for (UIImageView  * iv in imageViewArr) {
        [iv removeFromSuperview];
    }
    for (UIImageView * iv in overlayImageArr) {
        [iv removeFromSuperview];
    }
    NSInteger  count = assetGroup.count;
    for (NSInteger i = 0; i < count; i++) {
        XDY_Asset  * whcAS = assetGroup[i];
        if(i < imageViewArr.count){
            UIImageView  * tempImageView = imageViewArr[i];
            tempImageView.image = [UIImage imageWithCGImage:whcAS.asset.thumbnail];
        }else{
            UIImageView  * tempImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:whcAS.asset.thumbnail]];
            [imageViewArr addObject:tempImageView];
        }
        if(i < overlayImageArr.count){
            UIImageView  * tempOverlayImageView = overlayImageArr[i];
            tempOverlayImageView.hidden = !whcAS.selected;
        }else{
            UIImageView  * tempOverlayImageView = [[UIImageView alloc]initWithImage:overlayImage];
            tempOverlayImageView.hidden = !whcAS.selected;
            [overlayImageArr addObject:tempOverlayImageView];
        }
    }
}

-(void)layoutSubviews{
    NSInteger  count = assetGroup.count;
    CGFloat  width = (CGRectGetWidth([UIScreen mainScreen].bounds) - (_listColumn + 1) * kPad) / _listColumn;
    for (NSInteger i = 0; i < count; i++) {
        UIImageView  * imageView = imageViewArr[i];
        imageView.frame = CGRectMake(i * width + (i + 1) * kPad, kPad, width, kCellHeight - kPad);
        [self addSubview:imageView];
        
        UIImageView  * overlayImageView = overlayImageArr[i];
        overlayImageView.frame = CGRectMake(i * width + (i + 1) * kPad, kPad, width, kCellHeight - kPad);
        [self addSubview:overlayImageView];
    }
}

-(void)cellForTapGesture:(UITapGestureRecognizer *)tap{
    
    CGPoint  point = [tap locationInView:self];
    CGRect   frame = CGRectMake(kPad, kPad, imageWidth, kCellHeight - kPad);
    for (NSInteger i = 0; i < assetGroup.count; i++) {
        if(CGRectContainsPoint(frame, point)){
            BOOL  choiceState = NO;
            XDY_Asset  * whcAS = assetGroup[i];
            if(_delegate && [_delegate respondsToSelector:@selector(XDYPhotoListCurrentChoiceState:)]){
                choiceState = [_delegate XDYPhotoListCurrentChoiceState:whcAS.selected];
            }
            
            if(choiceState){
                whcAS.selected = !whcAS.selected;
                UIImageView * overlayImageView = overlayImageArr[i];
                overlayImageView.hidden = !whcAS.selected;
            }else{
                if(whcAS.selected){
                    whcAS.selected  = NO;
                    UIImageView * overlayImageView = overlayImageArr[i];
                    overlayImageView.hidden = YES;
                    if(_delegate && [_delegate respondsToSelector:@selector(XDYPhotoListCancelChoicePhoto)]){
                        [_delegate XDYPhotoListCancelChoicePhoto];
                    }
                }
            }
            break;
        }
        frame.origin.x += imageWidth + kPad;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
