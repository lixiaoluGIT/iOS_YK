//
//  YKSMSStatusView.h
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSMSStatusView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recMan;
- (void)initWithOrderId:(NSString *)orderId orderStatus:(NSString *)orderStatus phone:(NSString *)phone;
@end
