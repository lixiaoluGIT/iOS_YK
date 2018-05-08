//
//  TopPublicVC.m
//  TopAPP
//
//  Created by LXL on 2018/3/13.
//  Copyright © 2018年 LXL. All rights reserved.
//

#import "TopPublicVC.h"
#import "ZYQAssetPickerController.h"
#import "PlaceholderTextView.h"

#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define imageW 101*WIDHT/375

@interface TopPublicVC ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIView               *_editv;
    PlaceholderTextView *textView;
    UILabel              *_placeholderLabel;
    UIButton             *_addPic;
    NSMutableArray       *_imageArray;
}
@end

@implementation TopPublicVC


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    self.title = @"晒一晒";
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(Public)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    _imageArray = [NSMutableArray array];
    
    // 评论 + 照片
    _editv = [[UIView alloc] initWithFrame:CGRectMake(0, BarH, ScreenWidth, 0)];
    _editv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_editv];
    
    // 评论 UITextView
//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(_editv.frame)-15*2, 70)];
//    _textView.backgroundColor = [UIColor lightGrayColor];
//    _textView.delegate = self;
//    [_textView becomeFirstResponder];
//    _textView.text = @"说点什么吧";
//    [_editv addSubview:_textView];
//    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, _editv.frame.size.width-30, 100)];
//    _textView.delegate = self;
//    _textView.text = @"说点什么吧";
//    [_editv addSubview:_textView];
    textView = [[PlaceholderTextView alloc]init];
    textView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"说点什么吧";
    textView.font = [UIFont systemFontOfSize:15];
    textView.frame = CGRectMake(24, 20, _editv.frame.size.width-48, 120);
    textView.maxLength = 140;
    textView.layer.cornerRadius = 5.f;
    textView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3].CGColor;
//    textView.layer.borderWidth = 0.5f;
    [_editv addSubview:textView];
    
    [textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
    }];
    // 提示字
//    _placeholderLabel = [[UILabel alloc] init];
//    _placeholderLabel.frame =CGRectMake(5, 6, CGRectGetWidth(_editv.frame)-15*4, 20);
//    _placeholderLabel.text = @"说点什么吧";
//    _placeholderLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
//    _placeholderLabel.font = [UIFont systemFontOfSize:12.0];
//    _placeholderLabel.enabled = NO; // lable必须设置为不可用
//    _placeholderLabel.backgroundColor = [UIColor lightGrayColor];
//    [_textView addSubview:_placeholderLabel];
    
    // + pic
    _addPic = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPic.frame = CGRectMake(24, CGRectGetMaxY(textView.frame)+24, imageW, imageW);
    [_addPic setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [_addPic addTarget:self action:@selector(addPicEvent) forControlEvents:UIControlEventTouchUpInside];
    [_editv addSubview:_addPic];
    _editv.frame = CGRectMake(0, BarH, ScreenWidth, CGRectGetMaxY(_addPic.frame)+24);
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"说点什么吧";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"说点什么吧"]){
        textView.text=@"";
        textView.textColor=[UIColor colorWithHexString:@"676869"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)leftAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)Public{
    if (_imageArray.count==0) {
        [smartHUD alertText:self.view alert:@"请添加要晒的图片" delay:1.4];
        return;
    }
    
    [[YKCommunicationManager sharedManager]publicWithImageArray:_imageArray clothingId:@"2" text:textView.text OnResponse:^(NSDictionary *dic) {
        [self leftAction];
    }];
}

#pragma mark - UIbutton event

- (void)addPicEvent
{
    if (_imageArray.count >= 9) {
        NSLog(@"最多只能上传9张图片");
    } else {
        [self selectPictures];
    }
}

// 本地相册选择多张照片
- (void)selectPictures
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9-_imageArray.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                              {
                                  if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
                                  {
                                      NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                      
                                      return duration >= 5;
                                  } else {
                                      return YES;
                                  }
                              }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// 9宫格图片布局
- (void)nineGrid
{
    for (UIImageView *imgv in _editv.subviews)
    {
        if ([imgv isKindOfClass:[UIImageView class]]) {
            [imgv removeFromSuperview];
        }
    }
    
    CGFloat width = imageW;
    CGFloat widthSpace = (ScreenWidth - 48 - imageW*3) / 2.0;
    CGFloat heightSpace = 12;
    
    NSInteger count = _imageArray.count;
    _imageArray.count > 9 ? (count = 9) : (count = _imageArray.count);
    
    for (int i=0; i<count; i++)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(24+(width+widthSpace)*(i%3), (i/3)*(width+heightSpace) + CGRectGetMaxY(textView.frame)+24, width, width)];
        imgv.image = _imageArray[i];
        imgv.userInteractionEnabled = YES;
        [_editv addSubview:imgv];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(width-25,0, 25, 25);
//        delete.backgroundColor = [UIColor greenColor];
        [delete setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = 10+i;
        [imgv addSubview:delete];
        [imgv setContentMode:UIViewContentModeScaleAspectFill];
        imgv.layer.masksToBounds = YES;
        
        if (i == _imageArray.count - 1)
        {
            if (_imageArray.count % 3 == 0) {
                _addPic.frame = CGRectMake(24, CGRectGetMaxY(imgv.frame) + heightSpace, imageW, imageW);
            } else {
                _addPic.frame = CGRectMake(CGRectGetMaxX(imgv.frame) + widthSpace, CGRectGetMinY(imgv.frame), imageW, imageW);
            }
            
            _editv.frame = CGRectMake(0, BarH, ScreenWidth, CGRectGetMaxY(_addPic.frame)+20);
        }
    }
}

// 删除照片
- (void)deleteEvent:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    [_imageArray removeObjectAtIndex:btn.tag-10];
    
    [self nineGrid];
    
    if (_imageArray.count == 0)
    {
        _addPic.frame = CGRectMake(24, CGRectGetMaxY(textView.frame)+24, imageW, imageW);
        _editv.frame = CGRectMake(0, BarH, ScreenWidth, CGRectGetMaxY(_addPic.frame)+20);
    }
}

#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       for (int i=0; i<assets.count; i++)
                       {
                           ALAsset *asset = assets[i];
                           UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                           [_imageArray addObject:tempImg];
                           
                           if (_imageArray.count==9) {
                               _addPic.hidden = YES;
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self nineGrid];
                           });
                       }
                   });
    
    
}

#pragma makr - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"在此编辑您的而分享内容!";
    } else {
        _placeholderLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
