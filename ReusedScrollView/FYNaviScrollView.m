//
//  FYNaviScrollView.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/17.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "FYNaviScrollView.h"
#import "UIView+Extension.h"
#import "UIColor+RGBA.h"

#define ItemWidth 75
#define FontMinSize 15
#define FontDetLeSize 10
#define FontDefSize 16
#define StaticItemIndex 3


@interface FYNaviScrollView()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *firstButton;
@property (nonatomic, weak) UIButton *secButton;


@property (nonatomic, strong) NSMutableDictionary *itemsDic;
@property (nonatomic, strong) NSMutableArray *tmpKeys;

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat lastXpoint;
@property (nonatomic, assign) CGFloat red1;
@property (nonatomic, assign) CGFloat green1;
@property (nonatomic, assign) CGFloat blue1;
@property (nonatomic, assign) CGFloat alpha1;
@property (nonatomic, assign) CGFloat red2;
@property (nonatomic, assign) CGFloat green2;
@property (nonatomic, assign) CGFloat blue2;
@property (nonatomic, assign) CGFloat alpha2;
@property (nonatomic, assign) NSInteger currctIndex;
@end

@implementation FYNaviScrollView

//FYItemManager设置的itemKeys是一个title数组

- (void)setItemKeys:(NSMutableArray *)itemKeys{
    _itemKeys = itemKeys;
    //将itemKeys赋值给tmpKeys
    self.tmpKeys = itemKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //同时创建所有的item
        [self setupItems];
    });
}

- (NSMutableArray *)tmpKeys{
    if (!_tmpKeys) {
        _tmpKeys = [NSMutableArray array];
    }
    return _tmpKeys;
}


- (NSMutableDictionary *)itemsDic{
    if (!_itemsDic) {
        _itemsDic = [NSMutableDictionary dictionary];
    }
    return _itemsDic;
}


//创建单个按钮   导航栏中的item
- (UIButton *)createItemWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    
    //注意：设置按钮的背景色为透明，字体一样可以看见，由于字体颜色是white
    
    button.backgroundColor = [UIColor clearColor];
    
    //字体默认大小固定
    button.titleLabel.font = [UIFont systemFontOfSize:FontDefSize];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}



//设置reuseScrollView的代理与展示的视图

- (void)setReuseScrollView:(FYReuseScrollView *)reuseScrollView{
    _reuseScrollView = reuseScrollView;
    _reuseScrollView.delegate = self;
    _reuseScrollView.pageViews = self.pageViews;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    
    //记录设置一般情况下按钮的颜色
    
    RGBA rgba = RGBAFromUIColor(titleNormalColor);
    self.red1 = rgba.r;
    self.green1 = rgba.g;
    self.blue1 = rgba.b;
    self.alpha1 = rgba.a;
}

//记录一下选中按钮的字体颜色

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    
    //记录选中按钮的颜色
    
    RGBA rgba = RGBAFromUIColor(titleSelectedColor);
    self.red2 = rgba.r;
    self.green2 = rgba.g;
    self.blue2 = rgba.b;
    self.alpha2 = rgba.a;
}



- (void)setMinFontSize:(NSInteger)minFontSize{
    if (minFontSize > 0) {
        _minFontSize = minFontSize;
    }else{
        _minFontSize = FontMinSize;
    }
}

- (void)setMaxFontSize:(NSInteger)maxFontSize{
    if (maxFontSize > 0) {
        _maxFontSize = maxFontSize;
    }else{
        //没有设置maxFontSize时，使用默认提供的值
        _maxFontSize = FontMinSize + FontDetLeSize;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}


- (void)setup{
    
    //设置在滚动reuseScrollView时，字体颜色改变是动态的
    self.isGraduallyChangColor = YES;
    self.isGraduallyChangFont = YES;
    self.showsHorizontalScrollIndicator = NO;
    
}


//创建所有的item

- (void)setupItems{
    NSInteger itensCount = self.tmpKeys.count;
    for (NSInteger i = 0; i < itensCount; i++) {
        
        UIButton *button = [self createItemWithTitle:self.tmpKeys[i]];
        
        //将按钮保存到字典中
        
        [self.itemsDic setObject:button forKey:self.tmpKeys[i]];
        
        //设置按钮的tag值
        
        button.tag = i;
        
        if (i == 0) {
            button.selected = YES;
            [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
            if (self.maxFontSize) {
                button.titleLabel.font = [UIFont systemFontOfSize:self.maxFontSize];
            }else{
                button.titleLabel.font = [UIFont systemFontOfSize:FontDetLeSize + FontMinSize];
            }
            _currectItem = button;
        }
    }
}





//对scrollView的item进行布局处理

- (void)layoutButtons{
    
    NSInteger itemsCount = self.tmpKeys.count;
    
    CGFloat cW= itemsCount * ItemWidth;
    
    self.contentSize = CGSizeMake(cW, 0);
    
    CGFloat buttonW = ItemWidth;
    
    //当标题少的时候，button的宽度为self.with/itemsCount
    
    if (cW < self.width) {
        
        CGFloat width = self.width;
        buttonW = width / itemsCount;
        
    }
    
    //设置按钮的高度为scrollView的高度
    
    CGFloat buttonH = self.height;
    CGFloat buttonY = 0;
    
    
    //动态设置每一个button的frame
    
    for (NSInteger i = 0; i < itemsCount; i++) {
        
        if (i != itemsCount) {
            
            NSString *key = self.tmpKeys[i];
            UIButton *button = [self.itemsDic objectForKey:key];
            CGFloat buttonX = i * buttonW;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
        }
        
    }
    
    //记录按钮最后的宽度
    
    self.itemW = buttonW;
}

//布局scrollNavBar所有的子控件

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutButtons];
}



