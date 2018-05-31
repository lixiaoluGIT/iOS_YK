//
//  YKSuitHeader.h
//  YK
//
//  Created by LXL on 2017/12/13.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSuitHeader : UITableViewCell
@property (nonatomic,copy)void (^SMSBlock)(void);//物流信息
@property (nonatomic,copy)void (^ensureReceiveBlock)(void);//确认收货
@property (nonatomic,copy)void (^orderBackBlock)(void);//预约归还
@property (weak, nonatomic) IBOutlet UILabel *yuyue;

- (void)resetUI:(NSInteger)status;
@end
