//
//  FYNaviScrollView.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYReuseScrollView.h"

@interface FYNaviScrollView : UIScrollView


@property (nonatomic, copy) NSString *currentTitle;

@property (nonatomic, weak) FYReuseScrollView *reuseScrollView;
@property (nonatomic, weak) UIButton *currectItem;
@property (nonatomic, weak) UIButton *oldItem;
@property (nonatomic, strong) NSMutableArray *itemKeys;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;


@property (nonatomic, assign) BOOL isGraduallyChangColor;
@property (nonatomic, assign) BOOL isGraduallyChangFont;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) NSInteger minFontSize;
@property (nonatomic, assign) NSInteger maxFontSize;


@end
