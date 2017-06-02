//
//  YCSeatView.h
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//  座位图

#import <UIKit/UIKit.h>
#import "YCSeatButton.h"

typedef void (^SeatActionBlock)(YCSeatButton *seatBtn,NSMutableDictionary *allAvailableSeats);

@interface YCSeatView : UIView
//座位按钮宽
@property(nonatomic, assign) CGFloat seatBtnWidth;
//座位按钮高
@property(nonatomic, assign) CGFloat seatBtnHeight;
//座位视图宽
@property(nonatomic, assign) CGFloat seatViewWidth;
//座位视图高
@property(nonatomic, assign) CGFloat seatViewHeight;

/**
 init

 @param seatsDatas 座位数组
 @param maxWidth 默认最大座位父控件的宽度
 @param actionBlock block回调
 @return self
 */
- (instancetype)initWithSeatsDatas:(NSArray *)seatsDatas
                    MaxNormalWidth:(CGFloat)maxWidth
                SeatBtnActionBlock:(SeatActionBlock)actionBlock;

@end
