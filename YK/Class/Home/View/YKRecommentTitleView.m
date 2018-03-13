//
//  YKRecommentTitleView.m
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKRecommentTitleView.h"

@interface YKRecommentTitleView()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *eng;

@end
@implementation YKRecommentTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reSetTitle{
    self.title.text = @"相关推荐";
    self.image.image = [UIImage imageNamed:@"xiangguantuijian"];
    _eng.hidden = YES;
}

@end
