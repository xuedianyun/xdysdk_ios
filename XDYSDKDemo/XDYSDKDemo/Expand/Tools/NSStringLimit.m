//
//  CharacterLimit.m
//  XDYSDK
//
//  Created by lyy on 16/9/12.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import "NSStringLimit.h"

@implementation NSStringLimit

/**
 *将字符串中的单引号、双引号修改成
 **/
+ (NSString *)stringConver:(NSString *)string{
    NSString *con = [NSString stringWithFormat:@"%@",string];
    NSString *content = [con stringByReplacingOccurrencesOfString:@"\"" withString:@"“"];
    NSString *str = [content stringByReplacingOccurrencesOfString:@"\'" withString:@"‘"];
    
    return str;
}
+(NSString *)stringAtIndexByCount:(NSString *)string withCount:(NSInteger)count{
    int i;
    int sum=0;
    for(i=0;i<[string length];i++)
    {
        unichar str = [string characterAtIndex:i];
        if(str < 256){
            sum+=1;
        }
        else {
            sum+=2;
        }
        if(sum>count){
            //当字符大于count时，剪取三个位置，显示省略号。否则正常显示
            int i;
            int sum1=0;
            int count2=0;
            for(i=0;i<[string length];i++)
            {
                unichar str = [string characterAtIndex:i];
                if(str < 256){
                    sum1+=1;
                }
                else {
                    sum1+=2;
                }
                count2++;
                if (sum1>=count){
                    break;
                }
            }
            if(sum>count){
                count2 = count2-1;
            }
            NSString * str=[string substringWithRange:NSMakeRange(0,count2)];
            return [NSString stringWithFormat:@"%@...",str];
        }
    }
    return string;
}
+ (NSString *)loadDocUrl:(NSString *)docUrl DocName:(NSString *)docName DocCurPageNum:(NSString *)curPageNum{
    
    
    int currentPage = [curPageNum intValue];
    if (currentPage == 0) {
        currentPage = 1;
    }
    NSString *docImageUrl;
    
    NSArray *nameArray = [docName componentsSeparatedByString:@"."];
    if ([nameArray.lastObject isEqualToString:@"jpg"]||[nameArray.lastObject isEqualToString:@"png"]||[nameArray.lastObject isEqualToString:@"jpeg"]||[nameArray.lastObject isEqualToString:@"gif"]) {
        NSArray *uriarray = [docUrl componentsSeparatedByString:@"."];
        NSArray *arr = [docUrl componentsSeparatedByString:uriarray.lastObject];
        docImageUrl = [NSString stringWithFormat:@"%@%@",arr.firstObject,nameArray.lastObject];

    }else{
        NSArray *uriarray = [docUrl componentsSeparatedByString:@"/"];
        NSArray *arr = [docUrl componentsSeparatedByString:uriarray.lastObject];
        
        docImageUrl = [NSString stringWithFormat:@"%@%d.jpg",arr.firstObject,currentPage];
    }
    return docImageUrl;
}

+ (NSString *)loadDocUrl:(NSString *)url curPageNum:(int)num{
    
    
    NSArray *urlA = [[[url componentsSeparatedByString:@"["].lastObject componentsSeparatedByString:@"]"].firstObject componentsSeparatedByString:@","];
    
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (int i = 0; i<urlA.count; i++) {
      
        NSArray *str = [[NSString stringWithFormat:@"%@",urlA[i]] componentsSeparatedByString:@"\""];
        
        
        [urlArray addObject:str[1]];
    }
    
    
    return urlArray[num-1];
    
}
@end
