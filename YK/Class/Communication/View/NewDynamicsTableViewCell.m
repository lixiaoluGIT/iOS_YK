//
//  NewDynamicsTableViewCell.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsTableViewCell.h"

@implementation NewDynamicsGrayView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = SCREENWIDTH - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;;
        frame.size.height = kDynamicsGrayBgHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.grayBtn];
    [self addSubview:self.thumbImg];
    [self addSubview:self.dspLabel];
    
    [self layout];
}
- (void)layout
{
    _grayBtn.frame = self.frame;
    
    _thumbImg.left = kDynamicsGrayPicPadding;
    _thumbImg.top = kDynamicsGrayPicPadding;
    _thumbImg.width = kDynamicsGrayPicHeight;
    _thumbImg.height = kDynamicsGrayPicHeight;

    _dspLabel.left = _thumbImg.right + kDynamicsNameDetailPadding;
    _dspLabel.width = self.right - kDynamicsNameDetailPadding - _dspLabel.left;
}

-(UIButton *)grayBtn
{
    if (!_grayBtn) {
        _grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _grayBtn.backgroundColor = RGBA_COLOR(240, 240, 242, 1);
        WS(weakSelf);
        [_grayBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.cell.delegate != nil && [weakSelf.cell.delegate respondsToSelector:@selector(DidClickGrayViewInDynamicsCell:)]) {
                [weakSelf.cell.delegate DidClickGrayViewInDynamicsCell:weakSelf.cell];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _grayBtn;
}
-(UIImageView *)thumbImg
{
    if (!_thumbImg) {
        _thumbImg = [UIImageView new];
        _thumbImg.userInteractionEnabled = NO;
        _thumbImg.backgroundColor = [UIColor grayColor];
    }
    return _thumbImg;
}
-(YYLabel *)dspLabel
{
    if (!_dspLabel) {
        _dspLabel = [YYLabel new];
        _dspLabel.userInteractionEnabled = NO;
    }
    return _dspLabel;
}

@end

@implementation NewDynamicsThumbCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = SCREENWIDTH - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;;
        frame.size.height = 0;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.bgImgView];
    [self addSubview:self.thumbLabel];
    [self addSubview:self.dividingLine];
    [self addSubview:self.commentTable];
    
}
- (void)setWithLikeArr:(NSMutableArray *)likeArr CommentArr:(NSMutableArray *)commentArr DynamicsLayout:(NewDynamicsLayout *)layout
{
    _likeArray = likeArr;
    self.commentArray = layout.commentLayoutArr;
    _layout = layout;
    [self layoutView];
}
- (void)layoutView
{
    _bgImgView.top = 0;
    _bgImgView.left = 0;
    _bgImgView.width = self.frame.size.width;
    _bgImgView.height = _layout.thumbCommentHeight;
    
    UIView * lastView = _bgImgView;
    
    if (_likeArray.count != 0) {
        _thumbLabel.hidden = NO;
        _thumbLabel.top = 10;
        _thumbLabel.left = kDynamicsNameDetailPadding;
        _thumbLabel.width = self.frame.size.width - kDynamicsNameDetailPadding*2;
        _thumbLabel.height = _layout.thumbLayout.textBoundingSize.height;
        _thumbLabel.textLayout = _layout.thumbLayout;
        lastView = _thumbLabel;
    }else{
        _thumbLabel.hidden = YES;
    }
    
    
    if (_likeArray.count != 0 && _commentArray.count != 0) {
        _dividingLine.hidden = NO;
        _dividingLine.top = _thumbLabel.bottom;
        _dividingLine.left = 0;
        _dividingLine.width = self.frame.size.width;
        _dividingLine.height = .5;
        lastView = _dividingLine;
    }else{
        _dividingLine.hidden = YES;
    }
    
    if (_commentArray.count != 0) {
        _commentTable.hidden = NO;
        _commentTable.left = _bgImgView.left;
        _commentTable.top = lastView == _dividingLine ? lastView.bottom + .5 : lastView.top + 10;
        _commentTable.width = _bgImgView.width;
        _commentTable.height = _layout.commentHeight;
        
        [_commentTable reloadData];
    }else{
        _commentTable.hidden = YES;
    }
    
}
#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTextLayout * layout = self.commentArray[indexPath.row];
    return layout.textBoundingSize.height + kDynamicsGrayPicPadding*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;//这里不使用重用机制(会出现评论窜位bug)
    
    YYTextLayout * layout = self.commentArray[indexPath.row];

    YYLabel * label;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"commentCell"];
        cell.backgroundColor = [UIColor clearColor];
        label = [YYLabel new];
        [cell addSubview:label];
    }
    
    label.top = kDynamicsGrayPicPadding;
    label.left = kDynamicsNameDetailPadding;
    label.width = self.frame.size.width - kDynamicsNameDetailPadding*2;
    label.height = layout.textBoundingSize.height;
    label.textLayout = layout;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (_cell.delegate != nil && [_cell.delegate respondsToSelector:@selector(DynamicsCell:didClickComment:)]) {
        [_cell.delegate DynamicsCell:_cell didClickComment:(DynamicsCommentItemModel *)_cell.layout.model.commentArr[indexPath.row]];
    }
}
-(UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _bgImgView.image = bgImage;
        _bgImgView.backgroundColor = [UIColor clearColor];
    }
    return _bgImgView;
}
-(YYLabel *)thumbLabel
{
    if (!_thumbLabel) {
        _thumbLabel = [YYLabel new];
    }
    return _thumbLabel;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = RGBA_COLOR(210, 210, 210, 1);
    }
    return _dividingLine;
}
-(UITableView *)commentTable
{
    if (!_commentTable) {
        _commentTable = [UITableView new];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        _commentTable.scrollEnabled = NO;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTable.backgroundColor = [UIColor clearColor];
    }
    return _commentTable;
}
@end

