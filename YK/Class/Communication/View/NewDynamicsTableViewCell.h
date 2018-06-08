//
//  NewDynamicsTableViewCell.h
//  LooyuEasyBuy
//
//  Created by LXL on 2018/5/3.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDynamicsLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "JRMenuView.h"
#import "YKCommunicationImageView.h"
@class NewDynamicsTableViewCell;
@protocol NewDynamicsCellDelegate;

@interface NewDynamicsGrayView : UIView

@property(nonatomic,strong)UIButton * grayBtn;
@property(nonatomic,strong)UIImageView * thumbImg;//头像
@property(nonatomic,strong)YYLabel * dspLabel;//描述

@property(nonatomic,strong)NewDynamicsTableViewCell * cell;

@end

@interface NewDynamicsThumbCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIImageView * bgImgView;
@property(nonatomic,strong)YYLabel * thumbLabel;
@property(nonatomic,strong)UIView * dividingLine;
@property(nonatomic,strong)NSMutableArray * likeArray;
@property(nonatomic,strong)NSMutableArray * commentArray;
@property(nonatomic,strong)NewDynamicsLayout * layout;
@property(nonatomic,strong)UITableView * commentTable;

@property(nonatomic,strong)NewDynamicsTableViewCell * cell;

- (void)setWithLikeArr:(NSMutableArray *)likeArr CommentArr:(NSMutableArray *)commentArr DynamicsLayout:(NewDynamicsLayout *)layout;

@end

@interface NewDynamicsTableViewCell : UITableViewCell<JRMenuDelegate>

@property (nonatomic,assign)BOOL isShowInProductDetail;//在商品详情页
@property (nonatomic,assign)BOOL isShowOnComments;//在所有评论界面

@property(nonatomic,strong)NewDynamicsLayout * layout;

@property(nonatomic,strong)UIImageView * portrait;
@property(nonatomic,strong)YYLabel * nameLabel;
@property(nonatomic,strong)YYLabel * detailLabel;
@property(nonatomic,strong)UIButton * moreLessDetailBtn;
//@property(nonatomic,strong)SDWeiXinPhotoContainerView *picContainerView;
//
@property(nonatomic,strong)YKCommunicationImageView *picContainerView;
@property(nonatomic,strong)NewDynamicsGrayView * grayView;
@property(nonatomic,strong)UIButton * spreadBtn;
@property(nonatomic,strong)UILabel * dateLabel;
@property(nonatomic,strong)UIImageView * pl;
@property(nonatomic,strong)YYLabel * plNum;
@property(nonatomic,strong)UIImageView * dz;
@property(nonatomic,strong)YYLabel * dzNum;
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * menuBtn;
@property(nonatomic,strong)UIButton *linkBtn;
@property(nonatomic,strong)UIImageView *linkImage;
@property(nonatomic,strong)NewDynamicsThumbCommentView * thumbCommentView;
@property(nonatomic,strong)UIView * dividingLine;

@property (nonatomic,strong)UILabel *bigL;

@property(nonatomic,strong)JRMenuView * jrMenuView;

@property(nonatomic,assign)id<NewDynamicsCellDelegate>delegate;

@end

@protocol NewDynamicsCellDelegate <NSObject>
/**
 点击了用户头像或名称

 @param userId 用户ID
 */
//- (void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUser:(NSString *)userId;
- (void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUser:(UIImageView *)image;

/**
 点击了全文/收回

 */
- (void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 点击了推广按钮

 */
- (void)DidClickSpreadInDynamicsCell:(NewDynamicsTableViewCell *)cell;
/**
 点击了灰色详情

 */
- (void)DidClickGrayViewInDynamicsCell:(NewDynamicsTableViewCell *)cell;
/**
 点赞

 */
- (void)DidClickThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 取消点赞

 */
- (void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 评论

 */
- (void)DidClickCommentInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 私聊

 */
- (void)DidClickChatInDynamicsCell:(NewDynamicsTableViewCell *)cell;
/**
 分享

 */
- (void)DidClickShareInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 删除

 */
- (void)DidClickDeleteInDynamicsCell:(NewDynamicsTableViewCell *)cell;

/**
 点击了评论

 @param commentModel 评论模型
 */
- (void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickComment:(DynamicsCommentItemModel *)commentModel;
/**
 点击了网址或电话号码
 @param url 网址链接
 @param phoneNum 电话号
 */
- (void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum;
@end


