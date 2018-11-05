//
//  YLCollectionReusableView.m
//  YLTagsChooser
//
//  Created by TK-001289 on 2016/10/31.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLCollectionReusableView.h"

@interface YLCollectionReusableView ()
@property(nonatomic,strong)UILabel *textLabel;
@end

@implementation YLCollectionReusableView
- (void)prepareForReuse
{
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(45 / 2), 0, WIDHT - kSuitLength_H(-45 / 2), self.bounds.size.height)];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.text = @"This is a section header/footer";
        _textLabel.font = PingFangSC_Medium(14);
        _textLabel.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _textLabel.text = title;
}

@end
