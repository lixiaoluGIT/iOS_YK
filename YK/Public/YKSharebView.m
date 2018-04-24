//
//  YKSharebView.m
//  YK
//
//  Created by EDZ on 2018/3/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSharebView.h"

@interface YKSharebView()


@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;
@property (weak, nonatomic) IBOutlet UILabel *inviteCode;
@end

@implementation YKSharebView

- (void)awakeFromNib {
    [super awakeFromNib];
    _inviteCode.text = [YKUserManager sharedManager].user.inviteCode;
    
}




@end
