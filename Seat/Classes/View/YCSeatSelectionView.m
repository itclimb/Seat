//
//  YCSeatSelectionView.m
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCSeatSelectionView.h"
#import "UIView+Extension.h"
#import "YCAppLogoView.h"
#import "YCSeatView.h"
#import "YCSeatConfig.h"
#import "YCIndicatorView.h"
#import "YCRowIndexView.h"
#import "YCCenterLineView.h"
#import "YCHallLogoView.h"

@interface YCSeatSelectionView ()<UIScrollViewDelegate>
//选座的ScrollView
@property(nonatomic, strong) UIScrollView *seatScrollView;
//选座底部插入的 App logo
@property(nonatomic, strong) YCAppLogoView *logoView;
//座位视图
@property(nonatomic, strong) YCSeatView *seatView;
//Mini座位图
@property(nonatomic, strong) YCIndicatorView *indicator;
//座位号标识图
@property(nonatomic, strong) YCRowIndexView *indexView;
//中央虚线
@property(nonatomic, strong) YCCenterLineView *centerLine;
//电影院Logo
@property(nonatomic, strong) YCHallLogoView *hallLogo;
//已经选择的座位
@property(nonatomic, strong) NSMutableArray *selectedSeats;
//block
@property(nonatomic, copy) ActionBlock actionBlock;

@end

@implementation YCSeatSelectionView

- (instancetype)initWithFrame:(CGRect)frame
                  SeatsModels:(NSArray *)seatsModels
                     HallName:(NSString *)hallName
           SeatBtnActionBlock:(ActionBlock)actionBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0
                                               green:245.0/255.0
                                                blue:245.0/255.0 alpha:1];
        self.actionBlock = actionBlock;
        [self initScrollView];
        [self initAppLogo];
        [self initSeatView:seatsModels];
        [self initIndicator:seatsModels];
        [self initRowIndexView:seatsModels];
        [self initCenterLineView:seatsModels];
        [self initHallLogoView:hallName];
        [self startAnimation];
    }
    return self;
}

/**
 *  init scrollView
 */
- (void)initScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.seatScrollView = scrollView;
    scrollView.delegate = self;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:scrollView];
}

/**
 *  init logo
 */
- (void)initAppLogo{
    YCAppLogoView *logoView = [[YCAppLogoView alloc] init];
    self.logoView = logoView;
    logoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    logoView.centerX = self.width * 0.5;
    logoView.height = 40;
    logoView.width = 100;
    logoView.y = self.height - 40;
    [self.seatScrollView insertSubview:logoView atIndex:0];
}

/**
 init 座位视图

 @param seatsDatas 座位数据
 */
- (void)initSeatView:(NSArray *)seatsDatas {
    __weak __typeof__(self)weakSelf = self;
    YCSeatView *seatView = [[YCSeatView alloc] initWithSeatsDatas:seatsDatas MaxNormalWidth:self.width SeatBtnActionBlock:^(YCSeatButton *seatBtn, NSMutableDictionary *allAvailableSeats) {
        
        NSString *errorStr = nil;
        if (seatBtn.selected) {
            [weakSelf.selectedSeats addObject:seatBtn];
            if (weakSelf.selectedSeats.count > YCMaxSelectedSeatsCount) {
                seatBtn.selected = !seatBtn.selected;
                [weakSelf.selectedSeats removeObject:seatBtn];
                errorStr = YCExceededMaximumError;
            }
        }else{
            if ([weakSelf.selectedSeats containsObject:seatBtn]) {
                [weakSelf.selectedSeats removeObject:seatBtn];
                if (weakSelf.actionBlock) weakSelf.actionBlock(weakSelf.selectedSeats,allAvailableSeats,errorStr);
                return ;
            }
        }
        if (weakSelf.actionBlock) weakSelf.actionBlock(weakSelf.selectedSeats,allAvailableSeats,errorStr);
        
        if (weakSelf.seatScrollView.maximumZoomScale - weakSelf.seatScrollView.zoomScale < 0.1) return;//设置座位放大
        CGFloat maximumZoomScale = weakSelf.seatScrollView.maximumZoomScale;
        CGRect zoomRect = [weakSelf _zoomRectInView:weakSelf.seatScrollView forScale:maximumZoomScale withCenter:CGPointMake(seatBtn.centerX, seatBtn.centerY)];
        [weakSelf.seatScrollView zoomToRect:zoomRect animated:YES];
        
    }];
    
    self.seatView = seatView;
    seatView.frame = CGRectMake(0, 0,seatView.seatViewWidth, seatView.seatViewHeight);
    [self.seatScrollView insertSubview:seatView atIndex:0];
    self.seatScrollView.maximumZoomScale = YCseastMaxW_H / seatView.seatBtnWidth;
    self.seatScrollView.contentInset = UIEdgeInsetsMake(YCseastsColMargin,
                                                        (self.width - seatView.seatViewWidth)/2,
                                                        YCseastsColMargin,
                                                        (self.width - seatView.seatViewWidth)/2);
}

/**
 Mini座位图

 @param seatsModels 座位数据
 */
