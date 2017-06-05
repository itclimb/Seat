//
//  YCIndicatorView.m
//  Seat
//
//  Created by itclimb on 05/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCIndicatorView.h"
#import "UIView+Extension.h"
#import "YCSeatConfig.h"

@interface YCIndicatorView ()
//比例
@property(nonatomic, assign) CGFloat ratio;
//背景视图
@property(nonatomic, weak) UIView *miniMe;

@property(nonatomic, weak) UIImageView *miniImageView;

@property(nonatomic, weak) UIImageView *logo;

@property(nonatomic, weak) UIView *miniIndicator;

@property(nonatomic, weak) UIView *mapView;

@property(nonatomic, weak) UIScrollView *myScrollView;

@end

@implementation YCIndicatorView

- (instancetype)initWithView:(UIView *)mapView withRatio:(CGFloat)ratio withScrollView:(UIScrollView *)myScrollView{
    if (self = [super init]) {
        self.ratio = ratio;
        self.mapView = mapView;
        self.myScrollView = myScrollView;
        self.userInteractionEnabled = NO;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //背景视图
    UIView *miniMe = [[UIView alloc] init];
    miniMe.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
//    miniMe.backgroundColor = [UIColor redColor];
    self.miniMe = miniMe;
    [self addSubview:miniMe];
    
    //影厅图标
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screenBg"]];
    self.logo = logo;
    [miniMe addSubview:logo];
    
    //Mini座位视图
    UIImageView *miniImageView = [[UIImageView alloc] initWithImage:[self captureScreen:self.mapView]];
    miniImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:miniImageView];
    self.miniImageView = miniImageView;
    
    UIView *miniIndicator = [[UIView alloc] init];
    miniIndicator.layer.borderWidth = 1;
    miniIndicator.layer.borderColor = [UIColor redColor].CGColor;
    self.miniIndicator = miniIndicator;
    [self addSubview:miniIndicator];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.miniMe.frame = CGRectMake(-3, - 3 * 3, self.width + 2 * 3,self.height + 4 * 3);
    self.logo.frame = CGRectMake(2 * 3, 3, self.width - 4 * 3, 3);
    self.miniImageView.frame = CGRectMake(0, 0,self.width, self.height );
    
    //设置线框的高宽
    self.miniIndicator.x = (self.myScrollView.contentOffset.x * self.width)  / self.myScrollView.contentSize.width;
    self.miniIndicator.y = (self.myScrollView.contentOffset.y * self.height) / self.myScrollView.contentSize.height;
    
    if (self.miniIndicator.height == self.height && self.miniIndicator.width == self.width) {
        self.miniIndicator.x = 0;
        self.miniIndicator.y = 0;
    }
    if (self.mapView.width < self.myScrollView.width) {
        self.miniIndicator.x = 0;
        self.miniIndicator.width = self.width;
    }else{
        
        self.miniIndicator.width = (self.width * (self.myScrollView.width - self.myScrollView.contentInset.right)/ self.mapView.width);
        if (self.myScrollView.contentOffset.x < 0) {
            self.miniIndicator.width =  self.miniIndicator.width - ABS(self.myScrollView.contentOffset.x * self.width) / self.myScrollView.contentSize.width;
            self.miniIndicator.x = 0;
            
        }
        if (self.myScrollView.contentOffset.x > self.myScrollView.contentSize.width - YCScreenW + self.myScrollView.contentInset.right) {
            self.miniIndicator.width =  self.miniIndicator.width - (self.myScrollView.contentOffset.x - (self.myScrollView.contentSize.width - YCScreenW + self.myScrollView.contentInset.right))* self.width / self.myScrollView.contentSize.width;
        }
    }
    
    if (self.mapView.height <= self.myScrollView.height - YCseastsColMargin) {
        self.miniIndicator.y = 0;
        self.miniIndicator.height = self.height;
    }else{
        self.miniIndicator.height = self.height * (self.myScrollView.height - YCseastsColMargin) / self.mapView.height;
        if (self.myScrollView.contentOffset.y < 0) {
            self.miniIndicator.y = 0;
            self.miniIndicator.height =  self.miniIndicator.height - ABS(self.myScrollView.contentOffset.y * self.height) / self.myScrollView.contentSize.height;
        }
        if (self.myScrollView.contentOffset.y > self.mapView.height - self.myScrollView.height + YCseastsColMargin) {
            self.miniIndicator.height =  self.miniIndicator.height -(self.myScrollView.contentOffset.y - (self.mapView.height - self.myScrollView.height + YCseastsColMargin)) * self.height / self.myScrollView.contentSize.height;
        }
    }
    
}

/**
 捕获视图

 @param viewToCapture 被捕获对象
 @return 捕获结果
 */
- (UIImage *)captureScreen:(UIView *)viewToCapture{
    CGRect rect = [viewToCapture bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//更新指示框Capture
- (void)updateMiniIndicator{
    [self setNeedsLayout];
}

//更新Mini座位图
- (void)updateMiniImageView{
    self.miniImageView.image = [self captureScreen:self.mapView];
}

//隐藏指示框
- (void)indicatorHidden{
   [UIView animateWithDuration:0.25 animations:^{
       self.alpha = 0.5;
   } completion:^(BOOL finished) {
       self.hidden = YES;
   }];
}

@end
