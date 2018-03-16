//
//  PlaceholderTextView.m
//  imssee
//
//  Created by subai on 16/1/8.
//  Copyright © 2016年 鑫易. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@property (strong, nonatomic) NSString *currentText;
@end


@implementation PlaceholderTextView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self setView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self addObserver];
        [self setView];


    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        [self addObserver];
        [self setView];
    }
    return self;
}
-(void)setView{
    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.width, self.frame.size.height)];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [self font];
        [self addSubview:self.placeholderLabel];
        
        super.delegate = self;

    }
    
    if (!self.wordNumLabel) {
        
        self.wordNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.wordNumLabel.font = [UIFont systemFontOfSize:13];
        self.wordNumLabel.textColor = [UIColor lightGrayColor];
        self.wordNumLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.wordNumLabel];
        

    }
   
}

-(void)layoutSubviews{
    self.placeholderLabel.frame = CGRectMake(8, 6.5, self.frame.size.width-8, self.frame.size.height);
    [self.placeholderLabel sizeToFit];
    [self.wordNumLabel sizeToFit];
    [self refreshFram];
}
-(void)addObserver
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeholderTextViewdidChange:) name:UITextViewTextDidChangeNotification object:self];

   

}


-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFit];
    [self endEditing:NO];
}
-(void)setMaxLength:(NSInteger)maxLength{
    
    _maxLength = maxLength;
    self.wordNumLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
    
}
-(void)placeholderTextViewdidChange:(NSNotification *)notificat{
    
    PlaceholderTextView *textView = (PlaceholderTextView *)notificat.object;
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];

    }
    
    if ([textView.text length]>self.maxLength&&self.maxLength!=0&&textView.markedTextRange == nil) {
        
       
        textView.text = [textView.text substringToIndex:self.maxLength];
     
    }
    self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[textView.text length],(long)_maxLength];
    if (self.didChangeText) {
        self.didChangeText(textView);
    }

    [self refreshFram];
    _currentText = textView.text;

}


- (void)didChangeText:(void (^)(PlaceholderTextView *))block{
    self.didChangeText = block;
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length>0) {
        [self.placeholderLabel setHidden:YES];
        self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[text length],(long)_maxLength];
        [self.wordNumLabel sizeToFit];
        [self refreshFram];
      
    }
}


-(void)placeholderTextViewEndEditing{
    
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
        
    }
}

- (void)refreshFram{
    [self.wordNumLabel sizeToFit];
    if (self.contentSize.height>self.frame.size.height-self.wordNumLabel.frame.size.height-5) {
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.contentSize.height+self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, self.wordNumLabel.frame.size.height, 0);
        
    }else{
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.frame.size.height + self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
