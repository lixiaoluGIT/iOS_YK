//
//  LogisticsTableViewCell.h
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogisticsTableViewCellFrame;
@interface LogisticsTableViewCell : UITableViewCell

@property(nonatomic,strong) LogisticsTableViewCellFrame *logisticsTableViewCellFrame;

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *infoLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong)UILabel *line;


@end
