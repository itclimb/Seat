//
//  YCSeatViewController.m
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "YCSeatViewController.h"
#import "MBProgressHUD.h"
#import "YCSeatsModel.h"
#import "MJExtension.h"
#import "YCSeatSelectionView.h"
#import "YCSeatConfig.h"

@interface YCSeatViewController ()
//Datas
@property(nonatomic, strong) NSArray *seatsModels;
//所有可选座位
@property(nonatomic, strong) NSDictionary *allAvailableSeats;
//已选座位
@property(nonatomic, strong) NSArray *selectedSeats;
@end

@implementation YCSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选座";
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    
    __weak __typeof__(self)weakSelf = self;
    //加载数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"seats%zd",arc4random_uniform(4)] ofType:nil];
        NSDictionary *seatsDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        __block NSMutableArray *seatsArray = seatsDic[@"seats"];
        __block NSMutableArray *seatsDatas = [NSMutableArray arrayWithCapacity:seatsArray.count];
        [seatsArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YCSeatsModel *model = [YCSeatsModel mj_objectWithKeyValues:obj];
            [seatsDatas addObject:model];
        }];
        [HUD hideAnimated:YES];
        weakSelf.seatsModels = seatsDatas.copy;
        
        [weakSelf initSeatSelectionView:seatsDatas];
        [weakSelf creatSureButton];
    });
}

- (void)initSeatSelectionView:(NSArray *)seatsModels{
    __weak __typeof__(self)weakSelf = self;
    YCSeatSelectionView *selectionView = [[YCSeatSelectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)
                                                                        SeatsModels:weakSelf.seatsModels
                                                                           HallName:@"远程新华" SeatBtnActionBlock:^(NSMutableArray *selectedSeats, NSMutableDictionary *allAvailableSeats, NSString *errorMessage)
                                          {
                                              if (errorMessage) {
                                                  [self showMessage:errorMessage];
                                              }else{
                                                  weakSelf.selectedSeats =selectedSeats;
                                                  weakSelf.allAvailableSeats = allAvailableSeats;
                                              }
                                          }];
    [self.view addSubview:selectionView];
}

- (void)creatSureButton{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认选座" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    CGFloat sureBtn_W = 200;
    CGFloat sureBtn_H = 30;
    CGFloat sureBtn_X = (YCScreenW - sureBtn_W) * 0.5;
    CGFloat sureBtn_Y = 550;
    sureBtn.frame = CGRectMake(sureBtn_X, sureBtn_Y, sureBtn_W, sureBtn_H);
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureButtonAction{
    if (!self.selectedSeats.count) {
        [self showMessage:@"您还未选座"];
        return;
    }
    [self showMessage:@"选座成功"];
}

- (void)showMessage:(NSString *)message{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
