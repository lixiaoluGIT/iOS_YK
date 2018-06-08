//
//  YKBaseVC.m
//  YK
//
//  Created by LXL on 2018/1/24.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseVC.h"

@interface YKBaseVC ()<UINavigationControllerDelegate>
{
    UIPercentDrivenInteractiveTransition *interactiveTransition;
}
@end

@implementation YKBaseVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = _titleS;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 20, 44);
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
//        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
//    }
//    btn.adjustsImageWhenHighlighted = NO;
//    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
//    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
//        negativeSpacer.width = -18;
//    }
//    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
//    title.text = self.title;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
//    title.font = PingFangSC_Semibold(20);
//    
//    self.navigationItem.titleView = title;
    self.navigationController.delegate = self; // 设置navigationController的代理为self,并实现其代理方法
    
//    self.view.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backHandle:)];
//    [self.view addGestureRecognizer:panGesture];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGestureRight];
//
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
//
//    [self.view addGestureRecognizer:panGesture];


}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer

shouldRecognizeSimultaneouslyWithGestureRecognizer:

(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    //如果往左滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        //先加载数据，再加载动画特效
    }
    
    //如果往右滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)backHandle:(UIPanGestureRecognizer *)recognizer
{
    [self customControllerPopHandle:recognizer];
}

- (void)customControllerPopHandle:(UIPanGestureRecognizer *)recognizer
{
    if(self.navigationController.childViewControllers.count == 1)
    {
        return;
    }
    // _interactiveTransition就是代理方法2返回的交互对象，我们需要更新它的进度来控制POP动画的流程。（以手指在视图中的位置与屏幕宽度的比例作为进度）
    CGFloat process = [recognizer translationInView:self.view].x/self.view.bounds.size.width;
    process = MIN(1.0, MAX(0.0, process));
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        // 此时，创建一个UIPercentDrivenInteractiveTransition交互对象，来控制整个过程中动画的状态
        interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [interactiveTransition updateInteractiveTransition:process]; // 更新手势完成度
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded ||recognizer.state == UIGestureRecognizerStateCancelled)
    {
        // 手势结束时，若进度大于0.5就完成pop动画，否则取消
        if(process > 0.5)
        {
            [interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [interactiveTransition cancelInteractiveTransition];
        }
        
        interactiveTransition = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
