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

@end

@implementation YKHomeDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    _image.layer.masksToBounds = YES;
//    _image.frame.size.height = 86; = 86;
//    _image.size.width
//    [_image setContentMode:UIViewContentModeScaleAspectFill];
    // Initialization code
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
    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
    
    [[self getCurrentVC] presentViewController:nav animated:YES completion:^{
        
    }];
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
