//
//  XDYCheckGroup.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/5/5.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "XDYCheckGroup.h"

@implementation XDYCheckGroup

-(id)initWithFrame:(CGRect)frame WithCheckBtns:(NSArray *)checkBtns
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectTextArr=[[NSMutableArray alloc]init];
        _selectValueArr=[[NSMutableArray alloc]init];
        for (XDYChooseBtnAndTitle *checkBtn in checkBtns) {
            checkBtn.delegate = self;
            [self addSubview:checkBtn];
        }

    }
    return self;
}
-(void)selectBtn:(UIButton *)sender{

    if (self.isCheck) {
        sender.selected = !sender.selected;
        if (sender.selected) {

        [_selectValueArr addObject:[NSNumber numberWithInteger:sender.tag]];
     
            
            
        }else{
          
        [_selectValueArr removeObject:[NSNumber numberWithInteger:sender.tag]];
        
        }
        
        
    }else{
        
        for (id checkBtn in self.subviews) {
            if ([checkBtn isKindOfClass:[XDYChooseBtnAndTitle class]]) {
                [(XDYChooseBtnAndTitle *)checkBtn setIsSelect:NO];
            }
        }
        
        [_selectValueArr removeAllObjects];
        
         sender.selected=YES;
        
        [_selectValueArr addObject:[NSNumber numberWithInteger:sender.tag]];

    }
        
    

}

- (void)removeAllCheckBtn{
    for (UIView *checkBtn in self.subviews) {
        [checkBtn removeFromSuperview];
        
    }
}
@end
