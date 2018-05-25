//
//  YKProductDetailButtom.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKProductDetailButtom : UITableViewCell

@property (nonatomic,copy)void (^AddToCartBlock)(void);

@property (nonatomic,copy)void (^ToSuitBlock)(void);

@property (nonatomic,copy)void (^KeFuBlock)(void);
@end
