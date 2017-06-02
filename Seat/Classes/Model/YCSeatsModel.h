//
//  YCSeatsModel.h
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCSeatModel.h"

@interface YCSeatsModel : NSObject
//每行的座位数组
@property(nonatomic, strong) NSArray *colunms;
//座位的行号
@property(nonatomic, copy) NSString *rowId;
//座位的屏幕行,用于计算座位的位置
@property(nonatomic, copy) NSString *rowNum;

@end
