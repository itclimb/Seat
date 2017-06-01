//
//  YCSeatSelectionView.m
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCSeatSelectionView.h"

@interface YCSeatSelectionView ()<UIScrollViewDelegate>
//选座的ScrollView
@property(nonatomic, strong) UIScrollView *seatScrollView;
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
    }
    return self;
}

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
@end
