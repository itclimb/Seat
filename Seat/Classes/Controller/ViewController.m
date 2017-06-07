//
//  ViewController.m
//  Seat
//
//  Created by itclimb on 01/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#import "ViewController.h"
#import "YCSeatViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"电影选座";
    
    NSDictionary *attributeName = @{NSFontAttributeName: [UIFont systemFontOfSize:21.0],NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UILabel *mark = [[UILabel alloc] init];
    mark.font = [UIFont systemFontOfSize:21.0];
    NSString *str = @"点击";
    mark.text = str;
    CGSize strSize = [str sizeWithAttributes:attributeName];
    mark.frame = CGRectMake((self.view.width - strSize.width) * 0.5, (self.view.height - strSize.height) * 0.5, strSize.width, strSize.height);
    [self.view addSubview:mark];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    YCSeatViewController *vc = [[YCSeatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
