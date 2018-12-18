//
//  YKMineCell.m
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineCell.h"
@interface YKMineCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIma;

@end

@implementation YKMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    // Initialization code
    _title.font = PingFangSC_Regular(kSuitLength_V(14));
    _headIma.hidden = YES;
}

- (void)setImaHidden:(BOOL)imaHidden{
    _imaHidden = imaHidden;
    _headIma.hidden = imaHidden;
}

@end
