//
//  HMComposeToolbar.m
//  黑马微博
//
//  Created by apple on 14-7-10.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#import "HMComposeToolbar.h"
//#import "BundleTools.h"

@interface HMComposeToolbar()

@property (nonatomic, weak) UIButton *emotionButton;
@property (nonatomic, weak) UIButton *pictrueButton;

@end

@implementation HMComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"XDYEmoji.bundle/compose_toolbar_background"]];
       
        // 添加所有的子控件
        self.emotionButton = [self addButtonWithIcon:@"facenormal" highIcon:@"facenormal" tag:HMComposeToolbarButtonTypeEmotion];
        self.pictrueButton = [self addButtonWithIcon:@"photo-normal" highIcon:@"photo-hover" tag:HMComposeToolbarButtonTypePictrue];
        
        [self addButtonWithIcon:@"sendnormal" highIcon:@"sendpress" tag:HMComposeToolbarButtonTypeMention];
        
        
    }
    return self;
    
}

- (void)setShowEmotionButton:(BOOL)showEmotionButton
{
    _showEmotionButton = showEmotionButton;
    if (showEmotionButton) { // 显示表情按钮
        [self.emotionButton setImage:[UIImage imageNamed:@"facepress"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"facepress"] forState:UIControlStateHighlighted];
    } else { // 切换为键盘按钮
        [self.emotionButton setImage:[UIImage imageNamed:@"facenormal"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"facenormal"] forState:UIControlStateHighlighted];
    }
}
- (void)setShowPictrueButton:(BOOL)showPictrueButton{
    _showEmotionButton = showPictrueButton;
    if (showPictrueButton) {
        [self.pictrueButton setImage:[UIImage imageNamed:@"photo-normal"] forState:UIControlStateNormal];
    }else{
        [self.pictrueButton setImage:[UIImage imageNamed:@"photo-hover"] forState:UIControlStateNormal];
    }
}


/**
 *  添加一个按钮
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(HMComposeToolbarButtonType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int)self.subviews.count;
    CGFloat buttonW = 38;
    CGFloat buttonH = self.height;
    
    for (int i = 0; i<count; i++) {
        if (i == 0 ) {
            UIButton *button = self.subviews[i];
            button.y = 0;
            button.width = buttonW;
            button.height = buttonH;
            button.x = 2;
        
        }else if(i == 1){
            UIButton *button = self.subviews[i];
            button.y = 0;
            button.width = buttonW;
            button.height = buttonH;
            button.x = buttonW;
            
        }else if(i==2){
            UIButton *button = self.subviews[i];
            button.y = 0;
            button.width = buttonW;
            button.height = buttonH;
            button.x = self.width-buttonW-2;
        }
        
    }
    
}
@end
