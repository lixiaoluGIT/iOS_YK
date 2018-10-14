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

@property (nonatomic,copy)void (^unLikeSelectBlock)(void);

- (void)initWithIsLike:(NSString *)isCollect total:(NSString *)total;
@end
