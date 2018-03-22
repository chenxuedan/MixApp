//
//  CycleScrollView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/9.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
#import "TopBannerView.h"

@interface CycleScrollView () <UIScrollViewDelegate>
//当前第几页
@property (nonatomic, assign)NSInteger currentPageIndex;
//总共几页
@property (nonatomic, assign)NSInteger totalPageCount;
//存储当前展示的图片、前一张和后一张 共三张图片视图
@property (nonatomic, strong)NSMutableArray *contentViews;
@property (nonatomic, strong)UIScrollView *scrollView;
//定时器
@property (nonatomic, strong)NSTimer *animationTimer;
//时间间隔
@property (nonatomic, assign)NSTimeInterval animationDuration;
//分页控制器
@property (nonatomic, strong)UIPageControl *pageControl;
/** 数据源：获取总的page个数*/
@property (nonatomic, copy)NSInteger (^totalPagesCount)(void);
/** 数据源：获取第pageIndex个位置的contentView */
@property (nonatomic, copy)UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/** 当点击的时候，执行的block */
@property (nonatomic, copy)void (^TapActionBlock)(NSInteger pageIndex);

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount {
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.centerX = self.centerX;
        self.pageControl.backgroundColor = [UIColor greenSeaColor];
        self.pageControl.y = self.scrollView.height - 10;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.currentPageIndex = 0;
        if (animationDuration > 0.0) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration) target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
            [self.animationTimer pauseTimer];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *view = self.scrollView.subviews[i];
        view.height = self.scrollView.height;
        self.pageControl.y = self.scrollView.height - 10;
    }
}

- (void)setTopStories:(NSArray *)topStories {
    _topStories = topStories;
    __weak typeof(self) WeakSelf = self;
    self.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
        TopBannerView *topView = [[TopBannerView alloc] initWithFrame:WeakSelf.frame];
        NewsTopStoriesModel *model = topStories[pageIndex];
        topView.dataModel = model;
        return topView;
    };
    
    self.totalPagesCount = ^NSInteger(void) {
        return topStories.count;
    };
    
    self.TapActionBlock = ^(NSInteger pageIndex) {
        WeakSelf.topViewBlock(topStories[pageIndex]);
    };
}

#pragma mark - private method
//配置三个视图的布局
- (void)configContentViews {
    //使数组中的元素执行后面的selector中的方法
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewccontentDataSource];
    self.pageControl.numberOfPages = _totalPageCount;
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 *
 */
- (void)setScrollViewccontentDataSource {
    //获取当前页的上一个页面的下标
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    //获取当前页的下一个页面的下标
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}
//获取有效的页面下标
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex {
    if (currentPageIndex == -1) {
        return self.totalPageCount - 1;
    }else if (currentPageIndex == self.totalPageCount) {
        return 0;
    }else {
        return currentPageIndex;
    }
}
#pragma mark - UIScrollViewDelegate
//当手动滑动banner图时，暂停定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.animationTimer pauseTimer];
}
//当停止拖动时，在一定的时间间隔之后继续定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if (contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}
//减速停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark - event response
- (void)animationTimerDidFired:(NSTimer *)timer {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

@end
