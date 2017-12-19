//
//  YKSuitCell.h
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSuit.h"
@interface YKSuitCell : UITableViewCell

@property (nonatomic,strong)YKSuit *suit;
@property (nonatomic,copy)void (^selectClickBlock)(NSInteger status);
@property (nonatomic,assign)CGFloat cellH;
@property (nonatomic,strong)NSString *suitStatus;//有无库存
@property (nonatomic,assign)BOOL selectStatus;
@property (nonatomic,strong)NSString *suitId;

+ (CGFloat)heightForCell:(NSString *)suitStatus;
- (void)setSelectBtnStatus:(NSInteger)sype;
//确认衣袋调用
//@property (nonatomic,strong)YKSuit *suit2;
//
//- (void)setContentWithSuit:(YKSuit *)suit;
@end
