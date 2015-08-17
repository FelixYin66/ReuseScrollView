//
//  FYReuseScrollViewCell.h
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYReuseScrollView;

@interface FYReuseScrollViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

+ (instancetype)cellWithReuseScrollView:(FYReuseScrollView *)reuseScrollView;
- (void)setpageViewInCell:(UIView *)pageView;

@end