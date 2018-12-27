//
//  YKDetailFootView.h
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKProductDetail;
@interface YKDetailFootView : UITableViewCell

//@property (nonatomic,strong)YKProductDetail *productDetail;

@property (nonatomic,copy)void (^AddToCartBlock)(void);

@property (nonatomic,copy)void (^ToSuitBlock)(void);

@property (nonatomic,copy)void (^likeSelectBlock)(BOOL isLike);

@property (nonatomic,copy)void (^buyBlock)(void);

@property (nonatomic,copy)void (^unLikeSelectBlock)(void);

- (void)initWithIsLike:(NSString *)isCollect total:(NSString *)total;

@property (nonatomic,assign)BOOL canBuy;//是否可购买

@property (nonatomic,assign)BOOL hadStock;//所选尺码是否有库存
@end
