//
//  ViewController.m
//  ReusedScrollView
//
//  Created by FelixYin on 15/8/13.
//  Copyright © 2015年 felixios. All rights reserved.
//

#import "ViewController.h"
#import "FYContentView.h"
#import "UIView+Extension.h"
#import "TestView.h"

@interface ViewController ()

@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) FYContentView *contentView;
@property(nonatomic,strong) NSMutableArray *pageViews;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"苹果",@"牛油果",@"香蕉",@"山竹",@"荔枝",@"西瓜",@"橘子",@"橙子",@"桃子",@"柿子",@"梨子",@"圣女果"];
    
    self.contentView = [[FYContentView alloc] init];
    
    _contentView.frame = CGRectMake(0, 64, self.view.width, 45);
    
    _contentView.titleNormalColor = [UIColor whiteColor];
    
    _contentView.titleSelectedColor = [UIColor blueColor];
    
    _contentView.titles = self.titles;
    
    _contentView.pageViews = self.pageViews;
    
    _contentView.reuseScrollViewHeight = self.view.frame.size.height - 109;
    
    //将contentView添加到ViewController中
    
    [self.view addSubview:_contentView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)pageViews{

    if (_pageViews == nil) {
        
        _pageViews = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < self.titles.count; i++) {
            
            TestView *v = [[TestView alloc] init];
            
            v.label.text = self.titles [i];

            [_pageViews addObject:v];
            
        }
        
    }

    return _pageViews;
}


@end
