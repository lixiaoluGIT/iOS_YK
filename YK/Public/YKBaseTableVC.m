//
//  YKBaseTableVC.m
//  YK
//
//  Created by LXL on 2018/1/24.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseTableVC.h"

@interface YKBaseTableVC ()<UINavigationControllerDelegate>
{
    UIPercentDrivenInteractiveTransition *interactiveTransition;
}

@end

@implementation YKBaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
