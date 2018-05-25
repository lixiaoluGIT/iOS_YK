//
//  YKALLBrandCell.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320
#define kHeight(R) (iPhone4?((R)*(kScreenHeight)/480):((R)*(kScreenHeight)/568))

#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度
#import "YKALLBrandCell.h"
#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
@interface YKALLBrandCell()
@property (nonatomic) UILabel *labName;          //标题
@property (nonatomic) UIImageView *imgHead;      //头像
@property (nonatomic) NSString *headurl;

@end
@implementation YKALLBrandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 41, 41)];
        
        self.imgHead.image = [UIImage imageNamed:@"1"];
        [self addSubview:self.imgHead];
        //列表中姓名
        self.labName = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(self.imgHead) +10, Y(self.imgHead), 150, HEIGHT(self.imgHead))];
        self.labName.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        self.labName.font = [UIFont systemFontOfSize:14];
        self.labName.text = @"ZARA";
        [self addSubview:self.labName];
    }
    return self;
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

- (void)initWithDictionary:(NSDictionary *)dic{
    self.brandId = [NSString stringWithFormat:@"%@",dic[@"brandId"]];
    self.headurl = [NSString stringWithFormat:@"%@",dic[@"brandLittleLogo"]];
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.headurl]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
    
    self.labName.text = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
    self.brandName = self.labName.text;
}


@end
