//
//  YKSearchHeader.h
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSearchHeader : UITableViewCell

//FilterBlock
//@property (nonatomic,copy)void (^filterTypeBlock)(NSInteger categoryId);
//@property (nonatomic,copy)void (^filterSortBlock)(NSInteger sortId);


@property (nonatomic,copy)void (^filterBlock)(NSString *categoryId,NSString *styleId,NSString *seasonId);

@property (nonatomic,copy)void (^clickALLBlock)(void);

@property (nonatomic,assign)BOOL isFromNew;

- (void)setCategoryList:(NSMutableArray *)CategoryList CategoryIdList:(NSMutableArray *)CategoryIdList sortIdList:(NSMutableArray *)sortIdList sortList:(NSMutableArray *)sortList seasons:(NSMutableArray *)seasons seasonIds:(NSMutableArray *)seasonIds;
@end