- (void)initIndicator:(NSArray *)seatsModels{
    
    CGFloat Ratio = 2;
    YCSeatsModel *seatsModel = seatsModels.firstObject;
    NSUInteger cloCount = [seatsModel.columns count];
    if (cloCount % 2) cloCount += 1;
    CGFloat YCMiniMeIndicatorMaxHeight = self.height / 6;//设置最大高度
    CGFloat MaxWidth = (self.width - 2 * YCseastsRowMargin) * 0.5;
    CGFloat currentMiniBtnW_H = MaxWidth / cloCount;
    CGFloat MaxHeight = currentMiniBtnW_H * seatsModels.count;
    
    if (MaxHeight >= YCMiniMeIndicatorMaxHeight ) {
        currentMiniBtnW_H = YCMiniMeIndicatorMaxHeight / seatsModels.count;
        MaxWidth = currentMiniBtnW_H * cloCount;
        MaxHeight = YCMiniMeIndicatorMaxHeight;
        Ratio = (self.width - 2 * YCseastsRowMargin) / MaxWidth;
    }
    
    YCIndicatorView *indicator = [[YCIndicatorView alloc]initWithView:self.seatView
                                                            withRatio:Ratio
                                                       withScrollView:self.seatScrollView];
    indicator.x = 3;
    indicator.y = 3 * 3;
    indicator.width = MaxWidth;
    indicator.height = MaxHeight;
    self.indicator = indicator;
    [self addSubview:indicator];
    
}


/**
 座位行号标识

 @param seatsModels 座位数据
 */
- (void)initRowIndexView:(NSArray *)seatsModels{
    YCRowIndexView *indexView = [[YCRowIndexView alloc]init];
    indexView.seatsModels = seatsModels;
    indexView.width = 13;
    indexView.height = self.seatView.height + 2 * YCseastMinW_H;
    indexView.y =  - YCSmallMargin;
    indexView.x = self.seatScrollView.contentOffset.x + YCseastMinW_H;
    self.indexView = indexView;
    [self.seatScrollView addSubview:indexView];
}


/**
 中央虚线

 @param seatsModels 座位数据
 */
- (void)initCenterLineView:(NSArray *)seatsModels{
    YCCenterLineView *centerLine = [[YCCenterLineView alloc]init];
    centerLine.backgroundColor = [UIColor clearColor];
    centerLine.width = 1;
    centerLine.height = seatsModels.count * YCseastNomarW_H + 2 * YCSmallMargin ;
    self.centerLine = centerLine;
    self.centerLine.centerX = self.seatView.centerX;
    self.centerLine.y = self.seatScrollView.contentOffset.y + YCCenterLineY;
    [self.seatScrollView addSubview:self.centerLine];
}


/**
 Add影院Logo
 
 @param hallName 影院名称
 */
- (void)initHallLogoView:(NSString *)hallName{
    YCHallLogoView *logoView = [[YCHallLogoView alloc]init];
    self.hallLogo = logoView;
    logoView.hallName = hallName;
    logoView.width = YCHallLogoW;
    logoView.height = 20;
    self.hallLogo.centerX = self.seatView.centerX;
    self.hallLogo.y = self.seatScrollView.contentOffset.y;
    [self.seatScrollView addSubview:self.hallLogo];
}


/**
 开始动画
 */
- (void)startAnimation{
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect zoomRect = [self _zoomRectInView:self.seatScrollView
                                                        forScale:YCseastNomarW_H / self.seatView.seatBtnHeight
                                                      withCenter:CGPointMake(self.seatView.seatViewWidth / 2, 0)];
                         
                         [self.seatScrollView zoomToRect:zoomRect
                                                animated:NO];
                     } completion:nil];
}

//MARK: - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.seatView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 更新applogo
    if (scrollView.contentOffset.y <= scrollView.contentSize.height - self.height +YCseastsColMargin + 15) {
        self.logoView.y = CGRectGetMaxY(self.seatView.frame) + 35;
        self.logoView.centerX = self.seatView.centerX;
    }else{
        self.logoView.centerX = self.seatView.centerX;
        self.logoView.y = scrollView.contentOffset.y + self.height - self.logoView.height;
    }
    //更新hallLogo
    self.hallLogo.y = scrollView.contentOffset.y;
    
    //更新中线
    self.centerLine.height = CGRectGetMaxY(self.seatView.frame) + 2 * YCSmallMargin;
    
    if (scrollView.contentOffset.y < - YCseastsColMargin ) {
        self.centerLine.y = self.seatView.y - YCseastsColMargin + YCCenterLineY;
    }else{
        self.centerLine.y = scrollView.contentOffset.y + YCCenterLineY;
        self.centerLine.height = CGRectGetMaxY(self.seatView.frame) - scrollView.contentOffset.y - 2 * YCCenterLineY + YCseastsColMargin;
    }
    // 更新索引条
    self.indexView.x = scrollView.contentOffset.x + YCseastMinW_H;
    
    
    //更新indicator大小位置
    [self.indicator updateMiniIndicator];
    if (!self.indicator.hidden || self.seatScrollView.isZoomBouncing)return;
    self.indicator.alpha = 1;
    self.indicator.hidden = NO;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicator selector:@selector(indicatorHidden) object:nil];
    self.centerLine.centerX = self.seatView.centerX;
    self.indexView.height = self.seatView.height + 2 * YCSmallMargin;
    self.hallLogo.centerX = self.seatView.centerX;
    self.logoView.centerX = self.seatView.centerX;
    [self.indicator updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    self.hallLogo.centerX = self.seatView.centerX;
    self.hallLogo.y = scrollView.contentOffset.y;
    self.centerLine.centerX = self.seatView.centerX;
    self.centerLine.y = scrollView.contentOffset.y + YCCenterLineY;
    self.logoView.centerX = self.seatView.centerX;
    [self.indicator updateMiniIndicator];
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self.indicator selector:@selector(indicatorHidden) object:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.indicator performSelector:@selector(indicatorHidden) withObject:nil afterDelay:2];
    
}


/**
 Room

 @param view 父视图
 @param scale 比例
 @param center 中心
 @return Rect
 */
- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = view.bounds.size.height / scale;
    zoomRect.size.width = view.bounds.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

//MARK: - lazy load
- (NSMutableArray *)selectedSeats{
    if (!_selectedSeats) {
        _selectedSeats = [[NSMutableArray alloc] init];
    }
    return _selectedSeats;
}
@end
