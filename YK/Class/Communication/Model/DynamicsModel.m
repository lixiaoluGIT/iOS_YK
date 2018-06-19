//
//  DynamicsModel.m
//  LooyuEasyBuy
//
//  Created by LXL on 18/5/3.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "DynamicsModel.h"


extern CGFloat maxContentLabelHeight;

@implementation DynamicsModel
{
    CGFloat _lastContentWidth;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"DynamicsModel找不到Key----------------------------%@",key);
}
-(void)setOptthumb:(NSMutableArray *)fabulous
{
    _fabulous = fabulous;
//    self.likeArr = optthumb;
    
    //未登录不计点赞
    if ([Token length] == 0) {
        _isThumb = NO;
    }
    
    if (_fabulous.count != 0 && _fabulous != nil) {
        __block BOOL hasUserID = NO;
        [_fabulous enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //这里加入if判断如果存在于点赞列表则显示取消点赞
              if([_fabulous containsObject:[YKUserManager sharedManager].user.userId]){
                _isThumb = YES;
                hasUserID = YES;
                    }
        }];
        if (!hasUserID) {
            _isThumb = NO;
        }
    }else{
        _isThumb = NO;
    }
//    
//    _concernArray = [NSMutableArray arrayWithArray:[YKCommunicationManager sharedManager].concernArray];
//    if (_concernArray!= 0 && _concernArray != nil) {
//        __block BOOL hasConcern = NO;
//        [_concernArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //这里加入if判断如果存在于点赞列表则显示取消点赞
//            if([_concernArray containsObject:[YKUserManager sharedManager].user.userId]){
//                _isConcern = YES;
//                hasConcern = YES;
//            }
//        }];
//        if (!hasConcern) {
//            _isConcern  = NO;
//        }
//    }else{
//        _isConcern = NO;
//    }
}
- (void)setLikeArr:(NSMutableArray<DynamicsLikeItemModel *> *)likeArr
{
    NSMutableArray *tempLikes = [NSMutableArray new];
    for (id thumbDic in likeArr) {
        DynamicsLikeItemModel * likeModel = [DynamicsLikeItemModel new];
        [likeModel setValuesForKeysWithDictionary:thumbDic];
        [tempLikes addObject:likeModel];
    }
    likeArr = [tempLikes copy];
    
    _likeArr = likeArr;
}
- (void)setOptcomment:(NSMutableArray *)optcomment
{
//    _optcomment = optcomment;
//    self.commentArr = optcomment;
    
}
-(void)setCommentArr:(NSMutableArray<DynamicsCommentItemModel *> *)commentArr
{
    NSMutableArray *tempComments = [NSMutableArray new];
    for (id commentDic in commentArr) {
        DynamicsCommentItemModel * commentModel = [DynamicsCommentItemModel new];
        [commentModel setValuesForKeysWithDictionary:commentDic];
        [tempComments addObject:commentModel];
    }
    commentArr = [tempComments copy];
    
    _commentArr = commentArr;
}
-(NSString *)articleContent
{
    if (_articleContent == nil) {
        _articleContent = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_articleContent];
    text.font = [UIFont systemFontOfSize:14];
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(SCREENWIDTH - 15 - 45 - 10 - 15, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    if (layout.rowCount <=3) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
    
    return _articleContent;
}
- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end

@implementation DynamicsLikeItemModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"DynamicsLikeItemModel找不到Key----------------------------%@",key);
}


@end

@implementation DynamicsCommentItemModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"DynamicsCommentItemModel找不到Key----------------------------%@",key);
}

@end


