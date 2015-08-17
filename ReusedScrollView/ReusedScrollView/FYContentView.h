//
//  FYContentView.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYContentView : UIView

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;



@property (nonatomic, assign) BOOL isGraduallyChangColor;
@property (nonatomic, assign) BOOL isGraduallyChangFont;
@property (nonatomic, assign) NSInteger minFontSize;
@property (nonatomic, assign) NSInteger maxFontSize;
@property (nonatomic, assign) NSInteger defFontSize;
@property (nonatomic, assign) CGFloat reuseScrollViewHeight;

@end
