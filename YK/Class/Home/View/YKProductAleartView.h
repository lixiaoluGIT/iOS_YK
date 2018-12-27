//
//  YKProductAleartView.h
//  YK
//
//  Created by edz on 2018/10/15.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKProductType.h"

@interface YKProductAleartView : UITableViewCell

@property (nonatomic,copy)void (^selectBlock)(NSString *typeId,NSString *type);
@property (nonatomic,copy)void (^disBLock)(void);
@property (nonatomic,copy)void (^addTOCartBlock)(NSString *type);
@property (nonatomic,copy)void (^favouriteBlock)(NSString *type);
@property (nonatomic,copy)void (^buyBlock)(NSString *type);
@property (nonatomic,strong)NSDictionary *product;

@property (nonatomic,assign)NSInteger type;

@end

@interface YKNewSizeView : UIView
@property (nonatomic,assign) NSInteger selectindex;
- (void)initViewWithArray:(NSArray *)array;
@property (nonatomic,copy)void (^selectBlock)(NSString *clothingStockId,NSString *clothingStockType);
@property (nonatomic,copy)void (^selectTypeBlock)(BOOL hadStock);
@end
