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

@interface YCSeatSelectionView ()<UIScrollViewDelegate>
//选座的ScrollView
@property(nonatomic, strong) UIScrollView *seatScrollView;
//选座底部插入的logo
@property(nonatomic, strong) YCAppLogoView *logoView;
//座位视图
@property(nonatomic, strong) YCSeatView *seatView;
//Mini座位图
@property(nonatomic, strong) YCIndicatorView *indicator;
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
        //##################
        if (weakSelf.seatScrollView.maximumZoomScale - weakSelf.seatScrollView.zoomScale < 0.1) return;//设置座位放大
        CGFloat maximumZoomScale = weakSelf.seatScrollView.maximumZoomScale;
        CGRect zoomRect = [weakSelf _zoomRectInView:weakSelf.seatScrollView forScale:maximumZoomScale withCenter:CGPointMake(seatBtn.centerX, seatBtn.centerY)];
        [weakSelf.seatScrollView zoomToRect:zoomRect animated:YES];
        //##################
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

#pragma mark - UIScrollViewDelegate
// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
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
