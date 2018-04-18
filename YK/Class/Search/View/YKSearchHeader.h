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


@property (nonatomic,copy)void (^filterBlock)(NSString *categoryId,NSString *sortId);

@property (nonatomic,copy)void (^clickALLBlock)(void);

- (void)setCategoryList:(NSMutableArray *)CategoryList CategoryIdList:(NSMutableArray *)CategoryIdList sortIdList:(NSMutableArray *)sortIdList sortList:(NSMutableArray *)sortList;
@end
