//
//  YCSeatSelectionView.h
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(NSMutableArray *, NSMutableDictionary *, NSString *);

@interface YCSeatSelectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  SeatsModels:(NSArray *)seatsModels
                     HallName:(NSString *)hallName
           SeatBtnActionBlock:(ActionBlock)actionBlock;

@end
