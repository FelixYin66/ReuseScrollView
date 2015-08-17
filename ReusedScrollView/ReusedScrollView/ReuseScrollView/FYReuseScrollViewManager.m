//
//  FYReuseScrollViewManager.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "FYReuseScrollViewManager.h"
#import "FYReuseScrollViewCell.h"

@implementation FYReuseScrollViewManager

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    
    //设置pageView的时候，计算所有的cell的frame
    
    [self.reuseScrollView reloadPageViews];
}

- (id)initWithReuseScrollView:(FYReuseScrollView *)reuseScrollView{
    self = [super init];
    if (self) {
        self.reuseScrollView = reuseScrollView;
    }
    return self;
}


- (NSUInteger)numberOfCellInReuseScrollView:(FYReuseScrollView *)reuseScrollView{
    return self.pageViews.count;
}

- (CGFloat)reuseScrollView:(FYReuseScrollView *)reuseScrollView marginForType:(FYReuseScrollViewMarginType)type{
    return self.margin;
}

- (FYReuseScrollViewCell *)reuseScrollView:(FYReuseScrollView *)reuseScrollView AtIndex:(NSUInteger)index{
    
    FYReuseScrollViewCell *cell = [FYReuseScrollViewCell cellWithReuseScrollView:reuseScrollView];
    
    UIView *pageView = self.pageViews[index];
    
    //将内容视图添加到reuseScrollView中，并设置内容视图的frame
    [cell setpageViewInCell:pageView];
    
    return cell;
}


@end
