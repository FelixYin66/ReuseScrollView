//
//  FYContentView.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "FYContentView.h"
#import "FYReuseScrollView.h"
#import "FYNaviScrollView.h"
#import "FYItemManager.h"
#import "UIView+Extension.h"

@interface FYContentView()<UIScrollViewDelegate>


@property (nonatomic, strong) FYReuseScrollView *reuseScrollView;
@property (nonatomic, strong) FYNaviScrollView *scrollNavBar;

@property (nonatomic, assign) CGFloat navBarH;

@end

@implementation FYContentView

#pragma -mark 懒加载



//保存主要内容scrollView

- (FYReuseScrollView *)reuseScrollView{
    if (!_reuseScrollView) {
        
        _reuseScrollView = [[FYReuseScrollView alloc]init];
        _reuseScrollView.pagingEnabled = YES;
        _reuseScrollView.backgroundColor = [UIColor purpleColor];
        
    }
    
    return _reuseScrollView;
    
}



//导航拦分类scrollView

- (FYNaviScrollView *)scrollNavBar{
    if (!_scrollNavBar) {
        _scrollNavBar = [[FYNaviScrollView alloc]init];
        _scrollNavBar.backgroundColor = [UIColor redColor];
    }
    return _scrollNavBar;
}

//设置分类导航栏内容

- (void)setPageViews:(NSMutableArray *)pageViews{
    
    _pageViews = pageViews;
    
    self.scrollNavBar.pageViews = pageViews;
    
    _scrollNavBar.reuseScrollView = self.reuseScrollView;
    
}


#pragma -mark 属性配置

//这个影响拽动

- (void)setReuseScrollViewHeight:(CGFloat)reuseScrollViewHeight{
    _reuseScrollViewHeight = reuseScrollViewHeight;
    CGRect rect = self.frame;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    if (self.navBarH == 0 ) {
        self.navBarH = h;
        h = h + self.reuseScrollViewHeight;
    }
    
    CGRect frameChanged = CGRectMake(x, y, w, h);
    
    //在这里重新设置了FYContentView的frame
    
    [self setFrame:frameChanged];
}


//通过设置FYContentView的背景色，间接设置scrollNaviBar的背景色

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    //设置self的背景色为透明，也就是clearColor
    
    [super setBackgroundColor:[UIColor clearColor]];
    
    self.scrollNavBar.backgroundColor = backgroundColor;
    
}

//设置标题

- (void)setTitles:(NSArray *)titles{
    BOOL isHaveSameTitle = [self checkisHaveSameItem:titles];
    
    NSAssert(!isHaveSameTitle, @"错误！！！不能包含相同的标题");
    
    _titles = titles;
    
    [[FYItemManager shareitemManager] setScrollNavBar:self.scrollNavBar];    //导航栏视图
    
    [[FYItemManager shareitemManager] setItemTitles:(NSMutableArray *)titles];   //导航栏标题
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    self.scrollNavBar.titleNormalColor = titleNormalColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    self.scrollNavBar.titleSelectedColor = titleSelectedColor;
}


#pragma -mark 初始化
- (void)setup{
    
    [self addSubview:self.reuseScrollView];   //主内容
    
    [self addSubview:self.scrollNavBar];    //展示可滑动的分类
    
    self.clipsToBounds = YES;
    
    self.userInteractionEnabled = YES;
    
}



// 此方法一调用，scrollNavBar首先被创建，接着reuseScrollView也被创建

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //设置reuseScrollView的frame
    
    CGFloat reuseScrollViewX = 0;
    CGFloat reuseScrollViewY = self.navBarH;
    CGFloat reuseScrollViewW = self.width;
    CGFloat reuseScrollViewH = self.reuseScrollViewHeight;
    self.reuseScrollView.frame = CGRectMake(reuseScrollViewX, reuseScrollViewY, reuseScrollViewW, reuseScrollViewH);
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.reuseScrollView reloadPageViews];
    });
    
    //设置scrollNavBar的frame
    
    CGFloat scrollX = 0;
    CGFloat scrollY = 0;
    CGFloat scrollH = _navBarH;
    CGFloat scrollW = self.width;
    self.scrollNavBar.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
}




//迭代比较一个集合中是否有相同的元素

- (BOOL)checkisHaveSameItem:(NSArray *)titles{
    for (int i = 0; i < titles.count; i++) {
        NSString *title1 = titles[i];
        for (int j = 0; j < titles.count; j++) {
            NSString *title2 = titles[j];
            if (j != i && [title1 isEqualToString:title2]) {
                return YES;
            }
        }
    }
    return NO;
}

@end

