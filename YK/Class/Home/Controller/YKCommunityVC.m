//
//  YKCommunityVC.m
//  YK
//
//  Created by LXL on 2018/3/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCommunityVC.h"

@interface YKCommunityVC ()

@end

@implementation YKCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   YKNoDataView *NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"dingdan"] statusDes:@"社区功能暂未开通" hiddenBtn:YES actionTitle:@"" actionBlock:^{
       
        
    }];
    
    NoDataView.frame = CGRectMake(0, 98+64, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:NoDataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
