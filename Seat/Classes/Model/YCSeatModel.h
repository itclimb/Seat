//
//  YCSeatModel.h
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCSeatModel : NSObject

//座位真实列，用于显示当前座位列号
@property (nonatomic, copy) NSString *columnId;
//座位编号
@property (nonatomic, copy) NSString *seatNo;
// N: 可选 LK:已售出 E:过道
@property(nonatomic, copy) NSString *st;

@end
