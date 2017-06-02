//
//  YCSeatButton.h
//  Seat
//
//  Created by itclimb on 02/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCSeatsModel.h"

@interface YCSeatButton : UIButton

/** 座位组模型*/
@property(nonatomic, strong) YCSeatModel *seatModel;

/** 座位模型*/
@property(nonatomic, strong) YCSeatsModel *seatsModel;

@property(nonatomic, assign) NSInteger seatIndex;

- (BOOL)isSeatAvailable;

@end
