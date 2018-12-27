//
//  YKSizeTitleView.h
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSizeTitleView : UIView
@property (nonatomic,assign)BOOL hasEditSize;//是否添加尺码
@property (nonatomic,strong)NSString *recSize;//推荐的尺码
@property (nonatomic,copy)void (^toEditSizeBlock)(void);
@end
