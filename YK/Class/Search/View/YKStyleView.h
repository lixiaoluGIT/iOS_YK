//
//  YKStyleView.h
//  YK
//
//  Created by edz on 2018/6/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKStyleView : UIView

@property (nonatomic,strong)NSMutableArray *styleArray;//数据源 品牌
@property (nonatomic,strong)NSMutableArray *activityArray;//活动
@property (nonatomic,copy)void (^toDetailBlock)(NSString *styleId,NSString *styleName);
@end
