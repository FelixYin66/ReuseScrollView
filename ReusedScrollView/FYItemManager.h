//
//  FYItemManager.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYNaviScrollView.h"

@interface FYItemManager : NSObject

@property (nonatomic, weak) FYNaviScrollView *scrollNavBar;

+ (id)shareitemManager;

- (void)setItemTitles:(NSMutableArray *)titles;
- (void)removeTitle:(NSString *)title;

@end
