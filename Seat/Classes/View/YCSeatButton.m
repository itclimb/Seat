//
//  YCSeatButton.m
//  Seat
//
//  Created by itclimb on 02/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCSeatButton.h"
#import "UIView+Extension.h"

@implementation YCSeatButton

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnScale = 0.95;
    CGFloat btnX = self.width * (1 - btnScale) * 0.5;
    CGFloat btnY = self.height * (1 - btnScale) * 0.5;
    CGFloat btnW = self.width * btnScale;
    CGFloat btnH = self.height * btnScale;
    self.imageView.frame = CGRectMake(btnX, btnY, btnW, btnH);
}


/**
 判断座位是否可选

 @return bool
 */
- (BOOL)isSeatAvailable{
    return [self.seatModel.st isEqualToString:@"N"];
}

@end
