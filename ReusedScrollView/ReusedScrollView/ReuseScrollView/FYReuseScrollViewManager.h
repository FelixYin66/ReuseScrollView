//
//  FYReuseScrollViewManager.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYReuseScrollView.h"

@interface FYReuseScrollViewManager : NSObject <FYReuseScrollViewDateSource, FYReuseScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, weak) FYReuseScrollView *reuseScrollView;
@property (nonatomic, assign) CGFloat margin;

- (id)initWithReuseScrollView:(FYReuseScrollView *)reuseScrollView;

@end
