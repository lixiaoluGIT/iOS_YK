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
@property (nonatomic,assign)BOOL hasEditSize;//是否添加尺码
@property (nonatomic,strong)NSString *recSize;//推荐的尺码
@end
