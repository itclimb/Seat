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

@interface YCSeatSelectionView ()<UIScrollViewDelegate>
//选座的ScrollView
@property(nonatomic, strong) UIScrollView *seatScrollView;
//选座底部插入的logo
@property(nonatomic, strong) YCAppLogoView *logoView;
//座位视图
@property(nonatomic, strong) YCSeatView *seatView;
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
    YCSeatView *seatView = [[YCSeatView alloc] initWithSeatsDatas:seatsDatas MaxNormalWidth:self.width SeatBtnActionBlock:^(YCSeatButton *seatBtn, NSMutableDictionary *allAvailableSeats) {
        
    }];
    self.seatView = seatView;
}
@end
