//
//  NSMutableArray+InsertArray.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/6/6.
//  Copyright © 2017年 liyanyan. All rights reserved.
//

#import "NSMutableArray+InsertArray.h"

@implementation NSMutableArray (InsertArray)
- (void)insertArray:(NSArray *)newAdditions atIndex:(NSUInteger)index
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(int i = (int)index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}
@end
