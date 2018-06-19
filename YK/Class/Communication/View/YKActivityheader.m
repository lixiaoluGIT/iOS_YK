//
//  YKActivityheader.m
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKActivityheader.h"
@interface YKActivityheader()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *attendImage;

@end

@implementation YKActivityheader


- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (void)setActivity:(YKActivity *)activity{
    _activity = activity;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:_activity.exampleDiagram]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    [_headImage setContentMode:UIViewContentModeScaleAspectFill];
    _headImage.layer.masksToBounds = YES;
    _title.text = activity.activityTitle;
//    _content.text = @"6月-7月，带话题并晒出自己最美的背影照参与本次活动，每周点赞前三名可获得7天加时卡一张，快来参加吧！";
    _content.text = activity.activityExplain;
}
- (IBAction)attend:(id)sender {
    if (self.attendActivityBlock) {
        self.attendActivityBlock(_activity.activityId);
    }
}

@end
