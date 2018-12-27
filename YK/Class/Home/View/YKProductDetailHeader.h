//
//  YKProductDetailHeader.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKProductDetail;
@interface YKProductDetailHeader : UITableViewCell


@property (nonatomic,copy)void (^toDetailBlock)(NSInteger brandId,NSString *brandName);
@property (nonatomic,copy)void (^selectBlock)(NSString *typeId,NSString *type,BOOL hadStock);
@property (nonatomic,strong)NSDictionary *product;

@property (nonatomic,strong)NSDictionary *brand;

@property (nonatomic,strong)NSString *recomment;

@property (nonatomic,strong)NSString *clothingCreatedate;
- (void)resetUI;
@end

@interface YKSizeView : UIView

- (void)initViewWithArray:(NSArray *)array;
@property (nonatomic,copy)void (^selectBlock)(NSString *clothingStockId,NSString *clothingStockType,BOOL hadStock);



@end