@implementation NewDynamicsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{
    [self.contentView addSubview:self.portrait];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.moreLessDetailBtn];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.spreadBtn];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.menuBtn];
    [self.contentView addSubview:self.thumbCommentView];
    [self.contentView addSubview:self.dividingLine];
    
    //
    
    
    
    [self.contentView addSubview:self.pl];
    [self.contentView addSubview:self.plNum];
    
    [self.contentView addSubview:self.bigL];
    
    [self.contentView addSubview:self.dz];
    [self.contentView addSubview:self.dzNum];
    
    [self.contentView addSubview:self.linkImage];
    [self.contentView addSubview:self.linkBtn];
    
    [self.contentView addSubview:_dateLabel];
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
-(void)setLayout:(NewDynamicsLayout *)layout
{
    UIView * lastView;
    _layout = layout;
    DynamicsModel * model = layout.model;
    
    //头像
    _portrait.left = 14;
    _portrait.top = 24;
    _portrait.size = CGSizeMake(kDynamicsPortraitWidthAndHeight, kDynamicsPortraitWidthAndHeight);
    [_portrait sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:model.headPhoto]]];
    [_portrait sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:model.headPhoto]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    _portrait.layer.masksToBounds = YES;
    _portrait.layer.cornerRadius = 20;
    _portrait.backgroundColor = [UIColor whiteColor];
    
    //昵称
    _nameLabel.text = model.userNickName;
    if ([model.userNickName isEqualToString:@"衣库用户3204"]) {
        _nameLabel.text = @"衣库一哥！";
    }
    if (_isShowInProductDetail) {
        _nameLabel.centerY = _portrait.centerY-7;
    }else {
        _nameLabel.centerY = _portrait.centerY;
    }
    _nameLabel.left = _portrait.right + 10;
    CGSize nameSize = [_nameLabel sizeThatFits:CGSizeZero];
    _nameLabel.width = nameSize.width;
    _nameLabel.height = kDynamicsNameHeight;
    
    
    //描述
    _detailLabel.left = _nameLabel.left;
    _detailLabel.top = _nameLabel.bottom + 10;
    _detailLabel.width = SCREENWIDTH - kDynamicsNormalPadding*2 - 10 - 40;
    _detailLabel.height = layout.detailLayout.textBoundingSize.height;
    _detailLabel.textLayout = layout.detailLayout;
    _detailLabel.textColor = mainColor;
