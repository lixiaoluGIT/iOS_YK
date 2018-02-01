 //
//  YLResumeActionSheetController.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "YLAwesomeSheetController.h"
#import "YLAwesomeData.h"

#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height

static CGFloat maxHeight = 165;
static CGFloat headerHeight = 50;
static CGFloat cellHeight = 40;

@interface YLAwesomeSheetController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,copy)NSArray *currentMonths;///< 当前年份可选的最大月份
@property(nonatomic,copy)NSArray *monthArray;///< 1~12月
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *ensureBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIPickerView *picker;

@property(nonatomic,assign)NSInteger componentCount;///< the total component count
@property(nonatomic,strong)NSMutableArray *tmpSelectedData;///< contains the temp selectd data in each component

@property (nonatomic,strong)NSString *sexString;
@end

@implementation YLAwesomeSheetController
- (instancetype)initWithTitle:(NSString *)title config:(id<YLAwesomeDataDelegate>)config callBack:(YLAwesomeSheetSelectCallBack)callBack
{
    if(self = [super init]){
        self.titleLabel.text = title;
        self.dataConfiguration = config;
        self.callBack = callBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [self.view addGestureRecognizer:tapGesture];
    [self.view addSubview:self.contentView];
    [self fetchData];
    [self showContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kFrameHeight, kFrameWidth, maxHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.cancelBtn];
        [_contentView addSubview:self.titleLabel];
        [_contentView addSubview:self.ensureBtn];
       
        [_contentView addSubview:self.picker];
    }
    return _contentView;
}

- (UIButton *)cancelBtn
{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIColor *titleColor = [UIColor colorWithHexString:@"676869"];
        [_cancelBtn setTitleColor:titleColor forState:UIControlStateNormal];
       
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.frame = CGRectMake(20, 0, 50, headerHeight);
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn
{
    if(!_ensureBtn){
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIColor *titleColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_ensureBtn setTitleColor:titleColor forState:UIControlStateNormal];
        
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.frame = CGRectMake(kFrameWidth - 70, 0, 50, headerHeight);
    }
    return _ensureBtn;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(60, 0, kFrameWidth - 120, headerHeight);
    }
    return _titleLabel;
}


- (UIPickerView *)picker
{
    if(!_picker)
    {
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, headerHeight + 1, kFrameWidth, maxHeight - headerHeight - 1)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = NO;
       
    }
    return _picker;
}

- (void)fetchData
{
    _componentCount = [_dataConfiguration numberOfComponents];
    _tmpSelectedData = [NSMutableArray arrayWithCapacity:_componentCount];
    [self.picker reloadAllComponents];
    
    for(NSInteger i = 0; i < _componentCount; i++){
        YLAwesomeData *selectedData = [_dataConfiguration defaultSelectDataInComponent:i];
        if(!selectedData){
            NSArray *currentDatas = _dataConfiguration.dataSource[@(i)];
            if(currentDatas.count > 0){
                selectedData = currentDatas[0];
            }
        }
        
        if(selectedData){
            NSArray *array = _dataConfiguration.dataSource[@(i)];
            NSInteger row = [array indexOfObject:selectedData];
            if(row != NSNotFound){
                [_picker selectRow:row inComponent:i animated:NO];
                [self pickerView:_picker didSelectRow:row inComponent:i];
            }
        }
    }
}


#pragma mark ---UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if(component < _componentCount){
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        return array.count;
    }
    return 0;
}

#pragma mark ---UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.bounds.size.width / _componentCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return cellHeight;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if(component < _componentCount){
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        if(array.count > row){
            YLAwesomeData *data = array[row];
            title = data.name;
        }
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component < _componentCount){
        
        NSArray *array = _dataConfiguration.dataSource[@(component)];
        YLAwesomeData *currentData = array[row];
        NSLog(@"%@",currentData.name);
        self.sexString = currentData.name;
    }
}

- (void)showContentView
{
    if(_contentView){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _contentView.frame;
            frame.origin.y = kFrameHeight - maxHeight;
            _contentView.frame = frame;
        }];
    }
}

- (void)dismissContentView
{
    if(_contentView){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _contentView.frame;
            frame.origin.y = kFrameHeight;
            _contentView.frame = frame;
            self.view.alpha = 0;
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }else{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

- (void)showInController:(UIViewController *)controller
{
    if(controller && [controller isKindOfClass:[UIViewController class]]){
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.view];
        [controller addChildViewController:self];
    }
}

#pragma mark---other methods
- (void)cancel
{
    [_tmpSelectedData removeAllObjects];
    [self dismissContentView];
}

- (void)ensure
{
    if (self.sexString.length==0) {
        self.sexString = @"男";
    }
    if(_callBack){
        _callBack(self.sexString);
    }
    [self dismissContentView];
}

@end
