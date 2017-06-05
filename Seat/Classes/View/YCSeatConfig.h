//
//  YCSeatConfig.h
//  Seat
//
//  Created by itclimb on 05/06/2017.
//  Copyright © 2017 itclimb.yuancheng.com. All rights reserved.
//

#ifndef YCSeatConfig_h
#define YCSeatConfig_h

#define  YCScreenW [UIScreen mainScreen].bounds.size.width//屏幕宽
#define  YCScreenH [UIScreen mainScreen].bounds.size.height//屏幕高
#define  YCseastsColMargin 60 //座位图离上部分距离
#define  YCseastsRowMargin 40 //座位图离左边距离
#define  YCCenterLineY 50 //中线离上部分距离
#define  YCseastMinW_H 10 //座位按钮最小宽高
#define  YCseastNomarW_H 25 //座位按钮默认开场动画宽高
#define  YCseastMaxW_H 40 //座位按钮最大宽高
#define  YCSmallMargin 10 //默认最小间距
#define  YCAppLogoW 100 //applogo的宽度
#define  YCHallLogoW 200 //halllogo的宽度
#define  YCSeatBtnScale 0.95 //按钮内图标占按钮大小的比例



#define  YCMaxSelectedSeatsCount 4 //限制最大选座数量
#define  YCExceededMaximumError @"选择座位已达到上限"//提示选择座位超过要求的上限


#endif /* YCSeatConfig_h */
