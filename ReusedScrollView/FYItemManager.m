//
//  FYItemManager.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "FYItemManager.h"

@interface FYItemManager()
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation FYItemManager

- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

+ (id)shareitemManager{
    
    static FYItemManager *manger = nil;
    if (manger == nil) {
        manger = [[FYItemManager alloc]init];
    }
    
    return manger;
}

- (void)setItemTitles:(NSMutableArray *)titles{
    _titles = titles;
    self.scrollNavBar.itemKeys = titles;
}

- (void)removeTitle:(NSString *)title{
    [self.titles removeObject:title];
}

@end
