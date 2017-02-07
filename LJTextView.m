//
//  LJTextView.m
//  adfaf
//
//  Created by libin on 2016/11/7.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制字体与控件边界的间隙

@end

@implementation CustomLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

#import "LJTextView.h"
#define KMaxDefaultHeiht 60.0f
#define KMixDefaultHeiht 30.0f


@interface LJTextView ()<UITextViewDelegate>

@property (nonatomic, weak) CustomLabel *placeholderLabel;

@property (nonatomic, weak) UITextView *textView;

@end

@implementation LJTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
    textView.delegate = self;
    textView.showsVerticalScrollIndicator = NO;
    [self addSubview:textView];
    self.textView = textView;
    CGFloat inset = (self.frame.size.height - [textView contentSize].height) * 0.5;
    textView.contentInset = UIEdgeInsetsMake(inset, textView.contentInset.left, inset, textView.contentInset.right);
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    CustomLabel *placeholderLabel = [[CustomLabel alloc] initWithFrame:self.bounds];
    placeholderLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    placeholderLabel.textColor = [UIColor grayColor];
    [self addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    self.textView.font = _font;
    self.placeholderLabel.font = _font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.textView.textAlignment = _textAlignment;
    self.placeholderLabel.textAlignment = _textAlignment;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    self.backgroundColor = _backColor;
    self.textView.backgroundColor = _backColor;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
    CGFloat maxHeight = self.maxHeight ? self.maxHeight : KMaxDefaultHeiht;;
    CGFloat mixHeight = self.mixHegith ? self.mixHegith : KMixDefaultHeiht;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height > frame.size.height) {
        if (size.height >= maxHeight) {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        } else {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }else{
        if (size.height < mixHeight) {
            size.height = mixHeight;
        }
        textView.contentSize = textView.frame.size;
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    CGRect rect = self.frame;
    rect.size.height = textView.frame.size.height;
    self.frame = rect;
    self.placeholderLabel.frame = textView.frame;
    if ([self.textDelegate respondsToSelector:@selector(LJTextViewDidChange:height:)]) {
        [self.textDelegate LJTextViewDidChange:self height:textView.frame.size.height];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        UITextView *textView = object;
        CGFloat height = textView.frame.size.height < self.frame.size.height ? self.frame.size.height : textView.frame.size.height;
        CGFloat deadSpace = (height - [textView contentSize].height);
        CGFloat inset = MAX(0, deadSpace/2.0);
        textView.contentInset = UIEdgeInsetsMake(inset, textView.contentInset.left, inset, textView.contentInset.right);
    }
}

@end
