//
//  YKOrderDetailHeader.h
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKOrderDetailHeader : UIView

@property (nonatomic,strong)NSArray *productArray;

- (void)initWithDic:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
