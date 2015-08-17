//
//  FYReuseScrollView.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//
#import "FYReuseScrollView.h"
#import "UIView+Extension.h"
#import "FYReuseScrollViewManager.h"

#define FYReuseScrollViewDefaultMargin 0

@interface FYReuseScrollView()

@property (nonatomic, strong) NSMutableArray *pageViewFrames;
@property (nonatomic, strong) NSMutableDictionary *displayingPageViews;
@property (nonatomic, strong) NSMutableSet *reusePageViews;
@property (nonatomic, strong) FYReuseScrollViewManager *manager;
@end

@implementation FYReuseScrollView


#pragma mark ------懒加载

- (NSMutableArray *)pageViewFrames{
    
    if (!_pageViewFrames) {
        _pageViewFrames = [NSMutableArray array];
    }
    
    return _pageViewFrames;
    
}

- (NSMutableDictionary *)displayingPageViews{
    if (!_displayingPageViews) {
        _displayingPageViews = [NSMutableDictionary dictionary];
    }
    return _displayingPageViews;
}


- (NSMutableSet *)reusePageViews{
    
    if (!_reusePageViews) {
        _reusePageViews = [NSMutableSet set];
    }
    
    return _reusePageViews;
    
}


- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    self.manager.pageViews = pageViews;
}

- (void)setMargin:(CGFloat)margin{
    _margin = margin;
    self.manager.margin = margin;
}


//初始化FYReuseScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [[FYReuseScrollViewManager alloc]initWithReuseScrollView:self];
        self.reuseScrollViewDateSource = _manager;
        self.reuseScrollViewDelegate = _manager;
    }
    
    return self;
}



//清除所有缓存数据

- (void)cleanDate{
    
    //让父视图释放子视图引用
    [self.displayingPageViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //再从字典移除所有元素(放弃所有元素的引用)
    [self.displayingPageViews removeAllObjects];
    
    //移除所有子视图frame缓存
    [self.pageViewFrames removeAllObjects];
    
    //移除所有重用的子视图
    [self.reusePageViews removeAllObjects];
    
}


//计算cell的frame，并缓存起来

- (void)reloadPageViews{
    
    [self cleanDate];
    
    NSUInteger numberOfCells = [self.reuseScrollViewDateSource numberOfCellInReuseScrollView:self];
    
    if (numberOfCells == 0 || self.width == 0 || self.height == 0) return;
    
    //计算cell的边距
    CGFloat topMargin = [self marginForType:FYReuseScrollViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:FYReuseScrollViewMarginTypeBottom];
    CGFloat leftMargin = [self marginForType:FYReuseScrollViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:FYReuseScrollViewMarginTypeRight];
    
    //计算cell的frame
    CGFloat cellWidth = self.width - leftMargin - rightMargin;
    CGFloat cellHeght = self.height - topMargin - bottomMargin;
    CGFloat cellY = topMargin;
    
    for (int i = 0; i < numberOfCells; i++) {
        
        CGFloat cellX = i * (self.width) + leftMargin;
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeght);
        NSValue *cellFrameValue = [NSValue valueWithCGRect:cellFrame];
        
        //缓存每一个cell的frame
        [self.pageViewFrames addObject:cellFrameValue];
    }
    self.contentSize = CGSizeMake(self.width * numberOfCells, 0);
}


//从缓存池中获取cell

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    
    __block FYReuseScrollViewCell *reusableCell = nil;
    [self.reusePageViews enumerateObjectsUsingBlock:^(FYReuseScrollViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    //清除之前缓存的cell，避免重复叠加
    
    if (reusableCell) {
        [self.reusePageViews removeObject:reusableCell];
    }
    return reusableCell;
}

//获取外边距

- (CGFloat)marginForType:(FYReuseScrollViewMarginType)type
{
    if ([self.reuseScrollViewDelegate respondsToSelector:@selector(reuseScrollView: marginForType:)]) {
        return [self.reuseScrollViewDelegate reuseScrollView:self marginForType:type];
    } else {
        return FYReuseScrollViewDefaultMargin;
    }
}

/**
 *  判断cell是否显示在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame
{
    
    return (CGRectGetMaxX(frame) > self.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.contentOffset.x + self.bounds.size.width);
}


//注意：一开始此方法会被调用两次，在reloadPageView后会被调用一次，是第一次，最后还会被吊用一次

//拽动期间 displayingPageViews 中最多两个cell，因为最多显示两个cell,所以在打印的时候会出现相同的情况输出多次

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSUInteger numberOfCells = self.pageViewFrames.count;
    
    for (int i = 0; i < numberOfCells; i++) {
        
        CGRect cellFrame = [self.pageViewFrames[i] CGRectValue];
        
        //记录当前显示的cell，当显示到下一个cell时，移除上一次的cell
        
        FYReuseScrollViewCell *cell = self.displayingPageViews[@(i)];
        
        //查看cellFrame与self.contentOffSet.x
        
        if ([self isInScreen:cellFrame]) {
            
            if (cell == nil) {
                
                //当没有时创建一个cell，当有缓存cell时从缓存池中获取
                
                cell = [self.reuseScrollViewDateSource reuseScrollView:self AtIndex:i];
                
                //设置cell的frame,之后会调用cell的layoutSubView
                
                cell.frame = cellFrame;
                
                //重新计算cell的frame与cell中内容视图的frame
                
                [cell layoutIfNeeded];
                
                [self addSubview:cell];
                
                // 存放到字典中
                
                self.displayingPageViews[@(i)] = cell;
                
                return;
                
            }
            
        }else{
            
            //移除的cell需要达到两个条件，第一 cell不在屏幕中，第二 cell是缓存在displayingPageViews
            
            if (cell) {
                
                // 从scrollView和字典中移除
                [cell removeFromSuperview];
                
                [self.displayingPageViews removeObjectForKey:@(i)];
                
                // 将消失的cell存放进缓存池
                [self.reusePageViews addObject:cell];
            }
            
        }
    }
}

@end

