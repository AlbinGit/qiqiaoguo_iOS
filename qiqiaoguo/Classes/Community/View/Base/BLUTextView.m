//
//  BLUTextView.m
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUTextView.h"

@interface BLUTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation BLUTextView

#pragma mark - Accessors

- (void)setText:(NSString *)string {
    [super setText:string];
    [self configurePlaceholder];
}


- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self configurePlaceholder];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self configurePlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }

    _placeholder = string;
    [self configurePlaceholder];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self configurePlaceholder];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self configurePlaceholder];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self configurePlaceholder];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self configurePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self configurePlaceholder];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self configurePlaceholder];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

#pragma mark - Placeholder

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);

    if (self.typingAttributes) {
        NSParagraphStyle *style = self.typingAttributes[NSParagraphStyleAttributeName];
        if (style) {
            rect.origin.x += style.headIndent;
            rect.origin.y += style.firstLineHeadIndent;
        }
    }

    // BAD:不清楚为什么会产生的偏移
    rect.origin.x += BLUThemeMargin * 1.5;

    return rect;
}

- (void)configurePlaceholder {
    if (self.text.length == 0 && (_placeholder || _attributedPlaceholder)) {
        CGRect rect = [self placeholderRectForBounds:self.bounds];

        UIFont *font = self.font ? self.font : self.typingAttributes[NSFontAttributeName];

        _placeholderLabel.textColor = _placeholderTextColor;
        _placeholderLabel.font = font;
        _placeholderLabel.text = self.placeholder;
        if (_attributedPlaceholder) {
            _placeholderLabel.attributedText = _attributedPlaceholder;
        }

        CGSize size = [_placeholderLabel sizeThatFits:CGSizeMake(rect.size.width, CGFLOAT_MAX)];

        _placeholderLabel.frame = CGRectMake(rect.origin.x,
                                             rect.origin.y,
                                             size.width,
                                             size.height);

        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
    }
}

#pragma mark - Private

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    _placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _placeholderLabel = [UILabel new];
    _placeholderLabel.numberOfLines = 0;
    [self addSubview:_placeholderLabel];
    [self configurePlaceholder];
}

- (void)textChanged:(NSNotification *)notification {
    [self configurePlaceholder];
}

@end