//    _detailLabel.font = PingFangSC_Medium(17);
    lastView = _detailLabel;
    
    //展开/收起按钮
    _moreLessDetailBtn.left = _nameLabel.left;
    _moreLessDetailBtn.top = _detailLabel.bottom + kDynamicsNameDetailPadding;
    _moreLessDetailBtn.height = kDynamicsMoreLessButtonHeight;
    [_moreLessDetailBtn sizeToFit];
    
    if (model.shouldShowMoreButton) {
        _moreLessDetailBtn.hidden = NO;
        
        if (model.isOpening) {
            [_moreLessDetailBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [_moreLessDetailBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
        
        lastView = _moreLessDetailBtn;
    }else{
        _moreLessDetailBtn.hidden = YES;
    }
    //图片集
    if (model.articleImages.count != 0) {
        _picContainerView.hidden = NO;

        _picContainerView.left = _nameLabel.left;
        _picContainerView.top = lastView.bottom + 10;
        _picContainerView.width = layout.photoContainerSize.width;
        _picContainerView.height = layout.photoContainerSize.height;
        _picContainerView.picPathStringsArray = model.articleImages;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
    //头条
//    if (model.pagetype == 1) {
//        _grayView.hidden = NO;
//
//        _grayView.left = _nameLabel.left;
//        _grayView.top = lastView.bottom + kDynamicsNameDetailPadding;
//        _grayView.width = _detailLabel.right - _grayView.left;
//        _grayView.height = kDynamicsGrayBgHeight;
//
//        [_grayView.thumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgHeader,model.thumb]]];
//        _grayView.dspLabel.height = layout.dspLayout.textBoundingSize.height;
//        _grayView.dspLabel.centerY = _grayView.thumbImg.centerY;
//        _grayView.dspLabel.textLayout = layout.dspLayout;
//
//        lastView = _grayView;
//    }else{
        _grayView.hidden = YES;
//    }
    
    //推广
//    _spreadBtn.l÷ameDetailPadding;;
//
//    if (model.spreadparams.count != 0) {
//        _spreadBtn.hidden = NO;
//        [_spreadBtn setTitle:model.spreadparams[@"name"] forState:UIControlStateNormal];
//        CGSize fitSize = [_spreadBtn sizeThatFits:CGSizeZero];
//        _spreadBtn.width = fitSize.width > _detailLabel.size.width ? _detailLabel.size.width : fitSize.width;
//        _spreadBtn.height = kDynamicsSpreadButtonHeight;
//
//        lastView = _spreadBtn;
//    }else if (model.companyparams.count != 0){
//        _spreadBtn.hidden = NO;
//        [_spreadBtn setTitle:model.companyparams[@"name"] forState:UIControlStateNormal];
//        CGSize fitSize = [_spreadBtn sizeThatFits:CGSizeZero];
//        _spreadBtn.width = fitSize.width > _detailLabel.size.width ? _detailLabel.size.width : fitSize.width;
//        _spreadBtn.height = kDynamicsSpreadButtonHeight;
//
//        lastView = _spreadBtn;
//    }else{
//        _spreadBtn.hidden = YES;
//    }
//
////    //时间
//    _dateLabel.right =  - 20;
//    _dateLabel.top = _portrait.top;
//    NSString * newTime = [self formateDate:model.exttime withFormate:@"yyyyMMddHHmmss"];
//    _dateLabel.text = newTime;
//    CGSize dateSize = [_dateLabel sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
//    _dateLabel.width = dateSize.width;
//    _dateLabel.height = kDynamicsNameHeight;
//    _dateLabel.textAlignment = NSTextAlignmentRight;
//    _dateLabel.hidden = YES;
//
    //点赞图
    _pl.left = _detailLabel.left;
    _pl.top = lastView.bottom + 20;
    _pl.width = 18;
    _pl.height = 18;
    
    //添加手势
    
    BOOL hadUserId = NO;
    if ([Token length] == 0) {
        hadUserId = NO;
    }
    if([model.fabulous containsObject:[YKUserManager sharedManager].user.userId]){
        hadUserId = YES;
    }else {
        hadUserId = NO;
    }
    if (hadUserId){
        _pl.image = [UIImage imageNamed:@"dianzan"];
    }else {
        _pl.image = [UIImage imageNamed:@"weidianzan"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (!hadUserId) {//未点赞
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
                [_delegate DidClickThunmbInDynamicsCell:self];
            }
        }else{//已点赞
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickCancelThunmbInDynamicsCell:)]) {
                [_delegate DidClickCancelThunmbInDynamicsCell:self];
            }
        }
    }];
    
    [_pl setUserInteractionEnabled:YES];
    [_pl addGestureRecognizer:tap];
    
 
    _bigL.centerX = _pl.centerX;
    _bigL.centerY = _pl.centerY;
    _bigL.width=_bigL.height = 50;
