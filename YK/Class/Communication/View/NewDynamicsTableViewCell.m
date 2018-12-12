//
//  NewDynamicsTableViewCell.m
//  LooyuEasyBuy
//
//  Created by LXL on 2018/5/3.
//  Copyright © 2017年 YK. All rights reserved.
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
    
//    self.contentView.backgroundColor = [UIColor redColor]
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
    [self.contentView addSubview:self.dLine];
    [self.contentView addSubview:self.Line1];
    [self.contentView addSubview:self.Line2];
    //
    [self.contentView addSubview:self.pl];
//    [self.contentView addSubview:self.plLabel];
    [self.contentView addSubview:self.plNum];
    
    [self.contentView addSubview:self.bigL];
    
    [self.contentView addSubview:self.dz];
    [self.contentView addSubview:self.dzNum];
    
    [self.contentView addSubview:self.linkImage];
    [self.contentView addSubview:self.linkBtn];
    
    [self.contentView addSubview:_dateLabel];
    [self.contentView addSubview:self.guanzhuImage];
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

- (void)reSetUI{
    _plNum.hidden = YES;
    _pl.hidden = YES;
    _linkImage.hidden = YES;
    _dateLabel.hidden = YES;
    _dividingLine.hidden = YES;
    _linkBtn.hidden = YES;
    _dz.hidden = YES;
    _dzNum.hidden = YES;
    _Line1.hidden = YES;
    _Line2.hidden = YES;
    _guanzhuImage.hidden = YES;
    _dividingLine.hidden = YES;
    [_moreLessDetailBtn setTitle:@"..." forState:UIControlStateNormal];
}

-(void)setLayout:(NewDynamicsLayout *)layout
{
    UIView * lastView;
    _layout = layout;
    DynamicsModel * model = layout.model;
    
    //头像
    _portrait.left = 10;
    _portrait.top = 14;
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
    _detailLabel.left = _portrait.left;
    _detailLabel.top = _portrait.bottom + 14;
    _detailLabel.width = SCREENWIDTH - 20;
    _detailLabel.height = layout.detailLayout.textBoundingSize.height;
    _detailLabel.textLayout = layout.detailLayout;
    _detailLabel.textColor = mainColor;
    lastView = _detailLabel;

//
//    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:_detailLabel.text];
//
//    //得到第二个#号的角标
//     NSString *tmpStr = _detailLabel.text;
//
//       NSRange range;
//
//    range = [tmpStr rangeOfString:@"#"];
//    NSString *ok;
//    if (range.location != NSNotFound) {
//
//               NSLog(@"found at location = %lu, length = %lu",(unsigned long)range.location,(unsigned long)range.length);
//
//         ok = [tmpStr substringFromIndex:range.location];
//
//               NSLog(@"=======%@",ok);
//
//           }else{
//
//                   NSLog(@"Not Found");
//
//               }
//
//    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fe7310"] range:NSMakeRange(0,[ok integerValue])];
////
////
//    _detailLabel.attributedText = str2;
    //展开/收起按钮
    _moreLessDetailBtn.left = _portrait.left;
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

        _picContainerView.left = 0;
        _picContainerView.top = lastView.bottom + 14;
        _picContainerView.width = layout.photoContainerSize.width;
        _picContainerView.height = layout.photoContainerSize.height;
        [_picContainerView removeAllSubviews];
        _picContainerView.picPathStringsArray = model.articleImages;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
 
    _grayView.hidden = YES;
    //分割线
    _dLine.left = 0;
    _dLine.height = 1;
    _dLine.width = SCREENWIDTH ;
    _dLine.bottom = lastView.bottom + 14;
    
    //手势
    UITapGestureRecognizer *T = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"分享功能即将开通" delay:2.0];
        
    }];
    //分享图标
    _dz.left = _detailLabel.left+20;
    _dz.top = lastView.bottom + 27;
    [_dz sizeToFit];
    
    //分享文字
