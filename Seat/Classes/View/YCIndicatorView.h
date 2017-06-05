//
//  YCIndicatorView.h
//  Seat
//
//  Created by itclimb on 05/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCIndicatorView : UIView

- (instancetype)initWithView:(UIView *)mapView withRatio:(CGFloat)ratio withScrollView:(UIScrollView *)myScrollView;

- (void)updateMiniIndicator;

- (void)updateMiniImageView;

- (void)indicatorHidden;

@end
