//
//  YKHomeDesCell.m
//  YK
//
//  Created by EDZ on 2018/4/3.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHomeDesCell.h"
#import "YKToBeVIPVC.h"
#import "YKLoginVC.h"

@interface YKHomeDesCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *mySize;
@property (weak, nonatomic) IBOutlet UILabel *edit;
@property (weak, nonatomic) IBOutlet UILabel *lll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation YKHomeDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    _image.layer.masksToBounds = YES;
    _mySize.font = PingFangSC_Regular(kSuitLength_H(14));
    _edit.font = PingFangSC_Regular(kSuitLength_H(12));
    _lll.font = PingFangSC_Regular(kSuitLength_H(14));
//    _image.frame.size.height = 86; = 86;
//    _image.size.width
//    [_image setContentMode:UIViewContentModeScaleAspectFill];
    // Initialization code
    _gap.constant = kSuitLength_H(20);
//    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _editBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
//    [_editBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    _editBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//    _editBtn.layer.masksToBounds = YES;
//    _editBtn.layer.cornerRadius = _editBtn.frame.size.height/2;
}

- (void)setRecSize:(NSString *)recSize{
    _recSize = recSize;
    if (_hasEditSize) {//已添加尺码
        
        if (recSize.length==0) {//没有推荐
            [_editBtn setTitle:@"暂无推荐尺码" forState:UIControlStateNormal];
            [_editBtn setImage:[UIImage imageNamed:@"右-2尺码详情"] forState:UIControlStateNormal];
            [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
        }else {
            [_editBtn setTitle:[NSString stringWithFormat:@"为我推荐%@",recSize] forState:UIControlStateNormal];
            [_editBtn setImage:[UIImage imageNamed:@"右-2尺码详情"] forState:UIControlStateNormal];
            [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
            _editBtn.backgroundColor = [UIColor redColor];
        }
    }else {
        [_editBtn setTitle:@"编辑我的尺码" forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"右-2编辑尺码"] forState:UIControlStateNormal];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(100, 60, 0, 0)];
    }
}
- (void)click{
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];
//        YKLoginVC *vip = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
//
//        [[self getCurrentVC] presentViewController:nav animated:YES completion:^{
//
//        }];
        return;
    }
    if (self.toEditSizeBlock) {
        self.toEditSizeBlock(nil);
    }
//    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
//
//    [[self getCurrentVC] presentViewController:nav animated:YES completion:^{
//
//    }];
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    
    return result;
}
- (IBAction)toEditSize:(id)sender {
    if (self.toEditSizeBlock) {
        self.toEditSizeBlock(nil);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
