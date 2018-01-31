//
//  YKScrollView.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKScrollView.h"
#import "YKScrollBtnView.h"

#import "YKRollView.h"

@interface YKScrollView()<UIScrollViewDelegate,RollViewDelegate>

@property (nonatomic, strong) YKRollView *rollView;
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
    
    self.rollView = [[YKRollView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 150) withDistanceForScroll:12.0f withGap:8.0f];
    
    /** 全屏宽滑动 视图之间间隙,  将 Distance 设置为 -12.0f */
    // self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150) withDistanceForScroll: -12.0f withGap:8.0f];
    // self.rollView.backgroundColor = [UIColor blackColor];
    
    self.rollView.delegate = self;
    
//    [self addSubview:self.rollView];
    
    
    NSArray *arr = @[@"newka.png",
                     @"liutao.jpg",
                     @"timg.jpg"];
    
//    [self.rollView rollView:self.brandArray];
 
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
//        Tag值设为品牌ID
//        CGFloat w = WIDHT-60;
        btn.frame = CGRectMake(20+(100+20)*i, 0, 100, 150);

        [self.scrollView addSubview:btn];
//        btn.backgroundColor = [UIColor colorWithHexString:@"fe7310"];
//        self.scrollView.contentOffset=CGPointMake((WIDHT-20)*i, 0);
    }
    
    self.scrollView.contentSize = CGSizeMake((brandArray.count-1)*140+100, 0);
//    self.scrollView.pagingEnabled = YES;
}
#pragma mark - 滚动视图协议
-(void)didSelectPicWithIndexPath:(NSInteger)index{
    
    if (index != -1) {
        
        NSLog(@"%ld", (long)index);
        if (self.toDetailBlock) {
                            self.toDetailBlock(self.brandArray[index-1][@"brandId"] ,self.brandArray[index-1][@"brandName"]);
                        }
    }
    
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
