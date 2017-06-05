//
//  YCSeatView.m
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//  座位图

#import "YCSeatView.h"

@interface YCSeatView ()

@property(nonatomic, strong) NSMutableDictionary *allAvailableSeats;
@property(nonatomic, copy) SeatActionBlock actionBlock;

@end

@implementation YCSeatView

- (instancetype)initWithSeatsDatas:(NSArray *)seatsDatas
                    MaxNormalWidth:(CGFloat)maxWidth
                SeatBtnActionBlock:(SeatActionBlock)actionBlock
{
    if (self = [super init]) {
    
        self.backgroundColor = [UIColor whiteColor];
        self.actionBlock = actionBlock;
        
        YCSeatsModel *seatsModel = seatsDatas.firstObject;
        NSUInteger colCount = seatsModel.columns.count;
        if (colCount % 2) { //奇数列加1
            colCount += 1;
        }
        CGFloat seatViewW = maxWidth - 2 * 40;
        CGFloat seatBtnW_H = seatViewW / colCount;
        if (seatBtnW_H < 10) {
            seatBtnW_H = 10;
            seatViewW = seatBtnW_H * colCount;
        }
        self.seatBtnWidth = seatBtnW_H;
        self.seatBtnHeight = seatBtnW_H;
        self.seatViewWidth = seatViewW;
        self.seatViewHeight = seatBtnW_H * [seatsDatas count];
        
        [self initSeatBtns:seatsDatas];
    }
    return self;
}


/**
 初始化座位

 @param seatsDatas 座位数组
 */
- (void)initSeatBtns:(NSArray *)seatsDatas{
    
    static NSInteger seatIndex = 0;
    
    [seatsDatas enumerateObjectsUsingBlock:^(YCSeatsModel *seatsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (int i = 0; i < seatsModel.columns.count; i++) {

            seatIndex++;
            YCSeatModel *seatModel = seatsModel.columns[i];
            YCSeatButton *seatBtn = [YCSeatButton buttonWithType:UIButtonTypeCustom];
            seatBtn.backgroundColor = [UIColor whiteColor];
            seatBtn.seatsModel = seatsModel;
            seatBtn.seatModel = seatModel;
            
            if ([seatModel.st isEqualToString:@"N"]) {//可选
                
                [seatBtn setImage:[UIImage imageNamed:@"kexuan"] forState:UIControlStateNormal];
                [seatBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                seatBtn.seatIndex = seatIndex;
                [self.allAvailableSeats setObject:seatBtn forKey:[@(seatIndex) stringValue]];
                
            } else if ([seatModel.st isEqualToString:@"E"]) {//过道
                continue;
                
            } else{//已售
                [seatBtn setImage:[UIImage imageNamed:@"yishou"] forState:UIControlStateNormal];
                seatBtn.userInteractionEnabled = NO;
            }
            
            [seatBtn addTarget:self action:@selector(seatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:seatBtn];
        }
        
    }];
}

/**
 座位按钮点击事件

 @param button 座位按钮
 */
- (void)seatBtnClick:(YCSeatButton *)button{
    button.selected = !button.selected;
    if (self.actionBlock) {
        self.actionBlock(button, self.allAvailableSeats);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YCSeatButton class]]) {
            YCSeatButton *seatBtn = (YCSeatButton *)view;
            NSInteger col = [seatBtn.seatsModel.columns indexOfObject:seatBtn.seatModel];
            NSInteger row = [seatBtn.seatsModel.rowNum integerValue] - 1;
            seatBtn.frame = CGRectMake(col * self.seatBtnWidth, row * self.seatBtnHeight, self.seatBtnWidth, self.seatBtnHeight);
        }
    }
}

//MARK: - lazy load
- (NSMutableDictionary *)allAvailableSeats{
    if (!_allAvailableSeats) {
        _allAvailableSeats = [[NSMutableDictionary alloc] init];
    }
    return _allAvailableSeats;
}

@end
