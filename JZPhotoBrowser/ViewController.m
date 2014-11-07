//
//  ViewController.m
//  JZPhotoBrowser
//
//  Created by Joshua Zhou on 14/11/7.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@end

#define imageCount  3
#define screenWidth   self.view.bounds.size.width
#define screenHeight  self.view.bounds.size.height
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    /* scrollView */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.contentSize = CGSizeMake(screenWidth * imageCount, screenHeight);
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 0.5;
    [self.view addSubview:scrollView];
    
    /* imageView */
    for (int i = 0; i < imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * screenWidth, 0, screenWidth, screenHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
    }
    
    /* pageControl */
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    CGSize size = [pageControl sizeForNumberOfPages:imageCount];    // 返回自动适应页数的大小
    pageControl.numberOfPages = imageCount;
    pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    pageControl.center = CGPointMake(self.view.center.x, screenHeight - 44);
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    
    [self reOrderImages:scrollView];
}

/* 此方法只是完全scroll完一页之后才调用一次，而didScroll时时刻刻都在调用，所以此方法性能高 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /* 判断是向左还是向右滑动，因为我们老是把当前浏览的图片放在最中间 */
    if (scrollView.contentOffset.x > screenWidth) {     // 向右滑动
        self.pageControl.currentPage = (self.pageControl.currentPage + 1) % imageCount;
    } else if (scrollView.contentOffset.x < screenWidth){
        self.pageControl.currentPage = (self.pageControl.currentPage + imageCount - 1) % imageCount;
    }
    
    [self reOrderImages:scrollView];
}

- (void)reOrderImages:(UIScrollView *)scrollView
{
    UIImageView *middleImageView = scrollView.subviews[1];
    UIImageView *leftImageView = scrollView.subviews[0];
    UIImageView *rightImageView = scrollView.subviews[2];
    
    middleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)self.pageControl.currentPage]];
    leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(self.pageControl.currentPage + imageCount - 1) % imageCount]];
    rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(self.pageControl.currentPage + 1) % imageCount]];
    
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
}

@end
