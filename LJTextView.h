//
//  LJTextView.h
//  adfaf
//
//  Created by libin on 2016/11/7.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJTextView;
@protocol LJTextViewDelegate <NSObject>

@optional
- (void)LJTextViewDidChange:(LJTextView *)textView height:(CGFloat)height;

@end

@interface LJTextView : UIView

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, assign) CGFloat mixHegith;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, weak) id<LJTextViewDelegate> textDelegate;

@end
