//
//  YCHallLogoView.m
//  Seat
//
//  Created by itclimb on 06/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCHallLogoView.h"

@interface YCHallLogoView ()
@property(nonatomic, strong) UIImageView *hallLogo;
@end

@implementation YCHallLogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hallLogo = [[UIImageView alloc] init];
        [self addSubview:self.hallLogo];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.hallLogo.frame = self.bounds;
}

- (void)setHallName:(NSString *)hallName{
    _hallName = hallName;
    [self setNeedsDisplay];
}

//绘制图片文字
- (void)drawRect:(CGRect)rect{
    UIImage *image = [UIImage imageNamed:@"screenBg"];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawAtPoint:CGPointZero];
    NSDictionary *attributeName = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:9.0],
                                    NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                    };
    CGSize strSize = [self.hallName sizeWithAttributes:attributeName];
    [self.hallName drawAtPoint:CGPointMake((image.size.width - strSize.width) * 0.5, (image.size.height - strSize.height) * 0.5) withAttributes:attributeName];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.hallLogo.image = image;
}

@end
