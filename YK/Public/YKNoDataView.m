//
//  YKNoDataView.m
//  YK
//
//  Created by LXL on 2017/12/7.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKNoDataView.h"
@interface YKNoDataView()
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusDes;
@property (weak, nonatomic) IBOutlet UIButton *statusAction;

@end
@implementation YKNoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    _statusDes.font = PingFangSC_Regular(kSuitLength_H(12));
}

- (void)noDataViewWithStatusImage:(UIImage *)imgge statusDes:(NSString *)statusDes hiddenBtn:(BOOL)hiddenBtn actionTitle:(NSString *)actionTitle actionBlock:(void (^)(void))actionBlock{
    
    self.statusImage.image = imgge;
    self.statusDes.text = statusDes;
    [self.statusAction setTitle:actionTitle forState:UIControlStateNormal];
    _statusActionClick = actionBlock;
    self.statusAction.hidden = hiddenBtn;
    
}
- (IBAction)statusActionClick:(id)sender {
    if (_statusActionClick) {
        _statusActionClick();
    }
}


@end
