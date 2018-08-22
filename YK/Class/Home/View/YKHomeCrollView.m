//
//  YKHomeCrollView.m
//  YK
//
//  Created by edz on 2018/8/20.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHomeCrollView.h"
#import "CGQCollectionViewCell.h"
@interface YKHomeCrollView()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *eng;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end

@implementation YKHomeCrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.contentSize=CGSizeMake((WIDHT)*5,0);
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setUserInteractionEnabled:YES];
    [_rightImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(block)];
    [_rightImage addGestureRecognizer:tap];
    
    _eng.numberOfLines = 0;
    
    //    _eng.backgroundColor = [UIColor greenColor];
    
    //    _eng.font = FONT(15);
    
    _eng.lineBreakMode = NSLineBreakByCharWrapping;
    
    //设置字间距
    
    NSDictionary *dic = @{NSKernAttributeName:@4.f
                          
                          };
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_eng.text attributes:dic];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //    [paragraphStyle setLineSpacing:30];//行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_eng.text length])];
    
    [_eng setAttributedText:attributedString];
    
    [_eng sizeToFit];
}

- (void)initWithType:(NSInteger)type productList:(NSArray *)productList OnResponse:(void (^)(void))onResponse{
    
    self.toAllBlock = onResponse;
    if (type==1) {//服装
        _logo.image = [UIImage imageNamed:@"rqmy"];
        _title.text = @"人气美衣";
        _eng.text = @"Beautiful clothes";
        //布局
        CGFloat w = (WIDHT-30)/2;
        for (int i=0; i<5; i++) {
            CGQCollectionViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CGQCollectionViewCell" owner:nil options:nil][0];
            cell.frame = CGRectMake(10+(w+10)*i, 0, w, w*240/140);
            [self.scrollView addSubview:cell];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:@"http://img-cdn.xykoo.cn/clothing/蕾丝印花猫上衣/clothingImg0"]] placeholderImage:[UIImage imageNamed:@"商品图"]];
            
        }
        self.scrollView.contentSize= CGSizeMake(10+(w+10)*5,0);
        
        self.scrollView.scrollEnabled = YES;
    }
    if (type==2) {//配饰
        //布局
        _logo.image = [UIImage imageNamed:@"rqps"];
        _title.text = @"人气配饰";
        _eng.text = @"Personal accessories";
        CGFloat w = (WIDHT-30)/2;
        for (int i=0; i<5; i++) {
            CGQCollectionViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CGQCollectionViewCell" owner:nil options:nil][0];
            cell.frame = CGRectMake(10+(w+10)*i, 0, w, w*240/140);
            [self.scrollView addSubview:cell];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:@"http://img-cdn.xykoo.cn/clothing/少女心条纹耳饰59344/clothingImg0"]] placeholderImage:[UIImage imageNamed:@"商品图"]];
            
        }
        self.scrollView.contentSize= CGSizeMake(10+(w+10)*5,0);
        
        self.scrollView.scrollEnabled = YES;
    }
    
    if (type==3) {//精选晒图
        //布局
        _logo.image = [UIImage imageNamed:@"sqst"];
        _title.text = @"精美晒图";
        _eng.text = @"Community sun map";
    //图片
        CGFloat w = (WIDHT-30)/2;
        for (int i=0; i<5; i++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*i, 0, w, w*240/140)];
            [image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:@"http://img-cdn.xykoo.cn/1031726724860481536"]] placeholderImage:[UIImage imageNamed:@"商品图"]];
            [self.scrollView addSubview:image];
//            image setContentMode:<#(UIViewContentMode)#>
        }
        self.scrollView.contentSize= CGSizeMake(10+(w+10)*5,0);
        
        self.scrollView.scrollEnabled = YES;
    }
  
    
    
//    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
//    YKProduct *procuct = [[YKProduct alloc]init];
//    [procuct initWithDictionary:self.productArray[indexPath.row]];
//    cell.product = procuct;
}

- (void)block{
    if (self.toAllBlock) {
        self.toAllBlock();
    }
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
@end
