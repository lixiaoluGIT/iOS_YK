//
//  DDAdvertisementVC.m
//  dongdongcar
//
//  Created by apple on 17/5/22.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import "DDAdvertisementVC.h"

#import "AppDelegate.h"
#import "YKMainVC.h"


@interface DDAdvertisementVC ()
{
    dispatch_source_t _timer;
}
@property (nonatomic,strong)UIButton *jumpBtn;
@end

@implementation DDAdvertisementVC
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [self startTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addBottomView];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];

    [image sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"广告"]];
    [self.view addSubview:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toWeb)];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:tap];
    
    _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_jumpBtn];
    _jumpBtn.frame = CGRectMake(self.view.frame.size.width-100, 20, 80, 30);
    [_jumpBtn setTitle:@"3 跳过" forState:UIControlStateNormal];
    [_jumpBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [_jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    _jumpBtn.layer.masksToBounds = YES;
    _jumpBtn.layer.cornerRadius = 10;
    _jumpBtn.alpha = 0.5;
    _jumpBtn.backgroundColor = [UIColor blackColor];
    _jumpBtn.titleLabel.font = [UIFont fontWithName:@"DB LCD Temp" size:14];
}

- (void)addBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-100, WIDHT, 100)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImgView = [[UIImageView alloc] init];
    [bottomView addSubview:logoImgView];
    logoImgView.image = [UIImage imageNamed:@"logo"];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-22);
        make.centerX.equalTo(bottomView.mas_centerX);
    }];
    
}

- (void)startTimer {
    __block int timeover = 4;
     __weak typeof(self) weakself = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeover == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself jump];
            });
        }
        else {
            timeover--;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_jumpBtn setTitle:[NSString stringWithFormat:@"%d 跳过",timeover] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)jump{
    dispatch_source_cancel(_timer);
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = [YKMainVC new];
}

- (void)toWeb{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