//点击item时触发的事件

- (void)buttonClick:(UIButton *)button{
    _oldItem = _currectItem;
    _currectItem.selected = NO;
    button.selected = YES;
    _currectItem = button;
    
    //计算x值需要偏移多少
    
    CGFloat offX = button.tag * self.reuseScrollView.width;
    
    [self buttonMoveAnimationWithIndex:button.tag];
    
    //根据索引移动reuseScrollView的内容
    [self.reuseScrollView setContentOffset:CGPointMake(offX, 0) animated:YES];
}


//滚动reuseScrollView结束之后，滚动naviScrollView

- (void)setSelectItemWithIndex:(NSInteger)index{
    _oldItem = _currectItem;
    _currectItem.selected = NO;
    UIButton *button = [self.itemsDic objectForKey:self.tmpKeys[index]];
    button.selected = YES;
    _currectItem = button;
    
    [self buttonMoveAnimationWithIndex:index];
    
}


//根据当前button的tag值，移动naviBarScroll

- (void)buttonMoveAnimationWithIndex:(NSInteger)index{
    UIButton *selectButton = [self.itemsDic objectForKey:self.tmpKeys[index]];
    
    //itemW为计算完后button的宽度
    
    if (self.tmpKeys.count * self.itemW > self.width) {
        if (index < StaticItemIndex) {
            
            //x < 2 :前两个
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }else if(index > self.tmpKeys.count - StaticItemIndex - 1) {
            // x >= 8 - 3 - 1;
            [self setContentOffset:CGPointMake(self.contentSize.width - self.width, 0) animated:YES];
            
        }else{
            //selectButton.center.x - self.center.x
            [self setContentOffset:CGPointMake(selectButton.center.x - self.center.x, 0) animated:YES];
        }
    }else{
        
        //当title足够少的时候，滚动reusescrollView与点击item时naviBar也是无需滚动的
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


//分类item字体动画实现

//在滚动scrollView中的内容视图时，字体动画效果

- (void)changeButtonFontWithOffset:(CGFloat)offset andWidth:(CGFloat)width{
    
    //firstButton为当前大字体的btn
    
    [self.firstButton setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    
    //secButton为下一个将要滚动的btn
    
    [self.secButton setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    
    //返回两参数相除的余数  width为reuseScrollView的宽度   p的值最大为永远小于1   offset的值是从0开始一直叠加
    
    CGFloat p = fmod(offset, width) /width;
    
    NSLog(@"width:%f  p:%f   offset:%f",width,p,offset);
    
    NSInteger index = offset / width;   //index的值，只有在滚动到第二个页面的时候才会1
    
    NSLog(@"%ld",index);
    
    self.currctIndex = index;   //记录滚动到当前那一页
    
    //滚动时动态改变字体的大小
    
    if (self.isGraduallyChangFont) {
        
        //当前按钮
        self.firstButton = [self.itemsDic objectForKey:self.tmpKeys[index]];
        
        //找到下一个按钮
        if(index + 1 < self.tmpKeys.count){
            self.secButton = [self.itemsDic objectForKey:self.tmpKeys[index + 1]];
        }else{
            self.secButton = nil;
        }
        
        CGFloat fontSize1;
        CGFloat fontSize2;
        
        if (self.maxFontSize) {
            //当设置了maxFontSize时
            fontSize1 = (1- p) * (self.maxFontSize - self.minFontSize) + self.minFontSize;
            fontSize2 = p * (self.maxFontSize - self.minFontSize) + self.minFontSize;
        }else{
            //没有设置maxFontSize时
            fontSize1 = (1- p) * FontDetLeSize + FontMinSize;
            fontSize2 = p * FontDetLeSize + FontMinSize;
        }
        self.firstButton.titleLabel.font = [UIFont systemFontOfSize:fontSize1];
        self.secButton.titleLabel.font = [UIFont systemFontOfSize:fontSize2];
    }
    
    
    //滚动时动态改变字体颜色  red1为按钮默认状态下的颜色   red2是按钮选中时的颜色
    
    if (self.isGraduallyChangColor) {
        
        CGFloat redTemp1 = ((self.red2 - self.red1) * (1-p)) + self.red1;
        CGFloat greenTemp1 = ((self.green2 - self.green1) * (1 - p)) + self.green1;
        CGFloat blueTemp1 = ((self.blue2 - self.blue1) * (1 - p)) + self.blue1;
        
        CGFloat redTemp2 = ((self.red2 - self.red1) * p) + self.red1;
        CGFloat greenTemp2 = ((self.green2 - self.green1) * p) + self.green1;
        CGFloat blueTemp2 = ((self.blue2 - self.blue1) * p) + self.blue1;
        
        [self.firstButton setTitleColor:[UIColor colorWithRed:redTemp1 green:greenTemp1 blue:blueTemp1 alpha:1] forState:UIControlStateNormal];
        [self.secButton setTitleColor:[UIColor colorWithRed:redTemp2 green:greenTemp2 blue:blueTemp2 alpha:1] forState:UIControlStateNormal];
        
    }
}



//监听reuseScrollView的滚动，来改变naviBar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //根据x移动的偏差改变字体大小与字体颜色
    
    [self changeButtonFontWithOffset:scrollView.contentOffset.x andWidth:self.reuseScrollView.width];
}



//这个方法很方便计算你所在当前页
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //记录当前滚动到的item索引
    NSInteger num = targetContentOffset->x / _reuseScrollView.frame.size.width;
    
    [self setSelectItemWithIndex:num];
    
}


@end

