//
//  YKHomeDesCell.h
//  YK
//
//  Created by EDZ on 2018/4/3.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKHomeDesCell : UITableViewCell

@property (nonatomic,copy)void (^toEditSizeBlock)(NSDictionary *dic);

@end