//    _bigL.backgroundColor = [UIColor lightGrayColor];
    [_bigL setUserInteractionEnabled:YES];
    [_bigL addGestureRecognizer:tap];
    
    //点赞数
    _plNum.left = _pl.right+8;
    _plNum.top = lastView.bottom + 20;
    _plNum.width = 25;
    _plNum.height = 18;
    _plNum.text = [NSString stringWithFormat:@"%ld",model.fabulous.count];
    
    //
    
//    BOOL hadUserId = NO;
//    if ([Token length] == 0) {
//        hadUserId = NO;
//    }
//    if([model.fabulous containsObject:[YKUserManager sharedManager].user.userId]){
//        hadUserId = YES;
//    }else {
//        hadUserId = NO;
//    }
//    if (hadUserId){
//         _pl.image = [UIImage imageNamed:@"dianzan"];
//    }else {
//         _pl.image = [UIImage imageNamed:@"weidianzan"];
//    }
    
//    _linkImage.right = _plNum.right+100;
//    _linkImage.centerY = _plNum.centerY;
//    [_linkImage sizeToFit];
//
//    _linkBtn.right = _linkImage.right+6;
//    _linkBtn.top = _linkImage.top;
//    _linkBtn.width = 70;
//    _linkBtn.height = 20;
 
   
    
    lastView = _plNum;
    
    //链接图
    _linkImage.left = _plNum.right + 195;
    if (WIDHT==375) {
        _linkImage.left = _plNum.right + 160;
    }
    _linkImage.top = _pl.top;
    [_linkImage sizeToFit];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToPro)];
    [_linkImage setUserInteractionEnabled:YES];
    [_linkImage addGestureRecognizer:tap1];
    if (_isShowOnComments) {
        _linkImage.hidden = YES ;
    }else {
        //衣库官方社区置顶，不显示链接按钮
        if ([model.clothingId intValue] == 0) {
            _linkImage.hidden = YES;
        }else {
            _linkImage.hidden = NO;
        }
    }

//    _linkImage.width = 15;
//    _linkImage.height = 15;

//    //链接按钮
//    _linkBtn.left = _linkImage.right+8;
//    _linkBtn.top = _pl.top;
//    _linkBtn.width = 60;
//    _linkBtn.height = 20;
    
    //    //时间
   
    _dateLabel.left = _detailLabel.left;
    _dateLabel.top = lastView.bottom+12;
    NSString * newTime = [self formateDate:model.articleTime withFormate:@"yyyyMMddHHmmss"];
    _dateLabel.text = newTime;
    CGSize dateSize = [_dateLabel sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
    _dateLabel.width = dateSize.width;
    _dateLabel.height = kDynamicsNameHeight;
    _dateLabel.textAlignment = NSTextAlignmentRight;
 
    
    
//    _deleteBtn.left = _dateLabel.right + kDynamicsPortraitNamePadding;
//    _deleteBtn.top = _dateLabel.top;
//    CGSize deleteSize = [_deleteBtn sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
//    _deleteBtn.width = deleteSize.width;
//    _deleteBtn.height = kDynamicsNameHeight;
    
//    //更多
//    _menuBtn.left = _detailLabel.right - 30 + 5;
//    _menuBtn.top = lastView.bottom + kDynamicsPortraitNamePadding - 8;
//    _menuBtn.size = CGSizeMake(30, 30);
//
//    if (model.likeArr.count != 0 || model.commentArr.count != 0) {
//        _thumbCommentView.hidden = NO;
//        //点赞/评论
//        _thumbCommentView.left = _detailLabel.left;
//        _thumbCommentView.top = _dateLabel.bottom + kDynamicsPortraitNamePadding;
//        _thumbCommentView.width = _detailLabel.width;
//        _thumbCommentView.height = layout.thumbCommentHeight;
//
//        [_thumbCommentView setWithLikeArr:model.likeArr CommentArr:model.commentArr DynamicsLayout:layout];
//    }else{
        _thumbCommentView.hidden = YES;
//    }
//
//
//    //分割线
    _dividingLine.left = 0;
    _dividingLine.height = 1;
    _dividingLine.width = SCREENWIDTH ;
    _dividingLine.bottom = layout.height - 1 +75;
//
//    WS(weakSelf);
//    layout.clickUserBlock = ^(NSString *userID) {//点赞评论区域点击用户昵称操作
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
//            [weakSelf.delegate DynamicsCell:weakSelf didClickUser:userID];
//        }
//    };
//
//    layout.clickUrlBlock = ^(NSString *url) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
//            [weakSelf.delegate DynamicsCell:weakSelf didClickUrl:url PhoneNum:nil];
//        }
//    };
//
//    layout.clickPhoneNumBlock = ^(NSString *phoneNum) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
//            [weakSelf.delegate DynamicsCell:weakSelf didClickUrl:nil PhoneNum:phoneNum];
//        }
//    };
    
    
   
    
//    UILabel *bigL = [[UILabel alloc]init];
//    bigL.center = _pl.center;
//    bigL.width = 50;
//    bigL.height = 50;
//    bigL.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:bigL];
//    [bigL setUserInteractionEnabled:YES];
//    [bigL addGestureRecognizer:tap];
}