//    _dzNum.backgroundColor = [UIColor redColor];
    _dzNum.left = _dz.right + 8;
    _dzNum.top = lastView.bottom+27;
    _dzNum.text = @"分享";
    _dzNum.width = 40;
    _dzNum.height=18;
    [_dz setUserInteractionEnabled:YES];
    [_dzNum setUserInteractionEnabled:YES];
    [_dz addGestureRecognizer:T];
    [_dzNum addGestureRecognizer:T];
    //线1
    _Line1.left = WIDHT/3;
    _Line1.top = lastView.bottom+27;
    _Line1.width = 1;
    _Line1.height = 16;
   //点赞图
    _pl.left = _Line1.right + 50;
    if (WIDHT!=414) {
        _pl.left = _Line1.right + 43;
    }
    _pl.top = lastView.bottom + 27;
    _pl.width = 20;
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
        _pl.image = [UIImage imageNamed:@"yidianzan"];
    }else {
        _pl.image = [UIImage imageNamed:@"dianzan"];
    }
    
    //TODO:设置点击间隔，否则连续点会崩
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (_isReporting) {
            NSLog(@"请求中");
            return ;
            
        }
        _isReporting = YES;
        NSLog(@"去请求");
        if (!hadUserId) {//未点赞
            [_pl setUserInteractionEnabled:NO];
            _plLabel.hidden = NO;
            [self performSelector:@selector(changeStatus) withObject:nil afterDelay:3];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
                [_delegate DidClickThunmbInDynamicsCell:self];
            }
        }else{//已点赞
            [_pl setUserInteractionEnabled:NO];
            _plLabel.hidden = NO;
            [self performSelector:@selector(changeStatus) withObject:nil afterDelay:3];
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
    _plNum.top = lastView.bottom + 27;
    _plNum.width = 25;
    _plNum.height = 18;
    _plNum.text = [NSString stringWithFormat:@"%ld",model.fabulous.count];
    
    //线2
    _Line2.left = WIDHT/3*2;

    _Line2.top = lastView.bottom+27;
    _Line2.width = 1;
    _Line2.height = 16;
    
    _linkImage.left = _Line2.right + 40;
    if (WIDHT!=414) {
        _linkImage.left = _Line2.right + 34;
    }
    _linkImage.top = lastView.bottom+27;
    [_linkImage sizeToFit];

    _linkBtn.left = _linkImage.right+8;
    _linkBtn.top = _linkImage.top;
    _linkBtn.width = 70;
    _linkBtn.height = 18;

    lastView = _plNum;

    //关注图片
   if (WIDHT!=414) {
        _guanzhuImage.left = _linkImage.left+10;
    }else {
         _guanzhuImage.left = _linkImage.left+16;
    }
    _guanzhuImage.top = 30;
    [_guanzhuImage sizeToFit];
    _guanzhuImage.width = 55;
    _guanzhuImage.height = 26;

    
    __block BOOL hadConcern = NO;
    if ([Token length] == 0) {
        hadConcern = NO;
    }
  
    [[YKCommunicationManager sharedManager].concernArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *s = [NSString stringWithFormat:@"%@",obj];
        NSString *s1 = [NSString stringWithFormat:@"%@",model.userId];
        if ([s isEqual:s1]) {
            hadConcern = YES;
        }
    }];

    if (hadConcern) {//已关注
        _guanzhuImage.image = [UIImage imageNamed:@"guanzhu"];
    }else {//未关注
        _guanzhuImage.image = [UIImage imageNamed:@"weiguanzhu"];
    }
    
    UITapGestureRecognizer *TT = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (_isReporting) {
            NSLog(@"请求中");
            return ;
            
        }
        _isReporting = YES;
        if (!hadConcern) {//未关注
            [self performSelector:@selector(changeStatus) withObject:nil afterDelay:3];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidConcernInDynamicsCell:)]) {
                [_delegate DidConcernInDynamicsCell:self];
            }
        }else{//已关注
            [self performSelector:@selector(changeStatus) withObject:nil afterDelay:3];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidCancelConcernInDynamicsCell:)]) {
                [_delegate DidCancelConcernInDynamicsCell:self];
            }
        }
    }];
    [_guanzhuImage setUserInteractionEnabled:YES];
    [_guanzhuImage addGestureRecognizer:TT];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToPro)];
    [_linkImage setUserInteractionEnabled:YES];
    [_linkImage addGestureRecognizer:tap1];
    //全部评论界面
    if (_isShowOnComments) {
        _guanzhuImage.hidden = YES;
        _linkImage.hidden = YES;
        _linkBtn.hidden = YES;
        _Line2.hidden = YES;
        _Line1.left = WIDHT/2;
        _pl.left = _Line1.right + 110;
        _plNum.left = _pl.right+8;
        _bigL.centerX = _pl.centerX;
        _bigL.centerY = _pl.centerY;
        
    }else {
      
        //衣库官方社区置顶，不显示链接按钮
        if ([model.clothingId intValue] == 0) {
//            _guanzhuImage.hidden = YES;
            _linkImage.hidden = YES;
            _linkBtn.hidden = YES;
            _Line2.hidden = YES;
            _Line1.left = WIDHT/2;
            _pl.left = _Line1.right + 110;
            _plNum.left = _pl.right+8;
            _bigL.centerX = _pl.centerX;
            _bigL.centerY = _pl.centerY;
            
        }else {
            _pl.left = _Line1.right + 48;
            _plNum.left = _pl.right + 8;
            if (WIDHT!=414) {
                _pl.left = _Line1.right + 43;
                _plNum.left = _pl.right + 8;
            }
            _linkImage.hidden = NO;
            _linkBtn.hidden = NO;
            _Line2.hidden = NO;
            _bigL.centerX = _pl.centerX;
            _bigL.centerY = _pl.centerY;
            _Line1.left = WIDHT/3;
            _Line2.left = WIDHT/3*2;
            _plLabel.frame = _pl.frame;
            [self.contentView bringSubviewToFront:_plLabel];
            _plLabel.hidden = YES;
            
            [_plLabel setUserInteractionEnabled:YES];
            UITapGestureRecognizer *aa = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                
            }];
            [_plLabel addGestureRecognizer:aa];

        }
    }
    
    //    //时间
    _dateLabel.left = _detailLabel.left;
    _dateLabel.top = lastView.bottom+18;
    NSString * newTime = [self formateDate:model.articleTime withFormate:@"yyyyMMddHHmmss"];
    _dateLabel.text = newTime;
    CGSize dateSize = [_dateLabel sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
    _dateLabel.width = dateSize.width;
    _dateLabel.height = kDynamicsNameHeight;
    _dateLabel.textAlignment = NSTextAlignmentRight;
 
    _thumbCommentView.hidden = YES;

//    //分割线
    _dividingLine.left = 0;
    _dividingLine.height = 10;
    _dividingLine.width = SCREENWIDTH ;
    _dividingLine.bottom = layout.height - 10 +115;
}

