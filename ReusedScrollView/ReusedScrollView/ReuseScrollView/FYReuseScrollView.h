//
//  FYReuseScrollView.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYReuseScrollViewCell.h"

typedef enum{
    FYReuseScrollViewMarginTypeTop,
    FYReuseScrollViewMarginTypeBottom,
    FYReuseScrollViewMarginTypeLeft,
    FYReuseScrollViewMarginTypeRight
} FYReuseScrollViewMarginType;

@class FYReuseScrollView;

/**
 * reuseScrollView的数据方法
 */
@protocol FYReuseScrollViewDateSource <NSObject>

@required

- (NSUInteger)numberOfCellInReuseScrollView:(FYReuseScrollView *)reuseScrollView;
- (FYReuseScrollViewCell *)reuseScrollView:(FYReuseScrollView *)reuseScrollView AtIndex:(NSUInteger)index;

@end

/**
 * reuseScrollView的代理方法
 */
@protocol FYReuseScrollViewDelegate <NSObject>
@optional
- (void)reuseScrollView:(FYReuseScrollView *)reuseScrollView didSelectAtIndex:(NSUInteger)index;

- (CGFloat)reuseScrollView:(FYReuseScrollView *)reuseScrollView marginForType:(FYReuseScrollViewMarginType)type;
@end

@interface FYReuseScrollView : UIScrollView

@property (nonatomic, weak) id <FYReuseScrollViewDateSource>reuseScrollViewDateSource;
@property (nonatomic, weak) id <FYReuseScrollViewDelegate>reuseScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, assign) CGFloat margin;

- (void)reloadPageViews;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
