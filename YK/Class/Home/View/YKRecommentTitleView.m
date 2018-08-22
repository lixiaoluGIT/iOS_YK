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
    
    _eng.numberOfLines = 0;
    
//    _eng.backgroundColor = [UIColor greenColor];
    
//    _eng.font = FONT(15);
    
//    _eng.lineBreakMode = NSLineBreakByCharWrapping;
    
    //设置字间距
    
//    NSDictionary *dic = @{NSKernAttributeName:@4.f
//
//                          };
    
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_eng.text attributes:dic];
//
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
////    [paragraphStyle setLineSpacing:30];//行间距
//
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_eng.text length])];
//
//    [_eng setAttributedText:attributedString];
//
//    [_eng sizeToFit];

}

- (void)reSetTitle{
    self.title.text = @"相关推荐";
    self.image.image = [UIImage imageNamed:@"xiangguantuijian"];
    _eng.hidden = YES;
}

@end
