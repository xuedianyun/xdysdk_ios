//
//  CharacterLimit.h
//  XDYSDK
//
//  Created by lyy on 16/9/12.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringLimit : NSObject

/**
 *将字符串中的单引号、双引号修改成
 **/
+ (NSString *)stringConver:(NSString *)string;

/**
 *用于限制用户的位数
 **/
+ (NSString *)stringAtIndexByCount:(NSString *)string withCount:(NSInteger)count;
/**
 *用于获取文档当前页地址
 **/
+ (NSString *)loadDocUrl:(NSString *)docUrl DocName:(NSString *)docName DocCurPageNum:(NSString *)curPageNum;


+ (NSString *)loadDocUrl:(NSString *)url curPageNum:(int)num;

@end
