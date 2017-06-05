//
//  YCCenterLineView.m
//  Seat
//
//  Created by itclimb on 05/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCCenterLineView.h"
#import "UIView+Extension.h"

@interface YCCenterLineView ()

@property(nonatomic, strong) UIButton *centerButton;

@end

@implementation YCCenterLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)createCenterButton{
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setTitle:@"中央位置" forState:UIControlStateNormal];
    centerBtn.titleLabel.font = [UIFont systemFontOfSize:8.0];
    [centerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    centerBtn.userInteractionEnabled = NO;
    centerBtn.layer.masksToBounds = YES;
    centerBtn.layer.cornerRadius = 5;
    centerBtn.layer.borderWidth = 0.5;
    centerBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    centerBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:centerBtn];
    self.centerButton = centerBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.centerButton.width = 50;
    self.centerButton.height = 15;
    self.centerButton.y = -15;
    self.centerButton.centerX = self.width * 0.5;
}

- (void)setHeight:(CGFloat)height{
    [super setHeight:height];
    
    [self setNeedsDisplay];
}


/**
 绘制虚线

 @param rect 范围
 */
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGFloat lengths[] = {6,3};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextStrokePath(context);
}

@end
