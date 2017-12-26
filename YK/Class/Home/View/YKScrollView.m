//
//  YKScrollView.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKScrollView.h"
#import "YKScrollBtnView.h"

@interface YKScrollView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuijianImage;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLable;

@property (nonatomic,strong)NSString *brandId;

@end
@implementation YKScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //[self setUpView];
    
}

- (void)setBrandArray:(NSMutableArray *)brandArray{
    _brandArray = brandArray;
    
    [self.allLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAll)];
    [self.allLabel addGestureRecognizer:tap];
    for (int i = 0; i<brandArray.count; i++) {
        YKScrollBtnView *btn=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollBtnView" owner:self options:nil][0];
        [btn.image sd_setImageWithURL:[NSURL URLWithString:brandArray[i][@"brandLargeLogo"]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
        btn.title.text = brandArray[i][@"brandName"];
        btn.brandId = brandArray[i][@"brandId"];
        btn.clickDetailBlock = ^(NSString *brandId){
            if (self.toDetailBlock) {
                self.toDetailBlock(brandId);
            }
        };
        btn.image.contentMode   = UIViewContentModeScaleAspectFill;
        btn.image.clipsToBounds = YES;
        //Tag值设为品牌ID
        btn.frame = CGRectMake(20+(100+20)*i, 0, 100, 150);

        [self.scrollView addSubview:btn];

    }
    self.scrollView.contentSize = CGSizeMake((brandArray.count+1)*100+60, 0);
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