- (void)jumpToPro{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickDeleteInDynamicsCell:)]) {
        [self.delegate DidClickDeleteInDynamicsCell:self];
    }
}

//#pragma mark - 弹出JRMenu
//- (void)presentMenuController
//{
//    DynamicsModel * model = _layout.model;
//    if (!model.isThumb) {//点赞
//        if (!_jrMenuView) {
//            _jrMenuView = [[JRMenuView alloc] init];
//        }
//        [_jrMenuView setTargetView:_menuBtn InView:self.contentView];
//        _jrMenuView.delegate = self;
//        [_jrMenuView setTitleArray:@[@"点赞",@"评论"]];
//        [self.contentView addSubview:_jrMenuView];
//        [_jrMenuView show];
//    }else{//取消点赞
//        if (!_jrMenuView) {
//            _jrMenuView = [[JRMenuView alloc] init];
//        }
//        [_jrMenuView setTargetView:_menuBtn InView:self.contentView];
//        _jrMenuView.delegate = self;
//        [_jrMenuView setTitleArray:@[@"取消点赞",@"评论"]];
//        [self.contentView addSubview:_jrMenuView];
//        [_jrMenuView show];
//    }
//}
//#pragma mark - 点击JRMenu上的Btn
//-(void)hasSelectedJRMenuIndex:(NSInteger)jrMenuIndex
//{
//    DynamicsModel * model = _layout.model;
//    if (jrMenuIndex == 0) {
//        if (!model.isThumb) {
//            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
//                [_delegate DidClickThunmbInDynamicsCell:self];
//            }
//        }else{
//            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickCancelThunmbInDynamicsCell:)]) {
//                [_delegate DidClickCancelThunmbInDynamicsCell:self];
//            }
//        }
//    }else{
//        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickCommentInDynamicsCell:)]) {
//            [_delegate DidClickCommentInDynamicsCell:self];
//        }
//    }
//}
#pragma mark - getter
-(UIImageView *)portrait
{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = [UIColor grayColor];
        WS(weakSelf);
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.userId];
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:_portrait];
            }
            //点击查看大图
            
        }];
        [_portrait addGestureRecognizer:tapGR];
    }
    return _portrait;
}

