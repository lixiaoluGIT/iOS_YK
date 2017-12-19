//
//  YKNoDataView.h
//  YK
//
//  Created by LXL on 2017/12/7.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKNoDataView : UITableViewCell

@property(nonatomic,copy)void (^statusActionClick)(void);

- (void)noDataViewWithStatusImage:(UIImage *)imgge statusDes:(NSString *)statusDes hiddenBtn:(BOOL)hiddenBtn actionTitle:(NSString *)actionTitle actionBlock:(void (^)(void))actionBlock;
@end