- (void)changeStatus{
//    [_pl setUserInteractionEnabled:YES];
//    _plLabel.hidden = YES;
    _isReporting = NO;
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
        _nameLabel.font = PingFangSC_Regular(kSuitLength_H(14));
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
- (UIImageView *)guanzhuImage{
    if (!_guanzhuImage) {
        _guanzhuImage = [[UIImageView alloc]init];
    }
    return _guanzhuImage;
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
        _detailLabel.textColor = mainColor;
        _detailLabel.font = PingFangSC_Regular(kSuitLength_H(12));
//        _detailLabel.font = [UIFont fontWithName:@"Marion" size:17];
    }
    return _detailLabel;
}
-(UIButton *)moreLessDetailBtn
{
    if (!_moreLessDetailBtn) {
        _moreLessDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessDetailBtn.titleLabel.font = [UIFont systemFontOfSize:kSuitLength_H(14)];
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
-(YKCommunicationImageView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [YKCommunicationImageView new];
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
        _dateLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    }
    return _dateLabel;
}
- (UIView *)plLabel{
    if (!_plLabel) {
        _plLabel = [[UIView alloc]init];
        _plLabel.backgroundColor = [UIColor greenColor];
    }
    return _plLabel;
}
-(UIImageView *)pl {
    if (!_pl) {
        _pl = [UIImageView new];
        _pl.image = [UIImage imageNamed:@"dianzan"];
//        [_pl setBackgroundImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
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
        _plNum.font = PingFangSC_Regular(kSuitLength_H(12));
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
        _dz.image = [UIImage imageNamed:@"fenxiang-1"];
        
    }
    return _dz;
}
-(YYLabel *)dzNum
{
    if (!_dzNum) {
        _dzNum = [YYLabel new];
        _dzNum.textColor = mainColor;
        _dzNum.font = PingFangSC_Regular(kSuitLength_H(12));
    }
    return _dzNum;
}
//linkImage
-(UIImageView *)linkImage {
    if (!_linkImage) {
        _linkImage = [UIImageView new];
        _linkImage.image = [UIImage imageNamed:@"chakanshangpin"];
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
                [_linkBtn setTitle:@"查看" forState:UIControlStateNormal];
//        _linkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _linkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _linkBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
        [_linkBtn setTitleColor:mainColor forState:UIControlStateNormal];
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
-(UIView *)Line1
{
    if (!_Line1) {
        _Line1 = [UIView new];
        _Line1.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _Line1;
}
-(UIView *)Line2
{
    if (!_Line2) {
        _Line2 = [UIView new];
        _Line2.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _Line2;
}
-(UIView *)dLine
{
    if (!_dLine) {
        _dLine = [UIView new];
        _dLine.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
    return _dLine;
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
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
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