//放大过程中出现的缓慢动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
-(YYLabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [YYLabel new];
        _nameLabel.font = PingFangSC_Semibold(16);
        _nameLabel.textColor = [UIColor colorWithHexString:@"133c66"];
        WS(weakSelf);
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.userId];
            }
        }];
        [_nameLabel addGestureRecognizer:tapGR];
    }
    return _nameLabel;
}
-(YYLabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [YYLabel new];
        _detailLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            containerView.backgroundColor = RGBA_COLOR(1, 1, 1, .2);
//            [SVProgressHUD showSuccessWithStatus:@"文字复制成功!"];
            UIPasteboard * board = [UIPasteboard generalPasteboard];
            board.string = text.string;
//            [Utils delayTime:.5 TimeOverBlock:^{
//                containerView.backgroundColor = [UIColor clearColor];
//            }];
        };
        _detailLabel.textColor = [UIColor redColor];
        _detailLabel.font = PingFangSC_Regular(14);
    }
    return _detailLabel;
}
-(UIButton *)moreLessDetailBtn
{
    if (!_moreLessDetailBtn) {
        _moreLessDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreLessDetailBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        _moreLessDetailBtn.hidden = YES;
        WS(weakSelf);
        [_moreLessDetailBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DidClickMoreLessInDynamicsCell:)]) {
                [weakSelf.delegate DidClickMoreLessInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreLessDetailBtn;
}
-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}
-(UIButton *)spreadBtn
{
    if (!_spreadBtn) {
        _spreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _spreadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _spreadBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_spreadBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        WS(weakSelf);
        [_spreadBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickSpreadInDynamicsCell:)]) {
                [weakSelf.delegate DidClickSpreadInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _spreadBtn;
}

-(NewDynamicsGrayView *)grayView
{
    if (!_grayView) {
        _grayView = [NewDynamicsGrayView new];
        _grayView.cell = self;
    }
    return _grayView;
}
-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}
-(UIImageView *)pl {
    if (!_pl) {
        _pl = [UIImageView new];
        _pl.image = [UIImage imageNamed:@"dianzan"];
//        _plNum.textColor = [UIColor lightGrayColor];
//        _plNum.font = [UIFont systemFontOfSize:13];
    }
    return _pl;
}
-(YYLabel *)plNum
{
    if (!_plNum) {
        _plNum = [YYLabel new];
        _plNum.textColor = mainColor;
        _plNum.font = PingFangSC_Semibold(14);
    }
    return _plNum;
}
-(UILabel *)bigL
{
    if (!_bigL) {
        _bigL = [UILabel  new];
//        _bigL.backgroundColor = [UIColor lightGrayColor];
//        _bigL.textColor = mainColor;
//        _bigL.font = PingFangSC_Semibold(14);
    }
    return _bigL;
}
-(UIImageView *)dz {
    if (!_dz) {
        _dz = [UIImageView new];
        _dz.image = [UIImage imageNamed:@"dianzan"];
        
    }
    return _dz;
}
-(YYLabel *)dzNum
{
    if (!_dzNum) {
        _dzNum = [YYLabel new];
        _dzNum.textColor = mainColor;
        _dzNum.font = PingFangSC_Semibold(14);
    }
    return _dzNum;
}
//linkImage
-(UIImageView *)linkImage {
    if (!_linkImage) {
        _linkImage = [UIImageView new];
        _linkImage.image = [UIImage imageNamed:@"查看商品"];
        //        _plNum.textColor = [UIColor lightGrayColor];
        //        _plNum.font = [UIFont systemFontOfSize:13];
    }
    return _linkImage;
}
//linkBtn
-(UIButton *)linkBtn
{
    if (!_linkBtn) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_linkBtn setTitle:@"查看商品" forState:UIControlStateNormal];
//        _linkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _linkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _linkBtn.titleLabel.font = PingFangSC_Semibold(14);
        [_linkBtn setTitleColor:[UIColor colorWithHexString:@"FDDD55"] forState:UIControlStateNormal];
//        _linkBtn.backgroundColor = [UIColor redColor];
        WS(weakSelf);
        [_linkBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickDeleteInDynamicsCell:)]) {
                [weakSelf.delegate DidClickDeleteInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkBtn;
}
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        WS(weakSelf);
        [_deleteBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickDeleteInDynamicsCell:)]) {
                [weakSelf.delegate DidClickDeleteInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
-(UIButton *)menuBtn
{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_menuBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        WS(weakSelf);
        [_menuBtn bk_addEventHandler:^(id sender) {
//            [weakSelf presentMenuController];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}
-(NewDynamicsThumbCommentView *)thumbCommentView
{
    if (!_thumbCommentView) {
        _thumbCommentView = [NewDynamicsThumbCommentView new];
        _thumbCommentView.cell = self;
    }
    return _thumbCommentView;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
//        _dividingLine.alpha = .3;
    }
    return _dividingLine;
}

- (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval interval    =[dateString doubleValue] / 1000.0;
    NSDate *needFormatDate               = [NSDate dateWithTimeIntervalSince1970:interval];
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSString *dateStr = @"";
    
    if (time<=60) {  //// 1分钟以内的
        dateStr = @"刚刚";
    }else if(time<=60*60){  ////  一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){   //// 在两天内的
        
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:ss"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
