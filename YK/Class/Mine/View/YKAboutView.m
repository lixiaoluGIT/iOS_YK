//
//  YKAboutView.m
//  YK
//
//  Created by LXL on 2018/1/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAboutView.h"

@interface YKAboutView()
@property (weak, nonatomic) IBOutlet UILabel *currentVersion;

@end

@implementation YKAboutView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    _currentVersion.text = localVersion;
}
- (IBAction)toxieyi:(id)sender {
    if (self.toXieYi) {
        self.toXieYi();
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
