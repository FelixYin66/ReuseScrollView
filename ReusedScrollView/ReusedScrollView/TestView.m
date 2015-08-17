//
//  TestView.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "TestView.h"
#import "UIView+Extension.h"

@implementation TestView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:65];
        
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
        
        self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.width = self.width;
    self.label.height = self.height;
    self.label.x = 0;
    self.label.y = 0;
}

@end
