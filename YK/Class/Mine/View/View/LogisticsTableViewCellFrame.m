//
//  LogisticsTableViewCellFrame.m
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import "LogisticsTableViewCellFrame.h"
#import "LogisticsInfo.h"
#import "NSString+textStringToSize.h"

@implementation LogisticsTableViewCellFrame

-(void)setLogisticsInfo:(LogisticsInfo *)logisticsInfo
{
    _logisticsInfo = logisticsInfo;
    
    CGFloat leftMargin = 55.0;
    CGFloat margin = 11.0;
    CGFloat scWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat labelHeight = 11;
    
    CGFloat imgViewY = margin*2;
    CGFloat imgViewW = labelHeight;
    CGFloat imgViewH = labelHeight;
    CGFloat imgViewX = (leftMargin - labelHeight)/2;
    _imgViewFrame = CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
    
    CGFloat addressX = leftMargin;
    CGFloat addressY = margin*2;
    CGFloat addressW = scWidth - leftMargin - margin;
    CGFloat addressH = labelHeight;
    _addressFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    CGSize textSize = [NSString sizeWithText:logisticsInfo.remark maxSize:CGSizeMake(WIDHT-60, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
    CGFloat infoX = leftMargin;
    CGFloat infoY = CGRectGetMaxY(_addressFrame) + margin;
    CGFloat infoW = textSize.width;
    CGFloat infoH = textSize.height;
    _infoFrame = CGRectMake(infoX, infoY, infoW, infoH);
    
    CGFloat timeX = leftMargin;
    CGFloat timeY = CGRectGetMaxY(_infoFrame) + margin;
    CGFloat timeW = scWidth - leftMargin - margin;
    CGFloat timeH = labelHeight;
    _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    
    CGFloat lineX = leftMargin;
    CGFloat lineY = CGRectGetMaxY(_timeFrame) + margin*2;
    CGFloat lineW = scWidth - leftMargin - margin;
    CGFloat lineH = 1;
    _lineFrame = CGRectMake(lineX, lineY, lineW, lineH);
    
    _rowHeight = CGRectGetMaxY(_lineFrame);
    
    CGFloat lineViewY = CGRectGetMaxY(_imgViewFrame);
    CGFloat lineViewW = 1;
    CGFloat lineViewH = _rowHeight ;
    CGFloat lineViewX = (leftMargin - 1)/2;
    _lineViewFrame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

@end
