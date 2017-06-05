//
//  YCRowIndexView.m
//  Seat
//
//  Created by itclimb on 05/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCRowIndexView.h"
#import "UIView+Extension.h"
#import "YCSeatsModel.h"

@implementation YCRowIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.width * 0.5;
    self.layer.masksToBounds = YES;
}

- (void)setHeight:(CGFloat)height{
    [super setHeight:height];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    NSDictionary *attributeName = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    CGFloat NumberTitleH = (self.height - 2 * 10) / self.seatsModels.count;
    
    [self.seatsModels enumerateObjectsUsingBlock:^(YCSeatsModel *seatsModel, NSUInteger idx, BOOL *stop) {
        
        CGSize strsize =  [seatsModel.rowId sizeWithAttributes:attributeName];
        
        [seatsModel.rowId drawAtPoint:CGPointMake((self.width - strsize.width) * 0.5, 10 + idx * NumberTitleH + (NumberTitleH - strsize.height) * 0.5) withAttributes:attributeName];
        
    }];
    
}

@end
