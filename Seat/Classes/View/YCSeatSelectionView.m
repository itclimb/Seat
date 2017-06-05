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

@interface YCSeatSelectionView ()<UIScrollViewDelegate>
//选座的ScrollView
@property(nonatomic, strong) UIScrollView *seatScrollView;
//选座底部插入的logo
@property(nonatomic, strong) YCAppLogoView *logoView;
//座位视图
@property(nonatomic, strong) YCSeatView *seatView;
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
