//
//  YKScrollView.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKScrollView.h"
#import "YKScrollBtnView.h"

@interface YKScrollView()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuijianImage;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLable;

@property (nonatomic,strong)NSString *brandId;

@end
@implementation YKScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
}

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

- (void)setBrandArray:(NSMutableArray *)brandArray{
    _brandArray = brandArray;
    
    [self.allLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAll)];
    [self.allLabel addGestureRecognizer:tap];
    for (int i = 0; i<brandArray.count; i++) {
        YKScrollBtnView *btn=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollBtnView" owner:self options:nil][0];
        NSString *s = [NSString stringWithFormat:@"%@",brandArray[i][@"brandLargeLogo"]];
        [btn.image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
        btn.title.text = brandArray[i][@"brandName"];
        btn.brandId = brandArray[i][@"brandId"];
        btn.clickDetailBlock = ^(NSString *brandId,NSString *brandName){
            if (self.toDetailBlock) {
                self.toDetailBlock(brandId, brandArray[i][@"brandName"]);
            }
        };
        btn.image.contentMode   = UIViewContentModeScaleAspectFill;
        btn.image.clipsToBounds = YES;
        //Tag值设为品牌ID
        CGFloat w = WIDHT-60;
        btn.frame = CGRectMake(20+(w+20)*i, 0, w, 150);

        [self.scrollView addSubview:btn];
        btn.backgroundColor = [UIColor colorWithHexString:@"fe7310"];

    }
    self.scrollView.contentSize = CGSizeMake((brandArray.count)*(WIDHT-60)+60, 0);
    self.scrollView.pagingEnabled = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    self.scrollView.contentOffset.x == x+20;
}

- (void)clickAll{
    if (self.clickALLBlock) {
        self.clickALLBlock();
    }
}

- (void)resetUI{
    self.tuijianImage.image = [UIImage imageNamed:@"shangxin"];
    self.tuijianLable.text = @"品牌上新";
}
@end
