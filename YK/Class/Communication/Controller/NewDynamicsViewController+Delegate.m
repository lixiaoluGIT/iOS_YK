//
//  NewDynamicsViewController+Delegate.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/28.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsViewController+Delegate.h"

@implementation NewDynamicsViewController (Delegate)

#pragma mark - TableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if (scrollView==self.dynamicsTable) {
        lastContentOffset = scrollView.contentOffset.y;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [publicBtn setNeedsUpdateConstraints];
    if (scrollView == self.dynamicsTable)
    {
        
        if (scrollView.contentOffset.y< lastContentOffset )
        {
            //向上
//            [ self.navigationController setNavigationBarHidden : NO animated : YES ];
//            NSLog(@"向上");
            [UIView animateWithDuration:0.3 animations:^{
               
                [publicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.top.equalTo(self.view.mas_bottom).offset(-100);
                    if (HEIGHT==812) {
                        make.top.equalTo(self.view.mas_bottom).offset(-150);
                    }
                }];
            }];
            [publicBtn.superview layoutIfNeeded];//强制绘制
        } else if (scrollView. contentOffset.y >lastContentOffset )
        {
            //向下
//            NSLog(@"向下");
            [UIView animateWithDuration:0.3 animations:^{
//                [publicBtn layoutIfNeeded];//这里是关键
                
                [publicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.top.equalTo(self.view.mas_bottom);
                    if (HEIGHT==812) {
                        make.top.equalTo(self.view.mas_bottom);
                    }
                }];
            }];
            [publicBtn.superview layoutIfNeeded];//强制绘制
//            [ self.navigationController setNavigationBarHidden : YES animated : YES ];
        }
    
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    return layout.height+75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewDynamicsTableViewCell"];
    cell.layout = self.layoutsArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [JRMenuView dismissAllJRMenu];
}
#pragma mark - ScollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [JRMenuView dismissAllJRMenu];//收回JRMenuView
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.commentInputTF resignFirstResponder];
//}
//点击图片后的方法(即图片的放大全屏效果)
- (void) tapAction{
//    //创建一个黑色背景
//    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
//    self.background = bgView;
//    [bgView setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:bgView];
//
//    //创建显示图像的视图
//    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, WIDHT , HEIGHT)];
//    //要显示的图片，即要放大的图片
//    [imgView setImage:[UIImage imageNamed:@"dog"]];
//    [bgView addSubview:imgView];
//
//    imgView.userInteractionEnabled = YES;
//    //添加点击手势（即点击图片后退出全屏）
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
//    [imgView addGestureRecognizer:tapGesture];
//
//    [self shakeToShow:bgView];//放大过程中的动画
}
-(void)closeView{
    [self.background removeFromSuperview];
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
#pragma mark - NewDynamiceCellDelegate
-(void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUser:(UIImageView *)image
{
//    //创建一个黑色背景
//    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
//    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//    self.background = bgView;
//    [bgView setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:bgView];
//
//    //创建显示图像的视图
//    //初始化要显示的图片内容的imageView（这里位置继续偷懒...没有计算）
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:bgView.bounds];
//    //要显示的图片，即要放大的图片
//    imgView.image = [UIImage imageNamed:@"dianzan"]
//    [bgView addSubview:imgView];
//
//    imgView.userInteractionEnabled = YES;
//    //添加点击手势（即点击图片后退出全屏）
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
//    [imgView addGestureRecognizer:tapGesture];
//
//    [self shakeToShow:bgView];//放大过程中的动画
    NSLog(@"点击了用户");
}
-(void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    layout.model.isOpening = !layout.model.isOpening;
    [layout resetLayout];
    CGRect cellRect = [self.dynamicsTable rectForRowAtIndexPath:indexPath];

    [self.dynamicsTable reloadData];

    if (cellRect.origin.y < self.dynamicsTable.contentOffset.y + 64) {
        [self.dynamicsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(void)DidClickGrayViewInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了灰色区域");
}
//点赞
-(void)DidClickThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    //点赞
    [[YKCommunicationManager sharedManager]setLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
        [model.fabulous addObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"Andy",@"nick", nil];
//    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.fabulous];
//    [newThumbArr addObject:dic];
//
//    model.fabulous = [newThumbArr copy];
////    [layout resetLayout];
//    [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//取消点赞
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    [[YKCommunicationManager sharedManager]cancleLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
        [model.fabulous removeObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

//    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.fabulous];
//    WS(weakSelf);
//    [newThumbArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSDictionary * thumbDic = obj;
//        if ([thumbDic[@"userid"] isEqualToString:@"12345678910"]) {
//            [newThumbArr removeObject:obj];
//            model.fabulous = [newThumbArr copy];
//            [layout resetLayout];
//            [weakSelf.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            *stop = YES;
//        }
//    }];
}
-(void)DidClickCommentInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    self.commentIndexPath = indexPath;

    self.commentInputTF.placeholder = @"输入评论...";
    [self.commentInputTF becomeFirstResponder];
    self.commentInputTF.hidden = NO;
}
-(void)DidClickSpreadInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了推广");
}
- (void)DidClickDeleteInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.productId = model.clothingId;
    detail.titleStr = @"商品详情";
//    detail.productId = @"438";
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
//    WS(weakSelf);
//    [UIAlertView bk_showAlertViewWithTitle:nil message:@"是否确定删除朋友圈" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
////            [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
//            [weakSelf.dynamicsTable beginUpdates];
//            [weakSelf.layoutsArr removeObjectAtIndex:indexPath.row];
//            [weakSelf.dynamicsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.dynamicsTable endUpdates];
//        }
//    }];
}
-(void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum
{
    if (url) {
        if ([url rangeOfString:@"wemall"].length != 0 || [url rangeOfString:@"t.cn"].length != 0) {
            if (![url hasPrefix:@"http://"]) {
                url = [NSString stringWithFormat:@"http://%@",url];
            }
            NSLog(@"点击了链接:%@",url);
        }else{
//            [SVProgressHUD showErrorWithStatus:@"暂不支持打开外部链接"];
        }
    }
    if (phoneNum) {
        NSLog(@"点击了电话:%@",phoneNum);
    }
}
#pragma mark - UITextfield Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSInteger commentRow = self.commentIndexPath.row;
//    NewDynamicsLayout * layout = [self.layoutsArr objectAtIndex:commentRow];
//    DynamicsModel * model = layout.model;
//        if (![self.commentInputTF.text isEqualToString:@""]) {
//
//            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"andy",@"nick",textField.text,@"message",nil,@"touser",nil,@"tonick", nil];//toUserID可能为nil,需放在最后
//            NSMutableArray * newCommentArr = [NSMutableArray arrayWithArray:model.optcomment];
//            [newCommentArr addObject:dic];
//            model.optcomment = [newCommentArr copy];
//            [layout resetLayout];
//            [self.dynamicsTable reloadRowsAtIndexPaths:@[self.commentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//            self.commentInputTF.text = nil;
//            [self.commentInputTF resignFirstResponder];
//        }
    return YES;
}
@end
