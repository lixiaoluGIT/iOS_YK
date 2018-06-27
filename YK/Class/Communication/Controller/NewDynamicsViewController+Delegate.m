//
//  NewDynamicsViewController+Delegate.m
//  LooyuEasyBuy
//
//  Created by LXL on 2018/5/3.
//  Copyright © 2018年 YK. All rights reserved.
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
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationBarHadAppear" object:self userInfo:nil];
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
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationBarHadDisappear" object:self userInfo:nil];
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
    return layout.height+100;
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
//    if (isReporting) {
//        return;
//    }
    isReporting = YES;
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    cell.pl.image = [UIImage imageNamed:@"yidianzan"];
    [cell.pl setUserInteractionEnabled:NO];
    //点赞
    [[YKCommunicationManager sharedManager]setLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        [cell.pl setUserInteractionEnabled:YES];
        isReporting = NO;
        //把当前userid加入点赞数组
        [model.fabulous addObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{

            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
                cell.pl.transform = CGAffineTransformMakeScale(2.1, 2.1);
            }];

            [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
                cell.pl.transform = CGAffineTransformIdentity;
            }];
        } completion:^(BOOL finished) {
            [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }];
}
//取消点赞
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
//    if (isReporting) {
//        return;
//    }
    isReporting = YES;
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    cell.pl.userInteractionEnabled = NO;
    cell.pl.image = [UIImage imageNamed:@"dianzan"];
    [[YKCommunicationManager sharedManager]cancleLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        isReporting = NO;
        cell.pl.userInteractionEnabled = YES;
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
    
    if ([model.classify isEqual:@"1"]) {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    } else  if ([model.classify isEqual:@"2"]) {
        YKSPDetailVC *detail = [[YKSPDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    }
    

    
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

//关注
- (void)DidConcernInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    [[YKCommunicationManager sharedManager]setConcernWithUserId:model.userId OnResponse:^(NSDictionary *dic) {
       __block BOOL isContain = NO;
        [[YKCommunicationManager sharedManager].concernArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *s = [NSString stringWithFormat:@"%@",obj];
            NSString *s1 = [NSString stringWithFormat:@"%@",model.userId];
            if ([s isEqual:s1]) {
                isContain = YES;
                NSLog(@"%@-索引%d",obj, (int)idx);
            }
        }];
        if (!isContain) {
            [[YKCommunicationManager sharedManager].concernArray addObject:model.userId];
        }
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
//取消关注
- (void)DidCancelConcernInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    [[YKCommunicationManager sharedManager]cancleConcernWithUserId:model.userId OnResponse:^(NSDictionary *dic) {
    __block  NSMutableArray *cArray = [NSMutableArray array];
        [[YKCommunicationManager sharedManager].concernArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *s = [NSString stringWithFormat:@"%@",obj];
            NSString *s1 = [NSString stringWithFormat:@"%@",model.userId];
            [cArray addObject:s];
            if ([s isEqual:s1]) {
                [cArray removeObject:s1];
            }
            [YKCommunicationManager sharedManager].concernArray = [NSMutableArray arrayWithArray:cArray];
        }];
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
@end
