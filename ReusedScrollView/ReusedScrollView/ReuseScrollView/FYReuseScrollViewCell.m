//
//  FYReuseScrollViewCell.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "FYReuseScrollViewCell.h"
#import "FYReuseScrollView.h"

@interface FYReuseScrollViewCell()

@end

@implementation FYReuseScrollViewCell

//从缓存池中获取cell,没有的话就创建一个

+ (id)cellWithReuseScrollView:(FYReuseScrollView *)reuseScrollView{
    static NSString *cellID = @"ReuseCell";
    FYReuseScrollViewCell *cell = [reuseScrollView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FYReuseScrollViewCell alloc] init];
        cell.identifier = cellID;
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    return cell;
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}


//将内容视图添加到cell中

- (void)setpageViewInCell:(UIView *)pageView{
    
    if (self.subviews.count) {
        
        //向集合中的每一个对象都发送removeFromSuperview消息，移除所有的子视图，以保证拿到的是一个空cell
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    }
    
    //将内容视图添加到cell中
    
    [self addSubview:pageView];
}


- (void)layoutSubviews{
    
    //获取内容视图
    
    UIView *pageView =  self.subviews[0];
    
    //设置内容视图的frame为cell的frame
    
    pageView.frame = self.bounds;
}
@end

